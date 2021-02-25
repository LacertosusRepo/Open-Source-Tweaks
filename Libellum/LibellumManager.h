#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
@import Alderis;
#import "AlderisColorPicker.h"
#import "LibellumViewController.h"
#import "HBLog.h"

@interface UIApplication (Private)
-(UIInterfaceOrientation)activeInterfaceOrientation;
@end

@interface CSCoverSheetViewController : UIViewController
-(BOOL)_isMainPageShowing;
@end

@interface SBLockScreenViewControllerBase : UIViewController
-(BOOL)isMainPageVisible;
@end

@interface SBLockScreenManager : NSObject
@property (nonatomic, readonly) CSCoverSheetViewController *coverSheetViewController;       //iOS 13
@property (nonatomic, readonly) SBLockScreenViewControllerBase *lockScreenViewController;   //iOS 12
@end

@protocol SBSystemGestureRecognizerDelegate <UIGestureRecognizerDelegate>
@required
-(UIView *)viewForSystemGestureRecognizer:(UIGestureRecognizer *)gesture;
@end

@interface SBMainDisplaySystemGestureManager : NSObject
+(instancetype)sharedInstance;
-(void)addGestureRecognizer:(id)arg1 withType:(NSUInteger)arg2;
@end

@interface SBSystemGestureManager : NSObject
+(instancetype)mainDisplayManager;
@end

@interface FBSystemGestureManager : NSObject
+(instancetype)sharedInstance;
-(void)addGestureRecognizer:(id)arg1 toDisplayWithIdentity:(id)arg2;
@end

@interface SBScreenEdgePanGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic, assign) NSInteger edges;
-(instancetype)initWithTarget:(id)arg1 action:(SEL)arg2;
@end

@interface SBLockStateAggregator : NSObject
+(instancetype)sharedInstance;
-(NSUInteger)lockState;
@end

@interface SBIdleTimerGlobalCoordinator : NSObject
+(instancetype)sharedInstance;
-(void)resetIdleTimer;
@end

@interface KalmAPI : NSObject
+(UIColor *)getColor;
@end

@interface LibellumManager : NSObject <UIPageViewControllerDataSource, UITextViewDelegate, SBSystemGestureRecognizerDelegate>
@property (nonatomic, retain) HBPreferences *preferences;
@property (nonatomic, retain, readonly) NSMutableDictionary *notesByIndex;
@property (nonatomic, retain, readonly) NSMutableArray *pages;
@property (nonatomic, retain) UIPageViewController *pageController;
@property (nonatomic, retain) NSLayoutConstraint *heightConstraint;
@property (nonatomic, retain) UITextView *activeTextView;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic, readonly) SBScreenEdgePanGestureRecognizer *edgeGesture;
@property (nonatomic, assign) BOOL isDarkMode;
+(instancetype)sharedManager;
-(instancetype)init;
-(void)createPages;
-(void)addPage;
-(void)removePage;
-(void)disablePageScroll:(BOOL)pageScroll;
-(void)authenticationStatusFromAggregator:(id)aggregator;
-(void)setToolBarButtons:(BOOL)showPageManagement;
-(void)toggleLibellum:(UIGestureRecognizer *)gesture;
-(void)forceLockScreenStackViewLayout;
-(void)saveNotes;
-(void)backupNotes;
-(void)preferencesChanged;
-(void)notifyViewControllersOfInterfaceChange:(NSInteger)style;
-(UIColor *)getTintColor;
-(BOOL)isDarkMode;
@end
