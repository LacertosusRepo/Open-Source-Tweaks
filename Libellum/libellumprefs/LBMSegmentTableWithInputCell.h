#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface UIImage (PrivateMethods)
+(instancetype)kitImageNamed:(id)arg1;
@end

@interface UISegmentControl : UIControl
@property (nonatomic) NSInteger selectedSegmentIndex;
@end


@interface PSSegmentTableCell : PSControlTableCell
@end

@interface LBMSegmentTableWithInputCell : PSSegmentTableCell
@end
