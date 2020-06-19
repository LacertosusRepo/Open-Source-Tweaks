#include "LBMColorsListController.h"

@implementation LBMColorsListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.navigationBarTintColor = Pri_Color;
			appearanceSettings.navigationBarBackgroundColor = Sec_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Colors" target:self];

			NSArray *chosenIDs = @[@"IgnoreAdaptivePresetColors", @"SetSolidColor"];
			self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
			for(PSSpecifier *specifier in _specifiers) {
				if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
					[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
				}
			}
		}

		return _specifiers;
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"adaptive"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"IgnoreAdaptivePresetColors"]] animated:YES];
		}

		if(![[preferences objectForKey:@"blurStyle"] isEqualToString:@"colorized"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"SetSolidColor"]] animated:YES];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		//Adds respring button in top right of preference pane and hide any cells
		[self respringApply];
		[self reloadSpecifiers];
	}

	-(void)respringApply {
		_respringApplyButton = (_respringApplyButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
		_respringApplyButton.tintColor = Pri_Color;
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
		//Adds icon to center of preferences
		UIImageView *iconView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/colors.png"]];
		self.navigationItem.titleView = iconView;
		self.navigationItem.titleView.alpha = 0;

		[super viewDidAppear:animated];

		[UIView animateWithDuration:0.2 animations:^{
			self.navigationItem.titleView.alpha = 1;
		}];
	}

@end
