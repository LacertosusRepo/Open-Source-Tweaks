#import <UIKit/UIKit.h>
#import "PreferencesColorDefinitions.h"

@interface LBMAnimatedTitleView : UIView
-(instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset;
-(void)adjustLabelPositionToScrollOffset:(CGFloat)offset;
@end
