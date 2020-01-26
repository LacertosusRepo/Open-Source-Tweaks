#line 1 "Tweak.x"







#import "NavaleClasses.h"
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "ColorFlowAPI.h"
#define LD_DEBUG NO

  
  CAGradientLayer *gradientLayer;
  SBFloatingDockPlatterView *floatingDockView;
  SBDockView *stockDockView;
  UIColor *colorOne;
  UIColor *colorTwo;
  BOOL isiOS13;

  
  static BOOL usingFloatingDock = NO;
  static BOOL useColorFlow = NO;
  static NSInteger gradientDirection = horizontal;
  static CGFloat dockAlpha = 1.0;
  static NSString *colorOneString;
  static NSString *colorTwoString;

  



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
@class CFWSBMediaController; @class SBDockView; @class SBFloatingDockPlatterView; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CFWSBMediaController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CFWSBMediaController"); } return _klass; }
#line 33 "Tweak.x"
   static Class _logos_superclass$StockDockHooks$SBDockView; static SBDockView*  _LOGOS_RETURN_RETAINED(*_logos_orig$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$)(_LOGOS_SELF_TYPE_INIT SBDockView*, SEL, id, BOOL);static void (*_logos_orig$StockDockHooks$SBDockView$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL);static void (*_logos_orig$StockDockHooks$SBDockView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL);
   
   __attribute__((used)) static UIColor * _logos_method$StockDockHooks$SBDockView$primaryColor(SBDockView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$StockDockHooks$SBDockView$primaryColor); }; __attribute__((used)) static void _logos_method$StockDockHooks$SBDockView$setPrimaryColor(SBDockView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$StockDockHooks$SBDockView$primaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }
   __attribute__((used)) static UIColor * _logos_method$StockDockHooks$SBDockView$secondaryColor(SBDockView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$StockDockHooks$SBDockView$secondaryColor); }; __attribute__((used)) static void _logos_method$StockDockHooks$SBDockView$setSecondaryColor(SBDockView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$StockDockHooks$SBDockView$secondaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }

   static SBDockView* _logos_method$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$(_LOGOS_SELF_TYPE_INIT SBDockView* __unused self, SEL __unused _cmd, id arg1, BOOL arg2) _LOGOS_RETURN_RETAINED {
     if(useColorFlow) {
       [[_logos_static_class_lookup$CFWSBMediaController() sharedInstance] addColorDelegate:self];
     }

     return stockDockView = (_logos_orig$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$ ? _logos_orig$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$ : (__typeof__(_logos_orig$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$))class_getMethodImplementation(_logos_superclass$StockDockHooks$SBDockView, @selector(initWithDockListView:forSnapshot:)))(self, _cmd, arg1, arg2);
   }

   static void _logos_method$StockDockHooks$SBDockView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
     (_logos_orig$StockDockHooks$SBDockView$didMoveToWindow ? _logos_orig$StockDockHooks$SBDockView$didMoveToWindow : (__typeof__(_logos_orig$StockDockHooks$SBDockView$didMoveToWindow))class_getMethodImplementation(_logos_superclass$StockDockHooks$SBDockView, @selector(didMoveToWindow)))(self, _cmd);

     if(!gradientLayer) {
       UIView *backgroundView = [self valueForKey:@"backgroundView"];

       gradientLayer = [CAGradientLayer layer];
       gradientLayer.frame = backgroundView.bounds;
       [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
     }
   }

   static void _logos_method$StockDockHooks$SBDockView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
     (_logos_orig$StockDockHooks$SBDockView$layoutSubviews ? _logos_orig$StockDockHooks$SBDockView$layoutSubviews : (__typeof__(_logos_orig$StockDockHooks$SBDockView$layoutSubviews))class_getMethodImplementation(_logos_superclass$StockDockHooks$SBDockView, @selector(layoutSubviews)))(self, _cmd);

     UIView *backgroundView = [self valueForKey:@"backgroundView"];
     if([backgroundView respondsToSelector:@selector(_materialLayer)]) {
       ((MTMaterialView *)backgroundView).weighting = 0;
       gradientLayer.cornerRadius = ((MTMaterialView *)backgroundView).materialLayer.cornerRadius;
     }
     if([backgroundView respondsToSelector:@selector(blurView)]) {
       ((SBWallpaperEffectView *)backgroundView).blurView.hidden = YES;
     }

     if(gradientDirection == verticle) {
       gradientLayer.startPoint = CGPointMake(0.5, 0.0);
       gradientLayer.endPoint = CGPointMake(0.5, 1.0);
     } else {
       gradientLayer.startPoint = CGPointMake(0.0, 0.5);
       gradientLayer.endPoint = CGPointMake(1.0, 0.5);
     }

     if(self.primaryColor == nil || self.secondaryColor == nil) {
       colorOne = [UIColor systemPurpleColor];
       colorTwo = [UIColor systemPinkColor];
     } else {
       colorOne = self.primaryColor;
       colorTwo = self.secondaryColor;
     }

     gradientLayer.opacity = dockAlpha;
     gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
     gradientLayer.frame = backgroundView.bounds;
   }

   
     static void _logos_method$StockDockHooks$SBDockView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song, UIImage * artwork, CFWColorInfo * colorInfo) {
       self.primaryColor = colorInfo.primaryColor;
       self.secondaryColor = colorInfo.secondaryColor;
       [self layoutSubviews];
     }

   
     static void _logos_method$StockDockHooks$SBDockView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song) {
       self.primaryColor = nil;
       self.secondaryColor = nil;
       [self layoutSubviews];
     }
   
   

  


   static Class _logos_superclass$FloatingDockHooks$SBFloatingDockPlatterView; static SBFloatingDockPlatterView*  _LOGOS_RETURN_RETAINED(*_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$)(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView*, SEL, double, double);static SBFloatingDockPlatterView*  _LOGOS_RETURN_RETAINED(*_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView*, SEL, CGRect);static void (*_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST, SEL);
   
       
     static SBFloatingDockPlatterView* _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView* __unused self, SEL __unused _cmd, double arg1, double arg2) _LOGOS_RETURN_RETAINED {
       if(useColorFlow) {
         [[_logos_static_class_lookup$CFWSBMediaController() sharedInstance] addColorDelegate:self];
       }

       return floatingDockView = (_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$ ? _logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$ : (__typeof__(_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$))class_getMethodImplementation(_logos_superclass$FloatingDockHooks$SBFloatingDockPlatterView, @selector(initWithReferenceHeight:maximumContinuousCornerRadius:)))(self, _cmd, arg1, arg2);
     }

       
     static SBFloatingDockPlatterView* _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView* __unused self, SEL __unused _cmd, CGRect arg1) _LOGOS_RETURN_RETAINED {
       if(useColorFlow) {
         [[_logos_static_class_lookup$CFWSBMediaController() sharedInstance] addColorDelegate:self];
       }

       return floatingDockView = (_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$ ? _logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$ : (__typeof__(_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$))class_getMethodImplementation(_logos_superclass$FloatingDockHooks$SBFloatingDockPlatterView, @selector(initWithFrame:)))(self, _cmd, arg1);
     }

     static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
       (_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews ? _logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews : (__typeof__(_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews))class_getMethodImplementation(_logos_superclass$FloatingDockHooks$SBFloatingDockPlatterView, @selector(layoutSubviews)))(self, _cmd);

       _UIBackdropView *backgroundView = [self valueForKey:@"_backgroundView"];
       backgroundView.alpha = dockAlpha;
       if(!isiOS13) {
         backgroundView.backdropEffectView.hidden = YES;
       }

       if(!gradientLayer) {
         gradientLayer = [CAGradientLayer layer];
         [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
       }

       if(gradientDirection == verticle) {
         gradientLayer.startPoint = CGPointMake(0.5, 0.0);
         gradientLayer.endPoint = CGPointMake(0.5, 1.0);
       } else {
         gradientLayer.startPoint = CGPointMake(0.0, 0.5);
         gradientLayer.endPoint = CGPointMake(1.0, 0.5);
       }

       if(self.primaryColor == nil || self.secondaryColor == nil) {
         colorOne = [UIColor systemPurpleColor];
         colorTwo = [UIColor systemPinkColor];
       } else {
         colorOne = self.primaryColor;
         colorTwo = self.secondaryColor;
       }

       gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
       gradientLayer.frame = backgroundView.bounds;
       gradientLayer.cornerRadius = [self maximumContinuousCornerRadius];
     }

   
     static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song, UIImage * artwork, CFWColorInfo * colorInfo) {
       self.primaryColor = colorInfo.primaryColor;
       self.secondaryColor = colorInfo.secondaryColor;
       [self layoutSubviews];
     }

   
     static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song) {
       self.primaryColor = nil;
       self.secondaryColor = nil;
       [self layoutSubviews];
     }
   
   


























