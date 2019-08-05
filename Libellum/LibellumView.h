#import <AudioToolbox/AudioToolbox.h>

@interface LibellumView : UIView <UITextViewDelegate>
@property (nonatomic, retain) UITextView *noteView;
@property (nonatomic, retain) UIVisualEffectView *blurView;
@property (nonatomic, readonly) BOOL editing;
@property (nonatomic, readonly) BOOL authenticated;

  //Preferences
@property (nonatomic, assign) NSInteger blurStyle;
@property (nonatomic, retain) UIColor *customBackgroundColor;
@property (nonatomic, retain) UIColor *customTextColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSUInteger noteSize;
@property (nonatomic, assign) BOOL requireAuthentication;
@property (nonatomic, assign) BOOL hideGesture;
@property (nonatomic, assign) BOOL feedback;
@property (nonatomic, assign) NSUInteger feedbackStyle;
+(id)sharedInstance;
-(void)setNumberOfLines;
-(void)authenticationStatusFromAggregator:(id)aggregator;
-(void)preferencesChanged;
-(void)saveNotes;
-(void)loadNotes;
-(void)preferencesChanged;
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(NSUInteger)lockState;
@end
