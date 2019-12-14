#include "LBMRootListController.h"

@implementation LBMRootListController

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
			appearanceSettings.largeTitleStyle = HBAppearanceSettingsLargeTitleStyleNever;
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
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		//Adds header to table
		UIView *LBMHeaderView = [[LBMHeaderCell alloc] init];
		LBMHeaderView.frame = CGRectMake(0, 0, LBMHeaderView.bounds.size.width, 150);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = LBMHeaderView;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Libellum";
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

	-(void)backgroundColorPicker:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
		NSString *customBackgroundColor = [preferences objectForKey:@"customBackgroundColor"];

		UIColor *startColor = LCPParseColorString(customBackgroundColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"customBackgroundColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.libellumprefs/ReloadPrefs"), nil, nil, true);
			cell.cellEnabled = YES;
		}];
	}

	-(void)textColorPicker:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
		NSString *customTextColor = [preferences objectForKey:@"customTextColor"];

		UIColor *startColor = LCPParseColorString(customTextColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"customTextColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.libellumprefs/ReloadPrefs"), nil, nil, true);
			cell.cellEnabled = YES;
		}];
	}

	-(void)borderColorPicker:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
		NSString *borderColor = [preferences objectForKey:@"borderColor"];

		UIColor *startColor = LCPParseColorString(borderColor, @"#FFFFFF");
		PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];
		[alert displayWithCompletion:^void (UIColor *pickedColor) {
			NSString *hexColor = [UIColor hexFromColor:pickedColor];
			//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"borderColor"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.libellumprefs/ReloadPrefs"), nil, nil, true);
			cell.cellEnabled = YES;
		}];
	}

	-(void)manageBackup:(PSSpecifier *)specifier {
		static NSString *filePath = @"/User/Library/Preferences/LibellumNotes.txt";
	  static NSString *filePathBK = @"/User/Library/Preferences/LibellumNotes.bk";
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathBK error:nil];
		NSDate *lastModified = [fileAttributes objectForKey:NSFileModificationDate];
		NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"h:m"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMMM d, yyyy"];

		UIAlertController *notesBackupAlert = [UIAlertController alertControllerWithTitle:@"Libellum" message:[NSString stringWithFormat:@"Manage your notes backup here.\n\nLast backed up at:\n%@ on %@", [timeFormatter stringFromDate:lastModified], [dateFormatter stringFromDate:lastModified]] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *backupNotes = [UIAlertAction actionWithTitle:@"Backup Notes Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[[LibellumView sharedInstance] backupNotes];
			cell.cellEnabled = YES;
		}];

		UIAlertAction *restoreNotes = [UIAlertAction actionWithTitle:@"Restore From Backup" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Libellum" message:@"Are you sure you want to restore the backup of your notes? This will delete your current notes." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
				NSError *error = nil;
				NSString *notesFromBK = [NSString stringWithContentsOfFile:filePathBK encoding:NSUTF8StringEncoding error:&error];
				[notesFromBK writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
				if(error) {
					UIAlertController *completionError = [UIAlertController alertControllerWithTitle:@"Error!" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
						cell.cellEnabled = YES;
					}];

					[completionError addAction:cancelAction];
					[self presentViewController:completionError animated:YES completion:nil];
				} else {
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[[LibellumView sharedInstance] loadNotes];
						cell.cellEnabled = YES;
					});
				}
			}];

			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				cell.cellEnabled = YES;
			}];

			[cautionAlert addAction:confirmAction];
			[cautionAlert addAction:cancelAction];
			[self presentViewController:cautionAlert animated:YES completion:nil];
		}];

		UIAlertAction *deleteNotes = [UIAlertAction actionWithTitle:@"Delete Backup" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Libellum" message:@"Are you sure you want to delete the backup of your notes?" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
				NSError *error = nil;
				[[NSFileManager defaultManager] removeItemAtPath:filePathBK error:&error];
				if(error) {
					UIAlertController *completionError = [UIAlertController alertControllerWithTitle:@"Error!" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
						cell.cellEnabled = YES;
					}];

					[completionError addAction:cancelAction];
					[self presentViewController:completionError animated:YES completion:nil];
				} else {
					cell.cellEnabled = YES;
				}
			}];

			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
				cell.cellEnabled = YES;
			}];

			[cautionAlert addAction:confirmAction];
			[cautionAlert addAction:cancelAction];
			[self presentViewController:cautionAlert animated:YES completion:nil];
		}];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
			cell.cellEnabled = YES;
		}];

		[notesBackupAlert addAction:backupNotes];
		if([[NSFileManager defaultManager] fileExistsAtPath:filePathBK]) {
			[notesBackupAlert addAction:restoreNotes];
			[notesBackupAlert addAction:deleteNotes];
		}
		[notesBackupAlert addAction:cancelAction];
		[self presentViewController:notesBackupAlert animated:YES completion:nil];
	}

	-(void)useWallpaperColors:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;

		UIAlertController *wallpaperColorsAlert = [UIAlertController alertControllerWithTitle:@"Libellum" message:@"Would you like to generate and use colors from your lockscreen wallpaper?\n\nThis will replace the colors that are set for the background, font, and border of Libellum. This is not perfect." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Get Colors" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"]) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.libellumprefs-useWallpaperColors"), nil, nil, true);
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.libellumprefs/ReloadPrefs"), nil, nil, true);
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

	-(void)respring:(PSSpecifier *)specifier {
		PSTableCell *cell = [self cachedCellForSpecifier:specifier];
    cell.cellEnabled = NO;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[HBRespringController respring];
		});
	}

@end
