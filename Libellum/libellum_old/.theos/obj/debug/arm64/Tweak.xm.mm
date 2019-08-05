#line 1 "Tweak.xm"








#import "LIBNoteView.h"
#define LD_DEBUG NO

@interface SBHomeScreenView : UIView
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBDashBoardViewController; @class UIStatusBar; @class SBHomeScreenView; 
static void (*_logos_orig$_ungrouped$SBDashBoardViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL SBDashBoardViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBDashBoardViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SBDashBoardViewController* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$)(_LOGOS_SELF_TYPE_NORMAL UIStatusBar* _LOGOS_SELF_CONST, SEL, CGRect, BOOL, id); static id _logos_method$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$(_LOGOS_SELF_TYPE_NORMAL UIStatusBar* _LOGOS_SELF_CONST, SEL, CGRect, BOOL, id); static void _logos_method$_ungrouped$UIStatusBar$toggleLIBNoteView$(_LOGOS_SELF_TYPE_NORMAL UIStatusBar* _LOGOS_SELF_CONST, SEL, UILongPressGestureRecognizer *); static void (*_logos_orig$_ungrouped$SBHomeScreenView$setFrame$)(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenView* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$_ungrouped$SBHomeScreenView$setFrame$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenView* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$_ungrouped$SBHomeScreenView$toggleLIBNoteView$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenView* _LOGOS_SELF_CONST, SEL, UIPinchGestureRecognizer *); 

#line 15 "Tweak.xm"

  static void _logos_method$_ungrouped$SBDashBoardViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SBDashBoardViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$SBDashBoardViewController$viewDidLoad(self, _cmd);
    [LIBNoteView sharedInstance];
  }



  static id _logos_method$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$(_LOGOS_SELF_TYPE_NORMAL UIStatusBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1, BOOL arg2, id arg3){
    
    
    return _logos_orig$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$(self, _cmd, arg1, arg2, arg3);
  }

  static void _logos_method$_ungrouped$UIStatusBar$toggleLIBNoteView$(_LOGOS_SELF_TYPE_NORMAL UIStatusBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UILongPressGestureRecognizer * gesture) {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      [[LIBNoteView sharedInstance] showNoteView];
    }
  }



  static void _logos_method$_ungrouped$SBHomeScreenView$setFrame$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1) {
    _logos_orig$_ungrouped$SBHomeScreenView$setFrame$(self, _cmd, arg1);
    UILongPressGestureRecognizer *pinchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLIBNoteView:)];
    pinchGesture.minimumPressDuration = 1.0;
    pinchGesture.allowableMovement = 0;
    [self addGestureRecognizer:pinchGesture];
  }


  static void _logos_method$_ungrouped$SBHomeScreenView$toggleLIBNoteView$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPinchGestureRecognizer * gesture) {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      [[LIBNoteView sharedInstance] showNoteView];
    }
  }


static __attribute__((constructor)) void _logosLocalCtor_544b3284(int __unused argc, char __unused **argv, char __unused **envp) {
  NSString *bundleIDs = [[NSBundle mainBundle] bundleIdentifier];
  if(![bundleIDs isEqualToString:@"com.apple.springboard"]) {
    [[LIBNoteView sharedInstance] hideNoteView];
  }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBDashBoardViewController = objc_getClass("SBDashBoardViewController"); MSHookMessageEx(_logos_class$_ungrouped$SBDashBoardViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$SBDashBoardViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$SBDashBoardViewController$viewDidLoad);Class _logos_class$_ungrouped$UIStatusBar = objc_getClass("UIStatusBar"); MSHookMessageEx(_logos_class$_ungrouped$UIStatusBar, @selector(_initWithFrame:showForegroundView:inProcessStateProvider:), (IMP)&_logos_method$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$, (IMP*)&_logos_orig$_ungrouped$UIStatusBar$_initWithFrame$showForegroundView$inProcessStateProvider$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UILongPressGestureRecognizer *), strlen(@encode(UILongPressGestureRecognizer *))); i += strlen(@encode(UILongPressGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UIStatusBar, @selector(toggleLIBNoteView:), (IMP)&_logos_method$_ungrouped$UIStatusBar$toggleLIBNoteView$, _typeEncoding); }Class _logos_class$_ungrouped$SBHomeScreenView = objc_getClass("SBHomeScreenView"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeScreenView, @selector(setFrame:), (IMP)&_logos_method$_ungrouped$SBHomeScreenView$setFrame$, (IMP*)&_logos_orig$_ungrouped$SBHomeScreenView$setFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPinchGestureRecognizer *), strlen(@encode(UIPinchGestureRecognizer *))); i += strlen(@encode(UIPinchGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBHomeScreenView, @selector(toggleLIBNoteView:), (IMP)&_logos_method$_ungrouped$SBHomeScreenView$toggleLIBNoteView$, _typeEncoding); }} }
#line 59 "Tweak.xm"
