#include "CIPRootListController.h"
#import "libcolorpicker.h"

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

			/*NSArray *chosenIDs = @[@""];
			self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
			for(PSSpecifier *specifier in [self specifiers]) {
				if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
					[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
				}
			}*/
		}

		return _specifiers;
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		[super setPreferenceValue:value specifier:specifier];

		self.navigationItem.rightBarButtonItem.enabled = YES;

		/*NSString *key = [specifier propertyForKey:@"key"];
		if([key isEqualToString:@""]) {
			if([value boolValue]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@""]] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@""]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@""]] afterSpecifierID:@"" animated:YES];
			}
		}*/
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		/*HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo."];
		if([[preferences objectForKey:@""] boolValue]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@""]] animated:YES];
		}*/

		//Adds respring button in top right of preference pane
		UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respring)];
		self.navigationItem.rightBarButtonItem = respringButton;
		self.navigationItem.rightBarButtonItem.enabled = NO;

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

	-(void)colorPickerOne {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
		NSString *gradientColorOne = [preferences objectForKey:@"gradientColorOne"];

		UIColor *startColor = LCPParseColorString(gradientColorOne, @"#8693AB");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"gradientColorOne"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.coloredscrollindicatorprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

	-(void)colorPickerTwo {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
		NSString *gradientColorTwo = [preferences objectForKey:@"gradientColorTwo"];

		UIColor *startColor = LCPParseColorString(gradientColorTwo, @"#BDD4E7");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"gradientColorTwo"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.coloredscrollindicatorprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

	-(void)colorPickerBorder {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
		NSString *gradientBorderColor = [preferences objectForKey:@"gradientBorderColor"];

		UIColor *startColor = LCPParseColorString(gradientBorderColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"gradientBorderColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.coloredscrollindicatorprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

	-(void)flipGradient:(PSSpecifier *)specifer {
		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
		NSString *oldColorOne = [preferences objectForKey:@"gradientColorOne"];
		NSString *oldColorTwo = [preferences objectForKey:@"gradientColorTwo"];

		[preferences setObject:oldColorTwo forKey:@"gradientColorOne"];
		[preferences setObject:oldColorOne forKey:@"gradientColorTwo"];
	}

@end
