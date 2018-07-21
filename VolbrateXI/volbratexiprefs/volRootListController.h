#import <Preferences/PSListController.h>

@interface volRootListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface VolbrateCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel2;
@end