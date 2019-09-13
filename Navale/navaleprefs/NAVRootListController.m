#include "NAVRootListController.h"

@implementation NAVRootListController

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

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/navaleprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		//Adds header to table
		UIView *NAVHeaderView = [[NAVHeaderCell alloc] init];
		NAVHeaderView.frame = CGRectMake(0, 0, NAVHeaderView.bounds.size.width, 150);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = NAVHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Navale";
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

	-(void)colorPickerOne {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.navaleprefs"];
		NSString *colorOneString = [preferences objectForKey:@"colorOneString"];

		UIColor *startColor = LCPParseColorString(colorOneString, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"colorOneString"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

	-(void)colorPickerTwo {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.navaleprefs"];
		NSString *colorTwoString = [preferences objectForKey:@"colorTwoString"];

		UIColor *startColor = LCPParseColorString(colorTwoString, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"colorTwoString"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

	-(void)colorsFromWallpaper:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		UIAlertController *wallpaperColorsAlert = [UIAlertController alertControllerWithTitle:@"Navale" message:@"Would you like to generate and use colors from your homescreen wallpaper?\n\nThis will replace your current colors." preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Get Colors" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			cell.cellEnabled = YES;
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs-colorsFromWallpaper"), nil, nil, true);
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs/ReloadPrefs"), nil, nil, true);
			});
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			cell.cellEnabled = YES;
		}];

		[wallpaperColorsAlert addAction:confirmAction];
		[wallpaperColorsAlert addAction:cancelAction];
		[self presentViewController:wallpaperColorsAlert animated:YES completion:nil];
	}

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

@end
