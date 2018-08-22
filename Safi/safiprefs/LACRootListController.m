#include "LACRootListController.h"
#import "SafiCustomHeaderClassCell.h"
#import "PreferencesColorDefinitions.h"
#import "libcolorpicker.h"
#import <UIKit/UIKit.h>

@implementation LACRootListController

	- (NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}

		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

		if (section == 0) {
			return (UIView *)[[SafiCustomHeaderCell alloc] init];
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
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/safiprefs.bundle/github.png"];
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

		NSString * key = specifier.properties[@"key"];
		id value = [prefs objectForKey:key];
		if([key isEqualToString:@"folderColorSwitch"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}

		if([key isEqualToString:@"blurOption"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
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

		NSString * key = specifier.properties[@"key"];
		if([key isEqualToString:@"folderColorSwitch"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}

		if([key isEqualToString:@"blurOption"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value intValue] == 0) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}

		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)colorPickerFolderBackground {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.safiprefs.plist"];
		NSString * folderBackgroundColor = [preferences objectForKey:@"folderBackgroundColor"];
		UIColor * initialColor = LCPParseColorString(folderBackgroundColor, @"#2f3640");
		PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:NO];

			[alert displayWithCompletion:^void (UIColor * pickedColor) {
				NSString * hexColor = [UIColor hexFromColor:pickedColor];
				//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha]; Incase I use the alpha value
				[preferences setObject:hexColor forKey:@"folderBackgroundColor"];
				[preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.safiprefs.plist" atomically:YES];
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.lacertosusrepo.safiprefs/preferences.changed", NULL, NULL, YES);
			}];
	}

	-(void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.safiprefs-respring"), nil, nil, true);
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
