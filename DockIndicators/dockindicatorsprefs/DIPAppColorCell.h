#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
@import Alderis;
#import "AlderisColorPicker.h"

@class DIPAppColorCell;
@protocol DIPAppColorCellDelegate <NSObject>;
-(void)didSelectColorWithHex:(NSString *)hex forBundleID:(NSString *)bundle;
@end

@interface DIPAppColorCell : PSTableCell <HBColorPickerDelegate>
-(UIColor *)appropriateColorForLabel:(UIColor *)color;
@end

@interface UIImage (PrivateMethods)
+(instancetype)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(id)arg2 scale:(CGFloat)arg3;
@end

@interface UIView (PrivateMethods)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface UIColor (iOS13)
+(UIColor *)opaqueSeparatorColor;
+(UIColor *)labelColor;
+(UIColor *)systemGrayColor;
@end
