@import Alderis;
#import "AlderisColorPicker.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Cephei/HBPreferences.h>

typedef NS_ENUM(NSInteger, DIPNotificationAnimationType) {
  DIPNotificationAnimationTypeNone,
  DIPNotificationAnimationTypeBounce,
  DIPNotificationAnimationTypeShakeX,
  DIPNotificationAnimationTypeShakeY,
  DIPNotificationAnimationTypeGlow,
};

@interface DIPIndicatorPreviewCell : PSTableCell
-(void)updateIndicatorPreview;
@end
