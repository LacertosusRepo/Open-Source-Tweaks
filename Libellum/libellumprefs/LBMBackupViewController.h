#import <UIKit/UIKit.h>
#import <os/log.h>
#import "PreferencesColorDefinitions.h"

#define LOGS(format, ...) NSLog(@"Libellum: " format, ## __VA_ARGS__)

@interface UIColor (iOS13)
+(UIColor *)labelColor;
+(UIColor *)secondaryLabelColor;
@end

@interface UIViewController (iOS13)
-(void)setModalInPresentation:(BOOL)arg1;
@end

@interface LBMNoteBackupViewController : UIViewController
- (void)minimizeSettings;
- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay;
@end
