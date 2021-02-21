enum imperiumActions {
  doNothing = 0,
  togglePlayPause,
  skipForward,
  skipBack,
  openNowPlaying,
  volumeUp,
  volumeDown,
  volumeMute,
};

enum feedbackStrengths {
  lightForce = 0,
  mediumForce,
  heavyForce,
  noForce,
  nonHaptic,
};

@interface ImperiumController : NSObject
+(void)gestureWithCommand:(NSInteger)command;
+(void)feedbackWithForce:(NSInteger)force;
@end
