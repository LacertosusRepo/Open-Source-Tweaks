#import "LBMRootListController.h"

@implementation LBMRootListController
	-(instancetype)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.navigationBarBackgroundColor = Sec_Color;
			appearanceSettings.navigationBarTintColor = Pri_Color;
			appearanceSettings.showsNavigationBarShadow = NO;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			NSArray *chosenIDs = @[@"GESTURE_OPTIONS"];
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

		[self toggleSpecifiersVisibility:YES];
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		[self toggleSpecifiersVisibility:NO];
	}

	-(void)toggleSpecifiersVisibility:(BOOL)animated {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];

		if(![preferences boolForKey:@"hideGesture"]) {
			[self removeSpecifier:self.savedSpecifiers[@"GESTURE_OPTIONS"] animated:animated];
		} else if(![self containsSpecifier:self.savedSpecifiers[@"GESTURE_OPTIONS"]]) {
			[self insertSpecifier:self.savedSpecifiers[@"GESTURE_OPTIONS"] afterSpecifierID:@"ENABLE_GESTURES" animated:animated];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		self.navigationController.navigationBar.prefersLargeTitles = NO;
		self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

		//Adds respring button in top right of preference pane and hide any specifiers
		[self respringStateFromButton:nil];
		[self toggleSpecifiersVisibility:NO];

		//Adds header to table
		NSArray *subtitles = @[@"Check out the source code on github!", @"Customizable notepad on your lockscreen", @"Customizable notepad in your notification center", @"Why did the bike fall over? It was too tired.", @"What do you call a clever duck? A wise quacker."];
		LBMHeaderView *header = [[LBMHeaderView alloc] initWithTitle:@"Libellum" subtitles:subtitles bundle:[self bundle]];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = header;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];

		self.title = @"Libellum";
	}

	-(void)respringStateFromButton:(UIBarButtonItem *)button {
		switch (button.tag) {
			case 0: //Apply
			{
				UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringStateFromButton:)];
				applyButton.tintColor = Pri_Color;
				applyButton.tag = 1;
				[self.navigationItem setRightBarButtonItem:applyButton animated:YES];
			}
			break;

			case 1:	//Are you sure?
			{
				UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Are you sure?" style:UIBarButtonItemStyleDone target:[HBRespringController class] action:@selector(respring)];
				respringButton.tintColor = [UIColor colorWithRed:0.90 green:0.23 blue:0.23 alpha:1.00];
				respringButton.tag = 0;
				[self.navigationItem setRightBarButtonItem:respringButton animated:YES];

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self respringStateFromButton:respringButton];
				});
			}
			break;
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		if(!self.navigationItem.titleView) {
			LBMAnimatedTitleView *titleView = [[LBMAnimatedTitleView alloc] initWithTitle:@"Libellum" minimumScrollOffsetRequired:90];
			self.navigationItem.titleView = titleView;
		}
	}

	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)]) {
			[(LBMAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];
		}
	}

	-(void)manageBackup:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		LBMNoteBackupViewController *backupViewController = [[LBMNoteBackupViewController alloc] init];
		[self presentViewController:backupViewController animated:YES completion:^{
			cell.cellEnabled = YES;
		}];
	}

	-(UIUserInterfaceStyle)overrideUserInterfaceStyle {
		return UIUserInterfaceStyleDark;
	}
@end
