#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>

@interface IMPRootListController : PSListController
@end

@interface ImperiumCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@end
