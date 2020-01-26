#import <AudioToolbox/AudioToolbox.h>

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(NSUInteger)lockState;
@end

@interface UIUserInterfaceStyleArbiter : NSObject
+(id)sharedInstance;
-(long long)currentStyle;
@end

@interface SBIdleTimerBehavior : NSObject
+(id)lockScreenBehavior;
@end

@interface SBIdleTimerGlobalCoordinator : NSObject
+(id)sharedInstance;
-(void)resetIdleTimer;
@end

@interface UIImage (iOS13)
+(UIImage *)systemImageNamed:(NSString *)arg1;
@end

@interface LibellumView : UIView <UITextViewDelegate>
@property (nonatomic, retain) UIImageView *lockIcon;
@property (nonatomic, retain) UITextView *noteView;
@property (nonatomic, retain) UIVisualEffectView *blurView;
@property (nonatomic, retain) UIVisualEffectView *vibrancyView;
@property (nonatomic, readonly) UISwipeGestureRecognizer *dismissGesture;
@property (nonatomic, readonly) BOOL editing;
@property (nonatomic, readonly) BOOL authenticated;
@property (nonatomic, assign) CGSize sizeToMimic;

  //Preferences
@property (nonatomic, assign) NSUInteger noteSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSInteger blurStyle;
@property (nonatomic, assign) BOOL ignoreAdaptiveColors;
@property (nonatomic, retain) UIColor *customBackgroundColor;
@property (nonatomic, retain) UIColor *customTextColor;
@property (nonatomic, retain) UIColor *lockColor;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) BOOL requireAuthentication;
@property (nonatomic, assign) BOOL noteBackup;
@property (nonatomic, assign) BOOL hideGesture;
@property (nonatomic, assign) BOOL feedback;
@property (nonatomic, assign) NSInteger feedbackStyle;
+(id)sharedInstance;
-(void)setNumberOfLines;
-(void)authenticationStatusFromAggregator:(id)aggregator;
-(void)preferencesChanged;
-(void)saveNotes;
-(void)loadNotes;
-(void)backupNotes;
-(void)preferencesChanged;
-(void)toggleLibellum:(UIGestureRecognizer *)gesture;
@end
