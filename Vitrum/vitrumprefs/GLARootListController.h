#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface GLARootListController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@interface LacertosusCustomHeaderCell : UIView
@property (nonatomic,assign) UILabel *headerLabel;
@property (nonatomic,assign) UILabel *subHeaderLabel;
@end
