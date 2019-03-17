#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface STLRootListController : PSListController
@end

@interface STLCustomHeaderCell : UIView
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@property (nonatomic,readonly) NSArray *randomQuotes;
@end
