#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>

#import "INDRootListController.h"
#import "libDeusPrefs.h"
#import "PreferencesColorDefinitions.h"

@implementation INDRootListController
	-(instancetype)init {
		self = [super init];

		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.navigationBarTintColor = Sec_Color;
			appearanceSettings.navigationBarBackgroundColor = Pri_Color;
			appearanceSettings.showsNavigationBarShadow = NO;
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

		self.navigationController.navigationBar.prefersLargeTitles = NO;
		self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

		NSArray *subtitles = @[@"Check out the source code on github!", @"Right there in the status bar", @"For more than just for the flashlight now!", @"What's orange and sounds like a carrot? A parrot."];
		NSDictionary *options = @{LDHeaderOptionTitleFontSize : @40, LDHeaderOptionSubtitleFontColor : Pri_Color, LDHeaderOptionHeaderStyle : @(LDHeaderStyleHorizontalIconRight)};

		LDHeaderView *header = [[LDHeaderView alloc] initWithTitle:@"Indicators" subtitles:subtitles bundle:[self bundle] options:options];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 125);
		self.table.tableHeaderView = header;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		if(!self.navigationItem.titleView) {
			LDAnimatedTitleView *titleView = [[LDAnimatedTitleView alloc] initWithTitle:@"Indicators" textColor:Sec_Color minimumScrollOffsetRequired:-15];
			self.navigationItem.titleView = titleView;
		}
	}

	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
		if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)]) {
			[(LDAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];
		}
	}

	-(UITableViewStyle)tableViewStyle {
		return UITableViewStyleInsetGrouped;
	}
@end
