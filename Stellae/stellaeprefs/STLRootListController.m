#include "STLRootListController.h"
#import "STLCustomHeaderClassCell.h"
#import "PreferencesColorDefinitions.h"

@implementation STLRootListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}
		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return (UIView *)[[STLCustomHeaderCell alloc] init];
		}
    return nil;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return 170.0f;
		}
	return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/stellaeprefs.bundle/github.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/stellaeprefs.bundle/navbarlogo.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		self.navigationItem.titleView = iconView;
		self.navigationItem.titleView.alpha = 0;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo/Open-Source-Tweaks/tree/master/Stellae"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)respring {
		UIAlertController *respringAlert = [UIAlertController alertControllerWithTitle:@"Stellae"
																			message:@"Are you sure you want Respring?"
																			preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-respring"), nil, nil, true);
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[respringAlert addAction:confirmAction];
		[respringAlert addAction:cancelAction];
		[self presentViewController:respringAlert animated:YES completion:nil];

	}

	-(void)updateSubImage {
		UIAlertController *updateImageAlert = [UIAlertController alertControllerWithTitle:@"Stellae"
																			message:@"Are you sure you want to update the wallpaper?\n\nYou can't save it once its changed!"
																			preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-updateSubImage"), nil, nil, true);
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[updateImageAlert addAction:confirmAction];
		[updateImageAlert addAction:cancelAction];
		[self presentViewController:updateImageAlert animated:YES completion:nil];
	}

	-(void)saveImage {
		UIAlertController *saveImageAlert = [UIAlertController alertControllerWithTitle:@"Stellae"
																			message:@"Saving current wallpaper..."
																			preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:saveImageAlert animated:YES completion:^{
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-saveImage"), nil, nil, true);

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [saveImageAlert dismissViewControllerAnimated:YES completion:nil];
			});
		}];
	}

	-(void)openCurrentRedditPost {
		NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.stellaesaveddata.plist"];
		NSString *currentRedditURL = [preferences objectForKey:@"currentRedditURL"];
		if([currentRedditURL isEqualToString:@""] || currentRedditURL == nil) {
			UIAlertController *openRedditURLError = [UIAlertController alertControllerWithTitle:@"Stellae" message:@"No Reddit URL saved!" preferredStyle:UIAlertControllerStyleAlert];
			[self presentViewController:openRedditURLError animated:YES completion:^{

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	      	[openRedditURLError dismissViewControllerAnimated:YES completion:nil];
				});
			}];

		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentRedditURL] options:@{} completionHandler:nil];
		}
	}

	-(void)twitter {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
	}

	-(void)paypal {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lacertosusrepo.github.io/depictions/resources/donate.html"] options:@{} completionHandler:nil];
	}

	-(void)github {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

@end
