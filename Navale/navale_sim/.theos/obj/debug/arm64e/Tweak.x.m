#line 1 "Tweak.x"







#import <Cephei/HBPreferences.h>
#import "NavaleClasses.h"
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "ColorFlowAPI.h"
#import "libcolorpicker.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

  
  CAGradientLayer *gradientLayer;
  SBFloatingDockPlatterView *floatingDockView;
  SBDockView *dockView;
  UIColor *colorOne;
  UIColor *colorTwo;

  
  static BOOL usingFloatingDock;
  static BOOL useColorFlow;
  static NSInteger gradientDirection;
  static CGFloat dockAlpha;
  static NSString *colorOneString;
  static NSString *colorTwoString;

  



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

@class SBDockView; @class SBFloatingDockPlatterView; @class CFWSBMediaController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CFWSBMediaController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CFWSBMediaController"); } return _klass; }
#line 35 "Tweak.x"
static SBDockView* (*_logos_orig$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$)(_LOGOS_SELF_TYPE_INIT SBDockView*, SEL, id, BOOL) _LOGOS_RETURN_RETAINED; static SBDockView* _logos_method$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$(_LOGOS_SELF_TYPE_INIT SBDockView*, SEL, id, BOOL) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$RegularDockHooks$SBDockView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL); static void _logos_method$RegularDockHooks$SBDockView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL); static void _logos_method$RegularDockHooks$SBDockView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL, MPModelSong *, UIImage *, CFWColorInfo *); static void _logos_method$RegularDockHooks$SBDockView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST, SEL, MPModelSong *); 

__attribute__((used)) static UIColor * _logos_method$RegularDockHooks$SBDockView$primaryColor(SBDockView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$RegularDockHooks$SBDockView$primaryColor); }; __attribute__((used)) static void _logos_method$RegularDockHooks$SBDockView$setPrimaryColor(SBDockView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$RegularDockHooks$SBDockView$primaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }
__attribute__((used)) static UIColor * _logos_method$RegularDockHooks$SBDockView$secondaryColor(SBDockView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$RegularDockHooks$SBDockView$secondaryColor); }; __attribute__((used)) static void _logos_method$RegularDockHooks$SBDockView$setSecondaryColor(SBDockView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$RegularDockHooks$SBDockView$secondaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }

  static SBDockView* _logos_method$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$(_LOGOS_SELF_TYPE_INIT SBDockView* __unused self, SEL __unused _cmd, id arg1, BOOL arg2) _LOGOS_RETURN_RETAINED {
    if(useColorFlow) {
      [[_logos_static_class_lookup$CFWSBMediaController() sharedInstance] addColorDelegate:self];
    }
    return dockView = _logos_orig$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$(self, _cmd, arg1, arg2);
  }

  static void _logos_method$RegularDockHooks$SBDockView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$RegularDockHooks$SBDockView$layoutSubviews(self, _cmd);

      
    SBWallpaperEffectView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.blurView.hidden = YES;
    backgroundView.alpha = dockAlpha;

      
    if(!gradientLayer) {
      gradientLayer = [CAGradientLayer layer];
    }

      
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } if(gradientDirection == horizontal) {
      gradientLayer.startPoint = CGPointMake(0.0, 0.5);
      gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }

    if(self.primaryColor == nil || self.secondaryColor == nil) {
      colorOne = LCPParseColorString(colorOneString, @"#3A7BD5");
      colorTwo = LCPParseColorString(colorTwoString, @"#3A6073");
    } else {
      colorOne = self.primaryColor;
      colorTwo = self.secondaryColor;
    }

    gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    gradientLayer.frame = backgroundView.bounds;
    [backgroundView.layer insertSublayer:gradientLayer atIndex:6];
  }


  static void _logos_method$RegularDockHooks$SBDockView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song, UIImage * artwork, CFWColorInfo * colorInfo) {
    self.primaryColor = colorInfo.primaryColor;
    self.secondaryColor = colorInfo.secondaryColor;
    [self layoutSubviews];
  }


  static void _logos_method$RegularDockHooks$SBDockView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBDockView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song) {
    self.primaryColor = nil;
    self.secondaryColor = nil;
    [self layoutSubviews];
  }



  


