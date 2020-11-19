#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface LBMLabeledSliderCell : PSSliderTableCell
@end

@interface PSSpecifier (PrivateMethods)
-(id)performGetter;
-(void)performSetterWithValue:(id)value;
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end
