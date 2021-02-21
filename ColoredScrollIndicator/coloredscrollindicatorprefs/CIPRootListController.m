#include "CIPRootListController.h"

@implementation CIPRootListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Sec_Color;
			appearanceSettings.navigationBarTintColor = Sec_Color;
			appearanceSettings.navigationBarBackgroundColor = Pri_Color;
			appearanceSettings.statusBarTintColor = Sec_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		//Adds respring button in top right of preference pane
		[self respringApply];

		//Adds header to table
		UIView *CIPHeaderView = [[CIPHeaderCell alloc] init];
		CIPHeaderView.frame = CGRectMake(0, 0, CIPHeaderView.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = CIPHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Colored Scroll";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;

		[super viewDidAppear:animated];
	}

	-(void)respringApply {
		_respringApplyButton = (_respringApplyButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
		_respringApplyButton.tintColor = Sec_Color;
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

	//https://github.com/Nepeta/Axon/blob/master/Prefs/Preferences.m
	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		CGFloat offsetY = scrollView.contentOffset.y;
		if(offsetY > 120) {
			[UIView animateWithDuration:0.4 animations:^{
				self.navigationItem.titleView.alpha = 1;
				self.navigationItem.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
			}];
		} else {
			[UIView animateWithDuration:0.4 animations:^{
				self.navigationItem.titleView.alpha = 0;
				self.navigationItem.titleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
			}];
		}
	}

	-(void)flipGradient:(PSSpecifier *)specifer {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
		NSString *oldColorOne = [preferences objectForKey:@"gradientColorOne"];
		NSString *oldColorTwo = [preferences objectForKey:@"gradientColorTwo"];

		[preferences setObject:oldColorTwo forKey:@"gradientColorOne"];
		[preferences setObject:oldColorOne forKey:@"gradientColorTwo"];
	}

@end
