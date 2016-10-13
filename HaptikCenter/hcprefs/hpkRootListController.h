#import <Preferences/PSListController.h>

@interface hpkRootListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface CCOptionsListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface NCOptionsListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface HaptikCenterCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel2;
@property (nonatomic,assign) UILabel *randomLabel;
@property (nonatomic,readonly) NSArray *randomTexts;
@end