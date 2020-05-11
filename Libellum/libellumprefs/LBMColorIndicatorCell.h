#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Cephei/HBPreferences.h>

@interface LBMColorIndicatorCell : PSTableCell
-(UIColor *)colorFromHex:(NSString *)hex withAlpha:(CGFloat)alpha;
@end

@interface UIColor (iOS13)
+(UIColor *)opaqueSeparatorColor;
+(UIColor *)labelColor;
+(UIColor *)systemGrayColor;
@end
