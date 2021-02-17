#include "PTCRootListController.h"

@implementation PTCRootListController

	-(id)init {
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
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		//Adds header to table
		PTCHeaderView *header = [[PTCHeaderView alloc] initWithBundle:[self bundle]];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 125);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = header;
	}

@end
