#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSEditableTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface IFYRootListController : PSListController
@end

@interface ImprovifyMiscellaneousSettingsViewController : PSListController
@end

@interface IFYCustomHeaderCell : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) UILabel *headerLabel;
@property (nonatomic, assign) UILabel *subHeaderLabel;
@property (nonatomic, readonly) NSArray *randomLabels;
@end
