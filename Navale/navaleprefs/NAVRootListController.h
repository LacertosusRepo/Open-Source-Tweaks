#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface NAVRootListController : PSListController
@end

@interface LacertosusCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@end
