#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface LACRootListController : PSListController
@end

@interface SafiCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel2;
@end
