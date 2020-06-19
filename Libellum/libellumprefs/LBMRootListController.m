#include "LBMRootListController.h"

@implementation LBMRootListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.navigationBarTintColor = Pri_Color;
			appearanceSettings.navigationBarBackgroundColor = Sec_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			NSArray *chosenIDs = @[@"FeedbackStyle", @"GestureOptions"];
			self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
			for(PSSpecifier *specifier in _specifiers) {
				if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
					[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
				}
			}
		}

		return _specifiers;
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		[super setPreferenceValue:value specifier:specifier];

		NSString *key = [specifier propertyForKey:@"key"];
		if([key isEqualToString:@"feedback"]) {
			if(![value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"FeedbackStyle"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] afterSpecifierID:@"Haptic Feedback" animated:YES];
			}
		}

		if([key isEqualToString:@"hideGesture"]) {
			if(![value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GestureOptions"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"GestureOptions"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GestureOptions"]] afterSpecifierID:@"EnableGestures" animated:YES];
			}
		}
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
		if(![preferences boolForKey:@"feedback"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] animated:YES];
		}

		if(![preferences boolForKey:@"hideGesture"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GestureOptions"]] animated:YES];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		//Adds respring button in top right of preference pane and hide any specifiers
		[self respringApply];
		[self reloadSpecifiers];

		//Adds header to table
		UIView *header = [[LBMHeaderView alloc] init];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = header;
	}

	-(void)respringApply {
		_respringApplyButton = (_respringApplyButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
		_respringApplyButton.tintColor = Pri_Color;
		[self.navigationItem setRightBarButtonItem:_respringApplyButton animated:YES];
	}

	-(void)respringConfirm {
		if([self.navigationItem.rightBarButtonItem isEqual:_respringConfirmButton]) {
			[HBRespringController respring];
		} else {
			_respringConfirmButton = (_respringConfirmButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Are you sure?" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
			_respringConfirmButton.tintColor = [UIColor colorWithRed:0.90 green:0.23 blue:0.23 alpha:1.00];
			[self.navigationItem setRightBarButtonItem:_respringConfirmButton animated:YES];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self respringApply];
			});
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		if(!self.navigationItem.titleView) {
			UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
			title.text = @"Libellum";
			title.textAlignment = NSTextAlignmentCenter;
			title.textColor = Pri_Color;
			title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
			self.navigationItem.titleView = title;
			self.navigationItem.titleView.alpha = 0;

			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
			}];
		}
	}

	-(void)manageBackup:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		LBMNoteBackupViewController *backupViewController = [[NSClassFromString(@"LBMNoteBackupViewController") alloc] init];
		[self presentViewController:backupViewController animated:YES completion:^{
			cell.cellEnabled = YES;
		}];
	}

@end
