typedef NS_ENUM(NSInteger, FLIRVisibilityState) {
  FLIRVisibilityStatePresented = 1,
  FLIRVisibilityStateAnimating,
  FLIRVisibilityStateHidden,
};

@interface SBRecordingIndicatorView : UIView
@end

@interface SBRecordingIndicatorViewController : UIViewController
@property (nonatomic, readonly, getter=indicatorView) SBRecordingIndicatorView *indicatorView;

  //FlashlightIndicator
-(void)flir_updateIndicatorForFlashlightState:(NSNotification *)notification;
-(void)flir_startShowAnimator;
-(void)flir_startHideAnimator;
-(void)flir_stopAllAnimations;
@end
