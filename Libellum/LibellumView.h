#import <AudioToolbox/AudioToolbox.h>
#import <Cephei/HBPreferences.h>
#import "LGestureRecognizer.h"
#import "MTMaterialView.h"

#define filePath @"/User/Library/Preferences/LibellumNotes.rtf"
#define filePathBK @"/User/Library/Preferences/LibellumNotes.rtf.bk"

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

@interface SBMainDisplaySystemGestureManager : NSObject
+(id)sharedInstance;
-(void)addGestureRecognizer:(id)arg1 withType:(NSUInteger)arg2;
@end

@interface FBSystemGestureManager : NSObject
+(id)sharedInstance;
-(void)addGestureRecognizer:(id)arg1 toDisplay:(id)arg2;
@end

@interface FBDisplayManager : NSObject
+(id)mainDisplay;
@end

@interface _UIScrollViewScrollIndicator : UIView
@property (nonatomic,retain) UIView * roundedFillView;
@end

@interface UIImage (iOS13)
+(UIImage *)systemImageNamed:(NSString *)arg1;
@end

@interface UITextView (iOS13)
@property (nonatomic, readonly) _UIScrollViewScrollIndicator *verticalScrollIndicator;
@end

@interface KalmAPI : NSObject
+(UIColor *)getColor;
@end

@interface LibellumView : UIView <UITextViewDelegate>
@property (nonatomic, retain) UIImageView *lockIcon;
@property (nonatomic, retain) UITextView *noteView;
@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, readonly) LGestureRecognizer *lGesture;
@property (nonatomic, readonly) UIScreenEdgePanGestureRecognizer *edgeGesture;
@property (nonatomic, readonly) BOOL editing;
@property (nonatomic, readonly) BOOL authenticated;
@property (nonatomic, assign) CGSize sizeToMimic;

  //Preferences
@property (nonatomic, assign) NSUInteger noteSize;
@property (nonatomic, assign) BOOL enableUndoRedo;
@property (nonatomic, assign) BOOL enableEndlessLines;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, copy) NSString *blurStyle;
@property (nonatomic, assign) BOOL useKalmTintColor;
@property (nonatomic, assign) BOOL ignoreAdaptiveColors;
@property (nonatomic, copy) UIColor *customBackgroundColor;
@property (nonatomic, copy) UIColor *customTextColor;
@property (nonatomic, copy) UIColor *lockColor;
@property (nonatomic, copy) UIColor *customTintColor;
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) BOOL requireAuthentication;
@property (nonatomic, assign) BOOL noteBackup;
@property (nonatomic, assign) BOOL hideGesture;
@property (nonatomic, assign) BOOL useEdgeGesture;
@property (nonatomic, assign) BOOL useSwipeGesture;
@property (nonatomic, assign) BOOL useTapGesture;
@property (nonatomic, assign) BOOL feedback;
@property (nonatomic, assign) NSInteger feedbackStyle;
+(id)sharedInstance;
-(NSString *)getRecipeForBlurStyle:(NSString *)style;
-(UIBlurEffectStyle)getBlurEffectForBlurStyle:(NSString *)style;
-(void)setNumberOfLines;
-(void)authenticationStatusFromAggregator:(id)aggregator;
-(void)preferencesChanged;
-(void)saveNotes;
-(void)loadNotes;
-(void)backupNotes;
-(void)preferencesChanged;
-(void)toggleLibellum:(UIGestureRecognizer *)gesture;
@end
