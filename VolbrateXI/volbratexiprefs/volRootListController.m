#include "VOLRootListController.h"

@implementation VOLRootListController

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

	-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		UIView *VOLHeaderView = [[VOLHeaderCell alloc] init];
		VOLHeaderView.frame = CGRectMake(0, 0, VOLHeaderView.bounds.size.width, 150);
		tableView.tableHeaderView = VOLHeaderView;
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/volbratexiprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		//Adds header to table
		UIView *VOLHeaderView = [[VOLHeaderCell alloc] init];
		VOLHeaderView.frame = CGRectMake(0, 0, VOLHeaderView.bounds.size.width, 150);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = VOLHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"VolbrateXI";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	//https://github.com/Nepeta/Axon/blob/master/Prefs/Preferences.m
	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		CGFloat offsetY = scrollView.contentOffset.y;
		if(offsetY > 100) {
			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
			}];
		} else {
			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 0;
			}];
		}
	}

	-(void)sendTestVibtration:(PSSpecifier *)specifier	{
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.volbratexi-testvibration"), nil, nil, true);
	}

@end
