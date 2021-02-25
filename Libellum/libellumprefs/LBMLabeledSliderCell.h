#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>

@interface PSSpecifier (PrivateMethods)
-(id)performGetter;
-(void)performSetterWithValue:(id)value;
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface LBMLabeledSliderCell : PSSliderTableCell
@end
