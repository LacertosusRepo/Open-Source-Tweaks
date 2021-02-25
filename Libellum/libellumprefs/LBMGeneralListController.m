#include "LBMGeneralListController.h"

@implementation LBMGeneralListController

	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.navigationBarBackgroundColor = Sec_Color;
			appearanceSettings.navigationBarTintColor = Pri_Color;
			appearanceSettings.showsNavigationBarShadow = NO;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
		}

		return self;
	}

	-(NSArray *)specifiers {
		if(!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"General" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		self.navigationController.navigationBar.prefersLargeTitles = NO;
		self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

		//Adds respring button in top right of preference pane
		[self respringStateFromButton:nil];
	}

	-(void)respringStateFromButton:(UIBarButtonItem *)button {
		switch (button.tag) {
			case 0: //Apply
			{
				UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringStateFromButton:)];
				applyButton.tintColor = Pri_Color;
				applyButton.tag = 1;
				[self.navigationItem setRightBarButtonItem:applyButton animated:YES];
			}
			break;

			case 1:	//Are you sure?
			{
				UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Are you sure?" style:UIBarButtonItemStyleDone target:[HBRespringController class] action:@selector(respring)];
				respringButton.tintColor = [UIColor colorWithRed:0.90 green:0.23 blue:0.23 alpha:1.00];
				respringButton.tag = 0;
				[self.navigationItem setRightBarButtonItem:respringButton animated:YES];

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self respringStateFromButton:respringButton];
				});
			}
			break;
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds icon to center of preferences
		if(!self.navigationItem.titleView) {
			UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.png" inBundle:[self bundle] compatibleWithTraitCollection:nil]];
			self.navigationItem.titleView = iconView;
			self.navigationItem.titleView.alpha = 0;

			[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
			}];
		}
	}

	-(UIUserInterfaceStyle)overrideUserInterfaceStyle {
		return UIUserInterfaceStyleDark;
	}

@end
