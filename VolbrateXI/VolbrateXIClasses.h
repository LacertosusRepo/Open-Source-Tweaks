@interface VolumeControl : NSObject
+(id)sharedVolumeControl;
-(float)volume;
@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end
