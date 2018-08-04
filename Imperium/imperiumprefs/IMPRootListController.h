#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface IMPRootListController : PSListController
@end

@interface ImperiumApplicationsListController : PSListController
@end

@interface ImperiumHideItemsListController : PSListController
@end

@interface ImperiumCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@end
