#include "GLARootListController.h"
#import "LacertosusCustomHeaderClassCell.h"
#import "PreferencesColorDefinitions.h"
#import "libcolorpicker.h"
#import <UIKit/UIKit.h>

@implementation GLARootListController

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
			return 95.f;
		}

	return (CGFloat)-1;
	}

	-(void)viewDidLoad {

		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/vitrumprefs.bundle/navbarlogo.png"];
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
		if([key isEqualToString:@"backgroundColorSwitch"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;

			cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}

		if([key isEqualToString:@"useCustomImage"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
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
		if([key isEqualToString:@"backgroundColorSwitch"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;

			cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}

		if([key isEqualToString:@"useCustomImage"]) {
			BOOL enableCell = YES;
			UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleDefault;
			UIColor * disabledColor = [UIColor whiteColor];
			if([value boolValue] == NO) {
				enableCell = NO;
				selectionStyle = UITableViewCellSelectionStyleNone;
				disabledColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
			}

			UITableViewCell * cell = [super tableView:(UITableView *)self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
			cell.selectionStyle = selectionStyle;
      cell.userInteractionEnabled = enableCell;
      cell.textLabel.enabled = enableCell;
      cell.detailTextLabel.enabled = enableCell;
			cell.backgroundColor = disabledColor;
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)choosePhoto {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController:picker animated:YES completion:nil];
	}

	-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist"];
		UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSData * imageData = UIImagePNGRepresentation(pickedImage);
		[preferences setObject:imageData forKey:@"imageData"];
		[preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist" atomically:YES];
		[picker dismissViewControllerAnimated:YES completion:nil];
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.lacertosusrepo.vitrumprefs/preferences.changed", NULL, NULL, YES);
	}

	-(void)colorPicker {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist"];
		NSString * controlCenterColor = [preferences objectForKey:@"controlCenterColor"];
		UIColor * initialColor = LCPParseColorString(controlCenterColor, @"#95a5a6");
		PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:NO];

			[alert displayWithCompletion:^void (UIColor * pickedColor) {
				NSString * hexColor = [UIColor hexFromColor:pickedColor];
				//hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
				[preferences setObject:hexColor forKey:@"controlCenterColor"];
				[preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist" atomically:YES];
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.lacertosusrepo.vitrumprefs/preferences.changed", NULL, NULL, YES);
			}];
	}

	-(void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.vitrumprefs-respring"), nil, nil, true);
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
