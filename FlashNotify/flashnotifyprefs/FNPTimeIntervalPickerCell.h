#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface FNPTimeIntervalPickerCell : PSTableCell <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end
