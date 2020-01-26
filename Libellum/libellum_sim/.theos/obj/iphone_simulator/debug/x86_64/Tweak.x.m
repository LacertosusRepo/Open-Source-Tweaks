#line 1 "Tweak.x"







#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "LibellumView.h"
#import "LibellumClasses.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

    


  static CSScrollView *scrollViewCS;
  static SBPagedScrollView *scrollViewSB;

    


  static NSInteger noteSize = 121;
  static CGFloat cornerRadius = 10;
  static NSInteger blurStyle = 2;
  
  
  
  static CGFloat borderWidth = 2;
  static BOOL requireAuthentication = YES;
  static BOOL noteBackup = NO;
  static BOOL hideGesture = YES;
  static BOOL feedback = NO;
  static NSInteger feedbackStyle = 1520;

#pragma mark - iOS 13

  




#include <objc/message.h>
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

__attribute__((unused)) static void _logos_register_hook$(Class _class, SEL _cmd, IMP _new, IMP *_old) {
unsigned int _count, _i;
Class _searchedClass = _class;
Method *_methods;
while (_searchedClass) {
_methods = class_copyMethodList(_searchedClass, &_count);
for (_i = 0; _i < _count; _i++) {
if (method_getName(_methods[_i]) == _cmd) {
if (_class == _searchedClass) {
*_old = method_getImplementation(_methods[_i]);
*_old = method_setImplementation(_methods[_i], _new);
} else {
class_addMethod(_class, _cmd, _new, method_getTypeEncoding(_methods[_i]));
}
free(_methods);
return;
}
}
free(_methods);
_searchedClass = class_getSuperclass(_searchedClass);
}
}
@class SBLockStateAggregator; @class SBPagedScrollView; @class CSScrollView; @class CSNotificationAdjunctListViewController; @class SBDashBoardNotificationAdjunctListViewController; 
static Class _logos_superclass$_ungrouped$CSNotificationAdjunctListViewController; static void (*_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL CSNotificationAdjunctListViewController* _LOGOS_SELF_CONST, SEL);static BOOL (*_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent)(_LOGOS_SELF_TYPE_NORMAL CSNotificationAdjunctListViewController* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$CSScrollView; static CSScrollView*  _LOGOS_RETURN_RETAINED(*_logos_orig$_ungrouped$CSScrollView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT CSScrollView*, SEL, CGRect);static Class _logos_superclass$_ungrouped$SBDashBoardNotificationAdjunctListViewController; static void (*_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL SBDashBoardNotificationAdjunctListViewController* _LOGOS_SELF_CONST, SEL);static BOOL (*_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent)(_LOGOS_SELF_TYPE_NORMAL SBDashBoardNotificationAdjunctListViewController* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$SBPagedScrollView; static SBPagedScrollView*  _LOGOS_RETURN_RETAINED(*_logos_orig$_ungrouped$SBPagedScrollView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT SBPagedScrollView*, SEL, CGRect);static Class _logos_superclass$_ungrouped$SBLockStateAggregator; static void (*_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState)(_LOGOS_SELF_TYPE_NORMAL SBLockStateAggregator* _LOGOS_SELF_CONST, SEL);

#line 43 "Tweak.x"

__attribute__((used)) static LibellumView * _logos_method$_ungrouped$CSNotificationAdjunctListViewController$LBMNoteView(CSNotificationAdjunctListViewController * __unused self, SEL __unused _cmd) { return (LibellumView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$CSNotificationAdjunctListViewController$LBMNoteView); }; __attribute__((used)) static void _logos_method$_ungrouped$CSNotificationAdjunctListViewController$setLBMNoteView(CSNotificationAdjunctListViewController * __unused self, SEL __unused _cmd, LibellumView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$CSNotificationAdjunctListViewController$LBMNoteView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
  static void _logos_method$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL CSNotificationAdjunctListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    (_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad ? _logos_orig$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad : (__typeof__(_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad))class_getMethodImplementation(_logos_superclass$_ungrouped$CSNotificationAdjunctListViewController, @selector(viewDidLoad)))(self, _cmd);

    if(!self.LBMNoteView) {
      self.LBMNoteView = [[LibellumView sharedInstance] initWithFrame:CGRectZero];
      [self.LBMNoteView setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

      [[scrollViewCS panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.dismissGesture];
    }
  }

  static BOOL _logos_method$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent(_LOGOS_SELF_TYPE_NORMAL CSNotificationAdjunctListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if([self.LBMNoteView isDescendantOfView:self.stackView]) {
      return YES;
    }

    return (_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent ? _logos_orig$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent : (__typeof__(_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent))class_getMethodImplementation(_logos_superclass$_ungrouped$CSNotificationAdjunctListViewController, @selector(isPresentingContent)))(self, _cmd);
  }


  



  static CSScrollView* _logos_method$_ungrouped$CSScrollView$initWithFrame$(_LOGOS_SELF_TYPE_INIT CSScrollView* __unused self, SEL __unused _cmd, CGRect ag1) _LOGOS_RETURN_RETAINED {
    UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    toggleGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:toggleGesture];

    return scrollViewCS = (_logos_orig$_ungrouped$CSScrollView$initWithFrame$ ? _logos_orig$_ungrouped$CSScrollView$initWithFrame$ : (__typeof__(_logos_orig$_ungrouped$CSScrollView$initWithFrame$))class_getMethodImplementation(_logos_superclass$_ungrouped$CSScrollView, @selector(initWithFrame:)))(self, _cmd, ag1);
  }


  static void _logos_method$_ungrouped$CSScrollView$handleTaps$(_LOGOS_SELF_TYPE_NORMAL CSScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITapGestureRecognizer * gesture) {
    [[LibellumView sharedInstance] toggleLibellum:gesture];
  }


#pragma mark - iOS 12

  




__attribute__((used)) static LibellumView * _logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$LBMNoteView(SBDashBoardNotificationAdjunctListViewController * __unused self, SEL __unused _cmd) { return (LibellumView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$LBMNoteView); }; __attribute__((used)) static void _logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$setLBMNoteView(SBDashBoardNotificationAdjunctListViewController * __unused self, SEL __unused _cmd, LibellumView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$LBMNoteView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
  static void _logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SBDashBoardNotificationAdjunctListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    (_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad ? _logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad : (__typeof__(_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad))class_getMethodImplementation(_logos_superclass$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(viewDidLoad)))(self, _cmd);

    if(!self.LBMNoteView) {
      self.LBMNoteView = [[LibellumView sharedInstance] initWithFrame:CGRectZero];
      [self.LBMNoteView setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

      [[scrollViewSB panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.dismissGesture];
    }
  }

  static BOOL _logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent(_LOGOS_SELF_TYPE_NORMAL SBDashBoardNotificationAdjunctListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if([self.LBMNoteView isDescendantOfView:self.stackView]) {
      return YES;
    }

    return (_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent ? _logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent : (__typeof__(_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent))class_getMethodImplementation(_logos_superclass$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(isPresentingContent)))(self, _cmd);
  }


    


  
    static SBPagedScrollView* _logos_method$_ungrouped$SBPagedScrollView$initWithFrame$(_LOGOS_SELF_TYPE_INIT SBPagedScrollView* __unused self, SEL __unused _cmd, CGRect ag1) _LOGOS_RETURN_RETAINED {
      UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
      toggleGesture.numberOfTapsRequired = 3;
      [self addGestureRecognizer:toggleGesture];

      return scrollViewSB = (_logos_orig$_ungrouped$SBPagedScrollView$initWithFrame$ ? _logos_orig$_ungrouped$SBPagedScrollView$initWithFrame$ : (__typeof__(_logos_orig$_ungrouped$SBPagedScrollView$initWithFrame$))class_getMethodImplementation(_logos_superclass$_ungrouped$SBPagedScrollView, @selector(initWithFrame:)))(self, _cmd, ag1);
    }

  
    static void _logos_method$_ungrouped$SBPagedScrollView$handleTaps$(_LOGOS_SELF_TYPE_NORMAL SBPagedScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITapGestureRecognizer * gesture) {
      [[LibellumView sharedInstance] toggleLibellum:gesture];
    }
  

#pragma mark - iOS 12 & 13

  




  static void _logos_method$_ungrouped$SBLockStateAggregator$_updateLockState(_LOGOS_SELF_TYPE_NORMAL SBLockStateAggregator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    (_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState ? _logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState : (__typeof__(_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState))class_getMethodImplementation(_logos_superclass$_ungrouped$SBLockStateAggregator, @selector(_updateLockState)))(self, _cmd);

    if(requireAuthentication) {
      [[LibellumView sharedInstance] authenticationStatusFromAggregator:self];
    }
  }


  


static NSInteger decideBlurStyle(NSInteger blurStyle) {
  if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0 ,0}]) {
    switch (blurStyle) {
      case lightStyle:
      return 12;  
      break;

      case darkStyle:
      return 17;  
      break;

      case colorizedStyle:
      return 3;
      break;

      case adaptive:
      return 7; 
      break;
    }
  } else {
    switch (blurStyle) {
      case lightStyle:
      return UIBlurEffectStyleLight;
      break;

      case darkStyle:
      return UIBlurEffectStyleDark;
      break;

      case colorizedStyle:
      return 3;
      break;

      case adaptive:
      return UIBlurEffectStyleRegular;
      break;
    }
  }

  return UIBlurEffectStyleRegular;
}

  


static void libellumPreferencesChanged() {
  LibellumView *LBMNoteView = [LibellumView sharedInstance];
  LBMNoteView.noteSize = noteSize;
  LBMNoteView.cornerRadius = cornerRadius;
  LBMNoteView.blurStyle = decideBlurStyle(blurStyle);
  LBMNoteView.customBackgroundColor = [UIColor blackColor];
  LBMNoteView.customTextColor = [UIColor whiteColor];
  LBMNoteView.borderColor = [UIColor whiteColor];
  LBMNoteView.borderWidth = borderWidth;
  LBMNoteView.requireAuthentication = requireAuthentication;
  LBMNoteView.noteBackup = noteBackup;
  LBMNoteView.hideGesture = hideGesture;
  LBMNoteView.feedback = feedback;
  LBMNoteView.feedbackStyle = feedbackStyle;
  [LBMNoteView preferencesChanged];
}


















static __attribute__((constructor)) void _logosLocalCtor_26424bbc(int __unused argc, char __unused **argv, char __unused **envp) {
  libellumPreferencesChanged();

  






















}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CSNotificationAdjunctListViewController = objc_getClass("CSNotificationAdjunctListViewController"); _logos_superclass$_ungrouped$CSNotificationAdjunctListViewController = class_getSuperclass(_logos_class$_ungrouped$CSNotificationAdjunctListViewController); { _logos_register_hook$(_logos_class$_ungrouped$CSNotificationAdjunctListViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad, (IMP *)&_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$viewDidLoad);}{ _logos_register_hook$(_logos_class$_ungrouped$CSNotificationAdjunctListViewController, @selector(isPresentingContent), (IMP)&_logos_method$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent, (IMP *)&_logos_orig$_ungrouped$CSNotificationAdjunctListViewController$isPresentingContent);}{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(LibellumView *)); class_addMethod(_logos_class$_ungrouped$CSNotificationAdjunctListViewController, @selector(LBMNoteView), (IMP)&_logos_method$_ungrouped$CSNotificationAdjunctListViewController$LBMNoteView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(LibellumView *)); class_addMethod(_logos_class$_ungrouped$CSNotificationAdjunctListViewController, @selector(setLBMNoteView:), (IMP)&_logos_method$_ungrouped$CSNotificationAdjunctListViewController$setLBMNoteView, _typeEncoding); } Class _logos_class$_ungrouped$CSScrollView = objc_getClass("CSScrollView"); _logos_superclass$_ungrouped$CSScrollView = class_getSuperclass(_logos_class$_ungrouped$CSScrollView); { _logos_register_hook$(_logos_class$_ungrouped$CSScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$CSScrollView$initWithFrame$, (IMP *)&_logos_orig$_ungrouped$CSScrollView$initWithFrame$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITapGestureRecognizer *), strlen(@encode(UITapGestureRecognizer *))); i += strlen(@encode(UITapGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CSScrollView, @selector(handleTaps:), (IMP)&_logos_method$_ungrouped$CSScrollView$handleTaps$, _typeEncoding); }Class _logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController = objc_getClass("SBDashBoardNotificationAdjunctListViewController"); _logos_superclass$_ungrouped$SBDashBoardNotificationAdjunctListViewController = class_getSuperclass(_logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController); { _logos_register_hook$(_logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad, (IMP *)&_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$viewDidLoad);}{ _logos_register_hook$(_logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(isPresentingContent), (IMP)&_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent, (IMP *)&_logos_orig$_ungrouped$SBDashBoardNotificationAdjunctListViewController$isPresentingContent);}{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(LibellumView *)); class_addMethod(_logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(LBMNoteView), (IMP)&_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$LBMNoteView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(LibellumView *)); class_addMethod(_logos_class$_ungrouped$SBDashBoardNotificationAdjunctListViewController, @selector(setLBMNoteView:), (IMP)&_logos_method$_ungrouped$SBDashBoardNotificationAdjunctListViewController$setLBMNoteView, _typeEncoding); } Class _logos_class$_ungrouped$SBPagedScrollView = objc_getClass("SBPagedScrollView"); _logos_superclass$_ungrouped$SBPagedScrollView = class_getSuperclass(_logos_class$_ungrouped$SBPagedScrollView); { _logos_register_hook$(_logos_class$_ungrouped$SBPagedScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$SBPagedScrollView$initWithFrame$, (IMP *)&_logos_orig$_ungrouped$SBPagedScrollView$initWithFrame$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITapGestureRecognizer *), strlen(@encode(UITapGestureRecognizer *))); i += strlen(@encode(UITapGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBPagedScrollView, @selector(handleTaps:), (IMP)&_logos_method$_ungrouped$SBPagedScrollView$handleTaps$, _typeEncoding); }Class _logos_class$_ungrouped$SBLockStateAggregator = objc_getClass("SBLockStateAggregator"); _logos_superclass$_ungrouped$SBLockStateAggregator = class_getSuperclass(_logos_class$_ungrouped$SBLockStateAggregator); { _logos_register_hook$(_logos_class$_ungrouped$SBLockStateAggregator, @selector(_updateLockState), (IMP)&_logos_method$_ungrouped$SBLockStateAggregator$_updateLockState, (IMP *)&_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState);}} }
#line 256 "Tweak.x"
