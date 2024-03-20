#import <UIKit/UIKit.h>

@interface UIColor (PFColor)
+ (UIColor *)PF_colorWithHex:(NSString *)hexString;
+ (NSString *)PF_hexFromColor:(UIColor *)color;
+ (NSString *)hexFromColor:(UIColor *)color;
@property (nonatomic, assign, readonly) CGFloat alpha;
@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;
@property (nonatomic, assign, readonly) CGFloat hue;
@property (nonatomic, assign, readonly) CGFloat saturation;
@property (nonatomic, assign, readonly) CGFloat brightness;
- (UIColor *)desaturate:(CGFloat)percent;
- (UIColor *)lighten:(CGFloat)percent;
- (UIColor *)darken:(CGFloat)percent;
@end