static __attribute__((constructor)) void _logosLocalCtor_901ed790(int __unused argc, char __unused **argv, char __unused **envp) {
  














  if(usingFloatingDock) {
    {Class _logos_class$FloatingDockHooks$SBFloatingDockPlatterView = objc_getClass("SBFloatingDockPlatterView"); _logos_superclass$FloatingDockHooks$SBFloatingDockPlatterView = class_getSuperclass(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView); { _logos_register_hook$(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(initWithReferenceHeight:maximumContinuousCornerRadius:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$, (IMP *)&_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$);}{ _logos_register_hook$(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(initWithFrame:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$, (IMP *)&_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithFrame$);}{ _logos_register_hook$(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(layoutSubviews), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews, (IMP *)&_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); memcpy(_typeEncoding + i, @encode(CFWColorInfo *), strlen(@encode(CFWColorInfo *))); i += strlen(@encode(CFWColorInfo *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(songAnalysisComplete:artwork:colorInfo:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songAnalysisComplete$artwork$colorInfo$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(songHadNoArtwork:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songHadNoArtwork$, _typeEncoding); }}
  } else {
    {Class _logos_class$StockDockHooks$SBDockView = objc_getClass("SBDockView"); _logos_superclass$StockDockHooks$SBDockView = class_getSuperclass(_logos_class$StockDockHooks$SBDockView); { _logos_register_hook$(_logos_class$StockDockHooks$SBDockView, @selector(initWithDockListView:forSnapshot:), (IMP)&_logos_method$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$, (IMP *)&_logos_orig$StockDockHooks$SBDockView$initWithDockListView$forSnapshot$);}{ _logos_register_hook$(_logos_class$StockDockHooks$SBDockView, @selector(didMoveToWindow), (IMP)&_logos_method$StockDockHooks$SBDockView$didMoveToWindow, (IMP *)&_logos_orig$StockDockHooks$SBDockView$didMoveToWindow);}{ _logos_register_hook$(_logos_class$StockDockHooks$SBDockView, @selector(layoutSubviews), (IMP)&_logos_method$StockDockHooks$SBDockView$layoutSubviews, (IMP *)&_logos_orig$StockDockHooks$SBDockView$layoutSubviews);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); memcpy(_typeEncoding + i, @encode(CFWColorInfo *), strlen(@encode(CFWColorInfo *))); i += strlen(@encode(CFWColorInfo *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(songAnalysisComplete:artwork:colorInfo:), (IMP)&_logos_method$StockDockHooks$SBDockView$songAnalysisComplete$artwork$colorInfo$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(songHadNoArtwork:), (IMP)&_logos_method$StockDockHooks$SBDockView$songHadNoArtwork$, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(primaryColor), (IMP)&_logos_method$StockDockHooks$SBDockView$primaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(setPrimaryColor:), (IMP)&_logos_method$StockDockHooks$SBDockView$setPrimaryColor, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(secondaryColor), (IMP)&_logos_method$StockDockHooks$SBDockView$secondaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$StockDockHooks$SBDockView, @selector(setSecondaryColor:), (IMP)&_logos_method$StockDockHooks$SBDockView$setSecondaryColor, _typeEncoding); } }
  }

  if([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending) {
    isiOS13 = YES;
  }
}
