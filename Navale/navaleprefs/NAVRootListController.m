#include "NAVRootListController.h"
#import "LacertosusCustomHeaderClassCell.h"
#import "NavaleGradientPreviewCell.h"
#import "PreferencesColorDefinitions.h"
#import "libcolorpicker.h"
#import <UIKit/UIKit.h>

@implementation NAVRootListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}
		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return (UIView *)[[LacertosusCustomHeaderCell alloc] init];
		}
    return nil;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return 95.0f;
		}
	return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/navaleprefs.bundle/navbarlogo.png"];
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
		[NavaleGradientPreviewCell reloadCell];
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)colorPickerOne {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
		NSString * colorOne = [preferences objectForKey:@"colorOne"];
		UIColor * initialColor = LCPParseColorString(colorOne, @"#2c3e50");
		PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:NO];

			[alert displayWithCompletion:^void (UIColor * pickedColor) {
				NSString * hexColor = [UIColor hexFromColor:pickedColor];
				//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
				[preferences setObject:hexColor forKey:@"colorOne"];
				[preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist" atomically:YES];
				[NavaleGradientPreviewCell reloadCell];
			}];
	}

	-(void)colorPickerTwo {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
		NSString * colorTwo = [preferences objectForKey:@"colorTwo"];
		UIColor * initialColor = LCPParseColorString(colorTwo, @"#2980b9");
		PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:NO];

			[alert displayWithCompletion:^void (UIColor * pickedColor) {
				NSString * hexColor = [UIColor hexFromColor:pickedColor];
				//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
				[preferences setObject:hexColor forKey:@"colorTwo"];
				[preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist" atomically:YES];
				[NavaleGradientPreviewCell reloadCell];
			}];
	}

	-(void)updateDock {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs-updateDock"), nil, nil, true);
	}

	-(void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs-respring"), nil, nil, true);
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