static SBFloatingDockPlatterView* (*_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$)(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView*, SEL, double, double) _LOGOS_RETURN_RETAINED; static SBFloatingDockPlatterView* _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView*, SEL, double, double) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST, SEL); static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST, SEL); static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST, SEL, MPModelSong *, UIImage *, CFWColorInfo *); static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST, SEL, MPModelSong *); 

__attribute__((used)) static UIColor * _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$primaryColor(SBFloatingDockPlatterView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$primaryColor); }; __attribute__((used)) static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$setPrimaryColor(SBFloatingDockPlatterView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$primaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }
__attribute__((used)) static UIColor * _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$secondaryColor(SBFloatingDockPlatterView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$secondaryColor); }; __attribute__((used)) static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$setSecondaryColor(SBFloatingDockPlatterView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$secondaryColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }

  static SBFloatingDockPlatterView* _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$(_LOGOS_SELF_TYPE_INIT SBFloatingDockPlatterView* __unused self, SEL __unused _cmd, double arg1, double arg2) _LOGOS_RETURN_RETAINED {
    if(useColorFlow) {
      [[_logos_static_class_lookup$CFWSBMediaController() sharedInstance] addColorDelegate:self];
    }
    return floatingDockView = _logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$(self, _cmd, arg1, arg2);
  }

  static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews(self, _cmd);

      
    _UIBackdropView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.backdropEffectView.hidden = YES;
    backgroundView.alpha = dockAlpha;

      
    if(!gradientLayer) {
      gradientLayer = [CAGradientLayer layer];
    }

      
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } if(gradientDirection == horizontal) {
      gradientLayer.startPoint = CGPointMake(0.0, 0.5);
      gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }

    if(self.primaryColor == nil || self.secondaryColor == nil) {
      colorOne = LCPParseColorString(colorOneString, @"#3A7BD5");
      colorTwo = LCPParseColorString(colorTwoString, @"#3A6073");
    } else {
      colorOne = self.primaryColor;
      colorTwo = self.secondaryColor;
    }

    gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    gradientLayer.frame = backgroundView.bounds;
    gradientLayer.cornerRadius = [self maximumContinuousCornerRadius];
    [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
  }


  static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songAnalysisComplete$artwork$colorInfo$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song, UIImage * artwork, CFWColorInfo * colorInfo) {
    self.primaryColor = colorInfo.primaryColor;
    self.secondaryColor = colorInfo.backgroundColor;
    [self layoutSubviews];
  }


  static void _logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songHadNoArtwork$(_LOGOS_SELF_TYPE_NORMAL SBFloatingDockPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MPModelSong * song) {
    self.primaryColor = nil;
    self.secondaryColor = nil;
    [self layoutSubviews];
  }



static void updateDock() {
  if(usingFloatingDock) {
    [floatingDockView layoutSubviews];
  } else {
    [dockView layoutSubviews];
  }
}

static void colorsFromWallpaper() {
  UIImage *homeWallpaper;
  if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"]) {
    NSData *homeData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"];
    CFArrayRef homeArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)homeData, NULL, 1, NULL);
    NSArray *homeArray = (__bridge NSArray*)homeArrayRef;
    homeWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(homeArray[0])];
    CFRelease(homeArrayRef);
  } else {
    NSData *homeData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
    CFArrayRef homeArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)homeData, NULL, 1, NULL);
    NSArray *homeArray = (__bridge NSArray*)homeArrayRef;
    homeWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(homeArray[0])];
    CFRelease(homeArrayRef);
  }

  HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.navaleprefs"];
  [homeWallpaper getPaletteImageColorWithMode:VIBRANT_PALETTE | LIGHT_VIBRANT_PALETTE | DARK_VIBRANT_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"colorOneString"];
  }];
  [homeWallpaper getPaletteImageColorWithMode:MUTED_PALETTE | LIGHT_MUTED_PALETTE | DARK_MUTED_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"colorTwoString"];
  }];

}

