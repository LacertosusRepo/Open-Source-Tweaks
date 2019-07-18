@interface LibellumView : UIView <UITextViewDelegate>
@property (nonatomic, retain) UITextView *noteView;
@property (nonatomic, retain) UIVisualEffectView *blurView;
@property (nonatomic, readonly) BOOL editing;
@property (nonatomic, readonly) BOOL authenticated;

  //Preferences
@property (nonatomic, assign) NSInteger blurStyle;
@property (nonatomic, retain) UIColor *customTextColor;
@property (nonatomic, retain) UIColor *customBackgroundColor;
@property (nonatomic, assign) NSUInteger noteSize;
@property (nonatomic, assign) BOOL requireAuthentication;
+(id)sharedInstance;
-(void)authenticationStatusFromAggregator:(id)aggregator;
-(void)preferencesChanged;
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(NSUInteger)lockState;
@end
