typedef NS_ENUM(NSInteger, IRIndicatorType) {
  IRIndicatorTypeFlashlight = 1,
  IRIndicatorTypeVPN,
  IRIndicatorTypeDND,
};

@interface DNDState : NSObject
-(BOOL)isActive;
@end

@interface DNDStateUpdate : NSObject
@property (nonatomic, copy, readonly) DNDState *state;
@end

@interface DNDRequestDetails : NSObject
+(instancetype)detailsRepresentingNowWithClientIdentifier:(NSString *)ar1;
@end

@interface DNDRemoteServiceConnection : NSObject
+(instancetype)sharedInstance;
-(void)addEventListener:(id)arg1;
-(void)queryStateWithRequestDetails:(DNDRequestDetails *)arg1 completionHandler:(id)arg2;
@end

@protocol DNDRemoteServiceConnectionEventListener <NSObject>
@optional
-(void)remoteService:(DNDRemoteServiceConnection *)arg1 didReceiveDoNotDisturbStateUpdate:(DNDStateUpdate *)arg2;
@required
-(NSString *)clientIdentifier;
@end

@interface SBRecordingIndicatorView : UIView
  //Indicators
@property (nonatomic, retain) UIViewPropertyAnimator *overScaleAnimation;
@property (nonatomic, retain) UIViewPropertyAnimator *normalScaleAnimation;
@property (nonatomic, retain) UIViewPropertyAnimator *restScaleAnimation;
@property (nonatomic, retain) UIViewPropertyAnimator *zeroScaleAnimation;
-(void)ir_startShowAnimatorForIndicatorWithSize:(CGFloat)size;
-(void)ir_startHideAnimatorForIndicator;
-(void)ir_stopAllAnimations;
@end

@interface SBRecordingIndicatorViewController : UIViewController <DNDRemoteServiceConnectionEventListener>
  //Indicators
-(NSInteger)ir_spacingMultiplierForIndicatorType:(IRIndicatorType)indicatorType;
-(void)ir_updateIndicators;
-(void)ir_updateIndicatorForFlashlightState:(NSNotification *)notification;
-(void)ir_updateIndicatorForVPNState:(NSNotification *)notification;
@end

@interface UIColor (iOS14)
+(instancetype)dynamicColorWithLightColor:(UIColor *)arg1 darkColor:(UIColor *)arg2;
@end

@interface SBTelephonyManager : NSObject
+(instancetype)sharedTelephonyManager;
-(BOOL)isUsingVPNConnection;
@end
