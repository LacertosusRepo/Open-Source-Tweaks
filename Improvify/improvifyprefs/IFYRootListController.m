#include "IFYRootListController.h"

@implementation IFYRootListController

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
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		//Adds header to table
		UIView *IFYHeaderView = [[IFYHeaderCell alloc] init];
		IFYHeaderView.frame = CGRectMake(0, 0, IFYHeaderView.bounds.size.width, 150);

		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = IFYHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Improvify";
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

	-(void)killSpotify:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
		cell.cellEnabled = NO;

		UIAlertController *killSpotifyAlert = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"Are you sure you want to restart Spotify?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Kill" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.improvifyprefs-killSpotify"), nil, nil, true);
			cell.cellEnabled = YES;
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
			cell.cellEnabled = YES;
		}];

		[killSpotifyAlert addAction:confirmAction];
		[killSpotifyAlert addAction:cancelAction];
		[self presentViewController:killSpotifyAlert animated:YES completion:nil];
	}

@end

@implementation ImprovifyPlaylistsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"ImprovifyPlaylists" target:self];
		}
		return _specifiers;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Set Spotify Playlists";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation ImprovifyQuickAddSettingsListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"ImprovifyQuickAddSettings" target:self];
		}
		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Quick-Add Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)colorPicker {
		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.improvifyprefs"];
		NSString *addToPlaylistCustomColor = [preferences objectForKey:@"addToPlaylistCustomColor"];

		UIColor *startColor = LCPParseColorString(addToPlaylistCustomColor, @"#1DB954");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"addToPlaylistCustomColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.improvifyprefs/ReloadPrefs"), nil, nil, true);
		}];
	}

@end

@implementation ImprovifyQuickDeleteSettingsListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"ImprovifyQuickDeleteSettings" target:self];
		}
		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Quick-Delete Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

@end

@implementation ImprovifySongCountSettingsListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"ImprovifySongCountSettings" target:self];
		}
		return _specifiers;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Song Count Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}


	-(void)resetSpotifyPlayHistory {
		UIAlertController *resetSpotifyHistoryAlert = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"Are you sure you want to reset your play history? You cannot recover it after deletion.\n\n Spotify must be running for this to work." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
		  [improvifydata removeObjectForKey:@"songHistory"];
		  [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[resetSpotifyHistoryAlert addAction:confirmAction];
		[resetSpotifyHistoryAlert addAction:cancelAction];
		[self presentViewController:resetSpotifyHistoryAlert animated:YES completion:nil];
	}

@end

@implementation ImprovifyMiscellaneousSettingsListController

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
			_specifiers = [self loadSpecifiersFromPlistName:@"ImprovifyMiscellaneousSettings" target:self];
		}
		return _specifiers;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Miscellaneous Settings";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		self.navigationItem.titleView = title;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

@end
