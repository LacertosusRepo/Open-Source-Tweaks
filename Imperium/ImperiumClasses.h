//Thanks to hmm-Norah on github
enum mediaActions {
  doNothing = 0,
  playPause,
  skipForward,
  skipBack,
  nowPlaying,
  volumeUp,
  volumeDown,
  volumeMute,
};
enum feedbackStrengths{
  lightForce = 0,
  mediumForce,
  heavyForce,
  noForce
};

@interface FBApplicationProcess
-(void)killForReason:(long long)arg1 andReport:(BOOL)arg2 withDescription:(id)arg3 completion:(id)arg4;
@end

@interface FBProcessManager
+(id)sharedInstance;
-(id)createApplicationProcessForBundleID:(id)arg1;
@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface ImperiumGestureController : NSObject
+(void)selectGesture:(int)command;
+(void)callImpact:(int)forceLevel;
@end

@interface MediaControlsMaterialView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsTimeControl
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic,retain) UILabel * elapsedTimeLabel;                                       //@synthesize elapsedTimeLabel=_elapsedTimeLabel - In the implementation block
@property (nonatomic,retain) UILabel * remainingTimeLabel;
@end

@interface MediaControlsTransportButton
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsTransportStackView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsVolumeContainerView
@end

@interface SBApplication : NSObject
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
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

@interface VolumeControl
+(id)sharedVolumeControl;
-(void)cancelVolumeEvent;
-(void)increaseVolume;
-(void)decreaseVolume;
-(void)toggleMute;
@end
