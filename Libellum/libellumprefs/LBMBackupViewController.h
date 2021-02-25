#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import <os/log.h>
#import "PreferencesColorDefinitions.h"

@interface UIColor (iOS13)
+(UIColor *)labelColor;
+(UIColor *)secondaryLabelColor;
@end

@interface UIViewController (iOS13)
-(void)setModalInPresentation:(BOOL)arg1;
@end

@interface LBMNoteBackupViewController : UIViewController
@end