static __attribute__((constructor)) void _logosLocalCtor_f01702de(int __unused argc, char __unused **argv, char __unused **envp) {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)colorsFromWallpaper, CFSTR("com.lacertosusrepo.navaleprefs-colorsFromWallpaper"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.navaleprefs"];
  [preferences registerBool:&usingFloatingDock default:NO forKey:@"usingFloatingDock"];
  [preferences registerBool:&useColorFlow default:NO forKey:@"useColorFlow"];
  [preferences registerInteger:&gradientDirection default:horizontal forKey:@"gradientDirection"];
  [preferences registerFloat:&dockAlpha default:1.0 forKey:@"dockAlpha"];

  [preferences registerObject:&colorOneString default:@"#3A7BD5" forKey:@"colorOneString"];
  [preferences registerObject:&colorTwoString default:@"#3A6073" forKey:@"colorTwoString"];

  [preferences registerPreferenceChangeBlock:^{
    updateDock();
  }];

  if(usingFloatingDock) {
    {Class _logos_class$FloatingDockHooks$SBFloatingDockPlatterView = objc_getClass("SBFloatingDockPlatterView"); MSHookMessageEx(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(initWithReferenceHeight:maximumContinuousCornerRadius:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$, (IMP*)&_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$initWithReferenceHeight$maximumContinuousCornerRadius$);MSHookMessageEx(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(layoutSubviews), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews, (IMP*)&_logos_orig$FloatingDockHooks$SBFloatingDockPlatterView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); memcpy(_typeEncoding + i, @encode(CFWColorInfo *), strlen(@encode(CFWColorInfo *))); i += strlen(@encode(CFWColorInfo *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(songAnalysisComplete:artwork:colorInfo:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songAnalysisComplete$artwork$colorInfo$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(songHadNoArtwork:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$songHadNoArtwork$, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(primaryColor), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$primaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(setPrimaryColor:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$setPrimaryColor, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(secondaryColor), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$secondaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$FloatingDockHooks$SBFloatingDockPlatterView, @selector(setSecondaryColor:), (IMP)&_logos_method$FloatingDockHooks$SBFloatingDockPlatterView$setSecondaryColor, _typeEncoding); } }
  } else {
    {Class _logos_class$RegularDockHooks$SBDockView = objc_getClass("SBDockView"); MSHookMessageEx(_logos_class$RegularDockHooks$SBDockView, @selector(initWithDockListView:forSnapshot:), (IMP)&_logos_method$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$, (IMP*)&_logos_orig$RegularDockHooks$SBDockView$initWithDockListView$forSnapshot$);MSHookMessageEx(_logos_class$RegularDockHooks$SBDockView, @selector(layoutSubviews), (IMP)&_logos_method$RegularDockHooks$SBDockView$layoutSubviews, (IMP*)&_logos_orig$RegularDockHooks$SBDockView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); memcpy(_typeEncoding + i, @encode(CFWColorInfo *), strlen(@encode(CFWColorInfo *))); i += strlen(@encode(CFWColorInfo *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(songAnalysisComplete:artwork:colorInfo:), (IMP)&_logos_method$RegularDockHooks$SBDockView$songAnalysisComplete$artwork$colorInfo$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(MPModelSong *), strlen(@encode(MPModelSong *))); i += strlen(@encode(MPModelSong *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(songHadNoArtwork:), (IMP)&_logos_method$RegularDockHooks$SBDockView$songHadNoArtwork$, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(primaryColor), (IMP)&_logos_method$RegularDockHooks$SBDockView$primaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(setPrimaryColor:), (IMP)&_logos_method$RegularDockHooks$SBDockView$setPrimaryColor, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(secondaryColor), (IMP)&_logos_method$RegularDockHooks$SBDockView$secondaryColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$RegularDockHooks$SBDockView, @selector(setSecondaryColor:), (IMP)&_logos_method$RegularDockHooks$SBDockView$setSecondaryColor, _typeEncoding); } }
  }
}
