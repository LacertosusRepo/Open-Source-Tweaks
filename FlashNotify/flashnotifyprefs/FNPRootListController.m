#include "FNPRootListController.h"

@implementation FNPRootListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.navigationBarTintColor = Sec_Color;
			appearanceSettings.navigationBarBackgroundColor = Pri_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.flashnotifyprefs"];
			NSArray *chosenIDs = @[@"chargingNotificationDelay", @"faceUpDelay", @"faceDownDelay", @"maxFlashlightDuration"];
			self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
			for(PSSpecifier *specifier in _specifiers) {
				if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
					[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
				}

				if([[specifier propertyForKey:@"id"] isEqualToString:@"DeviceOrientation"] && ![preferences boolForKey:@"hasAccelerometer"]) {
					[specifier setName:@"Device Orientation (Disabled)"];
					[specifier setProperty:@"This section has been disabled since your device does not have an accelerometer." forKey:@"footerText"];

					for(PSSpecifier *specifier in [self specifiersInGroup:1]) {
						[specifier setProperty:@NO forKey:@"enabled"];
					}
				}
			}
		}

		return _specifiers;
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		[super setPreferenceValue:value specifier:specifier];

		NSString *key = [specifier propertyForKey:@"key"];
		if([key isEqualToString:@"notifyWhileCharging"]) {
			if(![value boolValue]) {
				[self removeSpecifier:self.savedSpecifiers[@"chargingNotificationDelay"] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"chargingNotificationDelay"]]) {
				[self insertSpecifier:self.savedSpecifiers[@"chargingNotificationDelay"] afterSpecifierID:@"ChargingNotificationDelaySwitch" animated:YES];
			}
		}

		if([key isEqualToString:@"useAccelerometerType"]) {
			switch ([value intValue]) {
				case 0:	//Disabled
				{
					[self removeSpecifier:self.savedSpecifiers[@"faceUpDelay"] animated:YES];
					[self removeSpecifier:self.savedSpecifiers[@"faceDownDelay"] animated:YES];
				}
				break;

				case 1:	//Face Up
				{
					if(![self containsSpecifier:self.savedSpecifiers[@"faceUpDelay"]]) {
						[self insertSpecifier:self.savedSpecifiers[@"faceUpDelay"] afterSpecifierID:@"useAccelerometerType" animated:YES];
					}

					[self removeSpecifier:self.savedSpecifiers[@"faceDownDelay"] animated:YES];
				}
				break;

				case 2:	//Face Down
				{
					if(![self containsSpecifier:self.savedSpecifiers[@"faceDownDelay"]]) {
						[self insertSpecifier:self.savedSpecifiers[@"faceDownDelay"] afterSpecifierID:@"useAccelerometerType" animated:YES];
					}

					[self removeSpecifier:self.savedSpecifiers[@"faceUpDelay"] animated:YES];
				}
				break;

				case 3: //Both
				{
					if(![self containsSpecifier:self.savedSpecifiers[@"faceDownDelay"]]) {
						[self insertSpecifier:self.savedSpecifiers[@"faceDownDelay"] afterSpecifierID:@"useAccelerometerType" animated:YES];
					}

					if(![self containsSpecifier:self.savedSpecifiers[@"faceUpDelay"]]) {
						[self insertSpecifier:self.savedSpecifiers[@"faceUpDelay"] afterSpecifierID:@"useAccelerometerType" animated:YES];
					}
				}
				break;
			}
		}

		if([key isEqualToString:@"autoDisableFlashlight"]) {
			if(![value boolValue]) {
				[self removeSpecifier:self.savedSpecifiers[@"maxFlashlightDuration"] animated:YES];
			} else if(![self containsSpecifier:self.savedSpecifiers[@"maxFlashlightDuration"]]) {
				[self insertSpecifier:self.savedSpecifiers[@"maxFlashlightDuration"] afterSpecifierID:@"Auto-DisableFlashlight" animated:YES];
			}
		}
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.flashnotifyprefs"];
		if(![preferences boolForKey:@"notifyWhileCharging"]) {
			[self removeSpecifier:self.savedSpecifiers[@"chargingNotificationDelay"]];
		}

		switch ([preferences integerForKey:@"useAccelerometerType"]) {
			case 0:	//Disabled
			{
				[self removeSpecifier:self.savedSpecifiers[@"faceUpDelay"]];
				[self removeSpecifier:self.savedSpecifiers[@"faceDownDelay"]];
			}
			break;

			case 1:	//Face Up
			{
				[self removeSpecifier:self.savedSpecifiers[@"faceDownDelay"]];
			}
			break;

			case 2:	//Face Down
			{
				[self removeSpecifier:self.savedSpecifiers[@"faceUpDelay"]];
			}
			break;
		}

		if(![preferences boolForKey:@"autoDisableFlashlight"]) {
			[self removeSpecifier:self.savedSpecifiers[@"maxFlashlightDuration"]];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		[self reloadSpecifiers];
		[self respringApply];

		//Adds header to table
		UIView *header = [[FNPHeaderView alloc] init];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = header;
	}

	-(void)respringApply {
		_respringApplyButton = (_respringApplyButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
		_respringApplyButton.tintColor = Sec_Color;
		[self.navigationItem setRightBarButtonItem:_respringApplyButton animated:YES];
	}

	-(void)respringConfirm {
		if([self.navigationItem.rightBarButtonItem isEqual:_respringConfirmButton]) {
			[HBRespringController respring];
		} else {
			_respringConfirmButton = (_respringConfirmButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Are you sure?" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
			_respringConfirmButton.tintColor = [UIColor colorWithRed:0.90 green:0.23 blue:0.23 alpha:1.00];
			[self.navigationItem setRightBarButtonItem:_respringConfirmButton animated:YES];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self respringApply];
			});
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"FlashNotify";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;

		[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
			}];
	}

	-(void)sendTestNotification {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.flashnotifyprefs-sendTestNotification"), nil, nil, true);
	}

	-(void)resetPreferences {
		for(PSSpecifier *specifier in _specifiers) {
			id defaultValue = [specifier propertyForKey:@"default"];
			if(defaultValue) {
				[self setPreferenceValue:defaultValue specifier:specifier];
			}

			if([_specifiers indexOfObject:specifier] == [_specifiers count]) {
				[self reloadSpecifiers];
			}
		}
	}
@end
