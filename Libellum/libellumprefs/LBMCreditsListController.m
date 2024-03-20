#import "LBMCreditsListController.h"

@implementation LBMCreditsListController
	-(instancetype)init {
		self = [super init];
		if(self) {
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Credits" target:self];
		}

		return _specifiers;
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		self.navigationController.navigationBar.prefersLargeTitles = NO;
		self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		if(!self.navigationItem.titleView) {
			UILabel *title = [[UILabel alloc] init];
			title.text = @"Credits";
			title.textAlignment = NSTextAlignmentCenter;
			title.textColor = Pri_Color;
			title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
			title.translatesAutoresizingMaskIntoConstraints = NO;
			[title sizeToFit];
			self.navigationItem.titleView = title;
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
