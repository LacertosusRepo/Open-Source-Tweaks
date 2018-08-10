#include "IMPRootListController.h"
#import "ImperiumCustomHeaderClassCell.h"
#import "PreferencesColorDefinitions.h"
#import <UIKit/UIKit.h>

@implementation IMPRootListController

	-(NSArray *)specifiers {

		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}

		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

		if (section == 0) {
			return (UIView *)[[ImperiumCustomHeaderCell alloc] init];
		}

    return nil;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

		if (section == 0) {
			return 140.f;
		}

	return (CGFloat)-1;
	}

	-(void)viewDidLoad {

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/imperiumprefs.bundle/navlogo.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc]
							   initWithImage:iconBar
							   style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(webButtonAction)];

		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];

		[super viewDidLoad];

	}

	-(IBAction)webButtonAction {

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];

	}

	-(void)viewWillAppear:(BOOL)animated {

		[super viewWillAppear:animated];

		//Changed colors of Navigation Bar, Navigation Text
			self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
			self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
			self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

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

	-(void)killApplications {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.imperiumprefs-killapplications"), nil, nil, true);
	}

	-(void)resetSettings {
		UIAlertController * resetAlert = [UIAlertController alertControllerWithTitle:@"Imperium"
																			message:@"Are you sure you want to reset settings? This will also respring your device."
																			preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			NSError * error = nil;
			[[NSFileManager defaultManager] removeItemAtPath:@"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist" error:&error];
			if(!error) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.imperiumprefs-respring"), nil, nil, true);
			} else {
				NSLog(@"error - %@", error);
				UIAlertController * failedAlert = [UIAlertController alertControllerWithTitle:@"Imperium"
																					message:@"Something went wrong when deleting the file. You can manually delete it to try to fix the problem."
																					preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
				[failedAlert addAction:cancelAction];
				[self presentViewController:failedAlert animated:YES completion:nil];
			}
		}];
		UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[resetAlert addAction:confirmAction];
		[resetAlert addAction:cancelAction];
		[self presentViewController:resetAlert animated:YES completion:nil];
	}

	-(void)twitter {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
	}

	-(void)paypal {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/Lacertosus"] options:@{} completionHandler:nil];
	}

	-(void)github {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}
@end

@implementation ImperiumApplicationsListController

	-(NSArray *)specifiers {

		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImperiumApplicationsListController" target:self] retain];
		}

	return _specifiers;
	}

	-(void)viewDidLoad {

		//Adds GitHub button in center of preference pane
		UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/imperiumprefs.bundle/applist.png"];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		self.navigationItem.titleView = iconView;
		self.navigationItem.titleView.alpha = 0;

		[super viewDidLoad];

	}

	-(IBAction)webButtonAction {

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];

	}

	-(void)viewWillAppear:(BOOL)animated {

		[super viewWillAppear:animated];

		//Changed colors of Navigation Bar, Navigation Text
			self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
			self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
			self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

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

	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
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

	-(void)twitter {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
	}
@end

@implementation ImperiumHideItemsListController

	-(NSArray *)specifiers {

		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImperiumHideItemsListController" target:self] retain];
		}

	return _specifiers;
	}

	-(void)viewDidLoad {

		//Adds GitHub button in center of preference pane
		UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/imperiumprefs.bundle/hideitems.png"];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		self.navigationItem.titleView = iconView;
		self.navigationItem.titleView.alpha = 0;

		[super viewDidLoad];

	}

	-(IBAction)webButtonAction {

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];

	}

	-(void)viewWillAppear:(BOOL)animated {

		[super viewWillAppear:animated];

		//Changed colors of Navigation Bar, Navigation Text
			self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
			self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
			self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

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

	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
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

	-(void)twitter {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
	}
@end
