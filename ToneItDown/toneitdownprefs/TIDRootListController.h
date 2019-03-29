#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface TIDRootListController : PSListController
@end

@interface TIDCustomHeaderCell : UIView
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,readonly) NSArray *randomLabels;
@end
