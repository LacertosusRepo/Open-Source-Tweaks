#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface DIPLabeledSliderCell : PSSliderTableCell
@end

@interface PSSpecifier (PrivateMethods)
-(id)performGetter;
-(void)performSetterWithValue:(id)value;
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end
