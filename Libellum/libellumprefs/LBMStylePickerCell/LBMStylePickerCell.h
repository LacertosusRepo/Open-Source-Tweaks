#import <UIKit/UIKit.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import "LBMStyleOptionView.h"

@interface LBMStylePickerCell : PSTableCell <LBMStyleOptionViewDelegate>
@end

@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end
