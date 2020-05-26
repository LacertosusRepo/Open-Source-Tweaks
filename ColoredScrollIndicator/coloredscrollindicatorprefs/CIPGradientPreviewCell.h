@import Alderis;
#import <Cephei/HBPreferences.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "AlderisColorPicker.h"

@interface CIPGradientPreviewCell : PSTableCell
-(void)updatePreviewGradient;
@end

@interface UIColor (iOS13)
+(UIColor *)opaqueSeparatorColor;
+(UIColor *)labelColor;
+(UIColor *)secondaryLabelColor;
+(UIColor *)systemGrayColor;
@end
