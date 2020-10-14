#include "DIPModifyCachedAppColorsController.h"

@implementation DIPModifyCachedAppColorsController
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
			self.title = @"";
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.dockindicatorsprefs"];
			_cachedAppColors = ([[preferences objectForKey:@"appColorCache"] mutableCopy]);

			NSMutableArray *appColorSpecifiers = [[NSMutableArray alloc] init];
			PSSpecifier *groupSpecifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			[groupSpecifier setProperty:@"Modify existing average app colors. Swipe to delete colors which will recalculate the average color." forKey:@"footerText"];
			[appColorSpecifiers addObject:groupSpecifier];

			for(NSString *bundleID in _cachedAppColors) {
				PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
				[specifier setProperty:@YES forKey:@"enabled"];
				[specifier setProperty:@44 forKey:@"height"];
        [specifier setProperty:[DIPAppColorCell class] forKey:@"cellClass"];
				[specifier setProperty:self forKey:@"delegate"];
				[specifier setProperty:bundleID forKey:@"bundleID"];
				[specifier setProperty:_cachedAppColors[bundleID] forKey:@"hexColor"];
				[appColorSpecifiers addObject:specifier];
			}

			_specifiers = [appColorSpecifiers copy];
		}

		return _specifiers;
	}

	-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		return YES;
	}

	-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if(editingStyle == UITableViewCellEditingStyleDelete) {
			PSSpecifier *specifierToBeRemoved = [self specifierAtIndexPath:indexPath];
			[self removeSpecifier:specifierToBeRemoved animated:YES];

			[_cachedAppColors removeObjectForKey:[specifierToBeRemoved propertyForKey:@"bundleID"]];

			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.dockindicatorsprefs"];
			[preferences setObject:_cachedAppColors forKey:@"appColorCache"];
		}
	}

	-(void)didSelectColorWithHex:(NSString *)hex forBundleID:(NSString *)bundle {
		if(![hex isEqualToString:_cachedAppColors[bundle]]) {
			[_cachedAppColors setObject:hex forKey:bundle];

			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.dockindicatorsprefs"];
			[preferences setObject:_cachedAppColors forKey:@"appColorCache"];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Modify App Colors";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Pri_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;

		[UIView animateWithDuration:0.2 animations:^{
			self.navigationItem.titleView.alpha = 1;
		}];
	}
@end
