#import "libcolorpicker.h"
#import "Preferences/PSTableCell.h"
#import <Cephei/HBPreferences.h>

@interface NAVGradientPreviewCell : PSTableCell
+(void)updateColors;
@end

@interface UIColor (iOS13)
+(UIColor *)opaqueSeparatorColor;
+(UIColor *)labelColor;
+(UIColor *)secondaryLabelColor;
+(UIColor *)systemGrayColor;
@end
