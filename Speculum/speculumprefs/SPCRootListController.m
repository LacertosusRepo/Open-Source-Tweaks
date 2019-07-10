#include "SPCRootListController.h"

@implementation SPCRootListController

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
		UIView *SPCHeaderView = [[SPCHeaderCell alloc] init];
		SPCHeaderView.frame = CGRectMake(0, 0, SPCHeaderView.bounds.size.width, 150);
		tableView.tableHeaderView = SPCHeaderView;
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/speculumprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Speculum";
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

	-(void)useWallpaperColors:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		UIAlertController *wallpaperColorsAlert = [UIAlertController alertControllerWithTitle:@"Speculum" message:@"Would you like to generate and use colors from your lockscreen wallpaper?\n\nThis will replace the colors that are set for the time, date, and weather labels. This is not perfect." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Get Colors" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"]) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.speculumprefs-speculumUseWallpaperColors"), nil, nil, true);
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.speculumprefs/ReloadPrefs"), nil, nil, true);
					cell.cellEnabled = YES;
				});
			} else {
				UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No lockscreen wallpaper found at the following path: /User/Library/SpringBoard/OriginalLockBackground.cpbitmap\n\nContact me if you need help." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
					cell.cellEnabled = YES;
				}];
				[errorAlert addAction:cancelAction];
				[self presentViewController:errorAlert animated:YES completion:nil];
			}
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
			cell.cellEnabled = YES;
		}];

		[wallpaperColorsAlert addAction:confirmAction];
		[wallpaperColorsAlert addAction:cancelAction];
		[self presentViewController:wallpaperColorsAlert animated:YES completion:nil];
	}

	-(void)resetSettings:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
		cell.cellEnabled = NO;

		UIAlertController *resetAlert = [UIAlertController alertControllerWithTitle:@"Speculum" message:@"Would you like to reset your settings? There's no going back!\n\nThis will also respring your device." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
  		[preferences setInteger:2 forKey:@"speculumAlignment"];
  		[preferences setInteger:0 forKey:@"speculumOffset"];
  		[preferences setBool:YES forKey:@"speculumChargingInformation"];

  		[preferences setBool:YES forKey:@"speculumTimeLabelSwitch"];
  		[preferences setObject:@"#FFFFFF" forKey:@"speculumTimeLabelColor"];
  		[preferences setInteger:75 forKey:@"speculumTimeLabelSize"];
  		[preferences setFloat:UIFontWeightMedium forKey:@"speculumTimeLabelWeight"];
  		[preferences setObject:@"HH:mm" forKey:@"speculumTimeLabelFormat"];

  		[preferences setBool:YES forKey:@"speculumDateLabelSwitch"];
  		[preferences setObject:@"#FFFFFF" forKey:@"speculumDateLabelColor"];
  		[preferences setInteger:25 forKey:@"speculumDateLabelSize"];
  		[preferences setFloat:UIFontWeightLight forKey:@"speculumDateLabelWeight"];
  		[preferences setObject:@"EEEE, MMMM d" forKey:@"speculumDateLabelFormat"];

  		[preferences setBool:YES forKey:@"speculumWeatherLabelSwitch"];
  		[preferences setObject:@"#FFFFFF" forKey:@"speculumWeatherLabelColor"];
  		[preferences setInteger:20 forKey:@"speculumWeatherLabelSize"];
  		[preferences setFloat:UIFontWeightLight forKey:@"speculumWeatherLabelWeight"];
  		[preferences setBool:YES forKey:@"speculumWeatherUseConditionImages"];
  		[preferences setInteger:0 forKey:@"speculumWeatherConditionImageAlignment"];
  		[preferences setInteger:1 forKey:@"speculumTempUnit"];
  		[preferences setInteger:30 forKey:@"speculumWeatherUpdateTime"];

			[preferences setInteger:0 forKey:@"speculumPreferredLanguage"];

			[HBRespringController respring];

			cell.cellEnabled = YES;
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
			cell.cellEnabled = YES;
		}];

		[resetAlert addAction:confirmAction];
		[resetAlert addAction:cancelAction];
		[self presentViewController:resetAlert animated:YES completion:nil];

	}

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation SPCTimeListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"SPCTimeSettings" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/speculumprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Time Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 1;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

	-(void)colorPicker {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
		NSString *speculumLabelColor = [preferences objectForKey:@"speculumTimeLabelColor"];

		UIColor *startColor = LCPParseColorString(speculumLabelColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"speculumTimeLabelColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.speculumprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

@end

@implementation SPCDateListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"SPCDateSettings" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/speculumprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Date Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 1;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

	-(void)colorPicker {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
		NSString *speculumLabelColor = [preferences objectForKey:@"speculumDateLabelColor"];

		UIColor *startColor = LCPParseColorString(speculumLabelColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"speculumDateLabelColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.speculumprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

@end

@implementation SPCWeatherListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"SPCWeatherSettings" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/speculumprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Weather Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 1;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

	-(void)colorPicker {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
		NSString *speculumLabelColor = [preferences objectForKey:@"speculumWeatherLabelColor"];

		UIColor *startColor = LCPParseColorString(speculumLabelColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"speculumWeatherLabelColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.speculumprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

@end
