#include "LBMRootListController.h"

@implementation LBMRootListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Sec_Color;
			appearanceSettings.navigationBarTintColor = Pri_Color;
			appearanceSettings.navigationBarBackgroundColor = Alt_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			NSArray *chosenIDs = @[@"IgnoreAdaptivePresetColors", @"SetSolidColor", @"FeedbackStyle", @"SwipeLeftOnNotes", @"TripleTapLockScreen"];
			self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
			for(PSSpecifier *specifier in [self specifiers]) {
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
		if([key isEqualToString:@"blurStyle"]) {
			if(![value isEqualToString:@"adaptive"]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]] afterSpecifierID:@"BlurStyle" animated:YES];
			}

			if(![value isEqualToString:@"colorized"]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SetSolidColor"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"SetSolidColor"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"SetSolidColor"]] afterSpecifierID:@"BlurStyle" animated:YES];
			}
		}

		if([key isEqualToString:@"feedback"]) {
			if(![value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"FeedbackStyle"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] afterSpecifierID:@"Haptic Feedback" animated:YES];
			}
		}

		if([key isEqualToString:@"hideGesture"]) {
			if(![value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"TripleTapLockScreen"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"TripleTapLockScreen"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"TripleTapLockScreen"]] afterSpecifierID:@"EnableGestures" animated:YES];
			}

			if(![value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SwipeLeftOnNotes"]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"SwipeLeftOnNotes"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"SwipeLeftOnNotes"]] afterSpecifierID:@"EnableGestures" animated:YES];
			}
		}
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"adaptive"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]] animated:YES];
		}

		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"colorized"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SetSolidColor"]] animated:YES];
		}

		if(![preferences boolForKey:@"feedback"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] animated:YES];
		}

		if(![preferences boolForKey:@"hideGesture"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SwipeLeftOnNotes"], self.savedSpecifiers[@"TripleTapLockScreen"]] animated:YES];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"adaptive"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]] animated:YES];
		}

		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"colorized"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SetSolidColor"]] animated:YES];
		}

		if(![[preferences objectForKey:@"feedback"] boolValue]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"FeedbackStyle"]] animated:YES];
		}

		if(![preferences boolForKey:@"hideGesture"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SwipeLeftOnNotes"], self.savedSpecifiers[@"TripleTapLockScreen"]] animated:YES];
		}

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		//Adds respring button in top right of preference pane
		UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respring)];
		self.navigationItem.rightBarButtonItem = respringButton;

		//Adds header to table
		UIView *LBMHeaderView = [[LBMHeaderCell alloc] init];
		LBMHeaderView.frame = CGRectMake(0, 0, LBMHeaderView.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = LBMHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Libellum";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Pri_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;
	}

	-(void)respring {
		if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Are you sure?"]) {
			[HBRespringController respring];
		} else {
			self.navigationItem.rightBarButtonItem.title = @"Are you sure?"
			self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				self.navigationItem.rightBarButtonItem.title = @"Apply";
				self.navigationItem.rightBarButtonItem.tintColor = Pri_Color;
			});
		}
	}

	//https://github.com/Nepeta/Axon/blob/master/Prefs/Preferences.m
	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		CGFloat offsetY = scrollView.contentOffset.y;
		if(offsetY > 120) {
			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
				self.navigationItem.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
			}];

		} else {
			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 0;
				self.navigationItem.titleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
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
