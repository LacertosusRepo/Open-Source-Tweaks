#import <Preferences/PSSpecifier.h>

@interface UISegmentControl : UIControl
-(void)setImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index;
-(void)setTitle:(NSString *)image forSegmentAtIndex:(NSInteger)index;
@end

@interface PSControlTableCell : PSTableCell
-(UIControl *)control;
@end

@interface PSSegmentTableCell : PSControlTableCell
@end

@interface FNPSegmentTableImageCell : PSSegmentTableCell
@end
