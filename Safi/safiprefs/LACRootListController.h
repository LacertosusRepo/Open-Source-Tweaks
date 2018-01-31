#import <Preferences/PSListController.h>

@interface LACRootListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface SafiCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel2;
@end