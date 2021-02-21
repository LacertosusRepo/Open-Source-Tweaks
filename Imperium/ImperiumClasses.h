@interface MediaControlsTransportStackView : UIView
@end

@interface MediaControlsTransportButton : UIButton
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString *bundleIdentifier;
@end

@interface SBMediaController : NSObject
@property (copy) SBApplication *nowPlayingApplication;
+(id)sharedInstance;
-(id)_setNowPlayingApplication:(id)arg1;
@end

@interface SBUIController : NSObject
+(id)sharedInstance;
-(void)_activateApplicationFromAccessibility:(id)arg1;
@end

@interface VolumeControl : NSObject
+(id)sharedVolumeControl;
-(void)cancelVolumeEvent;
-(void)increaseVolume;
-(void)decreaseVolume;
-(void)toggleMute;
@end

@interface SBDashBoardScrollGestureController : NSObject
@end
