#import <Preferences/PSListController.h>

@interface obcRootListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface ObscuriteCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel2;
@end