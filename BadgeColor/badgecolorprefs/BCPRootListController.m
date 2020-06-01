#include "BCPRootListController.h"

@implementation BCPRootListController

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
	}

	-(void)viewDidAppear:(BOOL)animated {
		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"BadgeColor";
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

	//https://github.com/Nepeta/Axon/blob/master/Prefs/Preferences.m
	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		CGFloat offsetY = scrollView.contentOffset.y;
		if(offsetY > 100) {
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

@end
