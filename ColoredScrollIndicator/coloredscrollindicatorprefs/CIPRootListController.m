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
		UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respring)];
		self.navigationItem.rightBarButtonItem = respringButton;

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

	-(void)respring {
		[HBRespringController respring];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
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
