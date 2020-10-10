#import <Cephei/HBRespringController.h>
#import "PreferencesColorDefinitions.h"
#import "../MTMaterialView.h"

#define filePath @"/User/Library/Preferences/LibellumNotes.rtf"
#define filePathBK @"/User/Library/Preferences/LibellumNotes.rtf.bk"

@interface UIColor (iOS13)
+(UIColor *)labelColor;
+(UIColor *)secondaryLabelColor;
@end

@interface UIViewController (iOS13)
-(void)setModalInPresentation:(BOOL)arg1;
@end

@interface LBMNoteBackupViewController : UIViewController
@end
