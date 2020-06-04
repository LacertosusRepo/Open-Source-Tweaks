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

@interface AVAudioPlayer : NSObject
-(id)initWithContentsOfURL:(NSURL *)url error:(NSError *)error;
-(void)play;
@end

@interface AVAudioSession : NSObject
+(id)sharedInstance;
-(void)setCategory:(id)category error:(NSError *)error;
@end

@interface LBMNoteBackupViewController : UIViewController
@end
