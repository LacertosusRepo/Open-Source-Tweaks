/*
 * Tweak.x
 * Navale
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 4/30/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "NavaleClasses.h"
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "ColorFlowAPI.h"
#import "libcolorpicker.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

  //Vars
  CAGradientLayer *gradientLayer;
  SBFloatingDockPlatterView *floatingDockView;
  SBDockView *stockDockView;
  UIColor *colorOne;
  UIColor *colorTwo;
  UIColor *borderColor;

  //Prefs
  static BOOL usingFloatingDock;
  static NSInteger gradientDirection;
  static CGFloat dockAlpha;
  static NSString *colorOneString;
  static NSString *colorTwoString;
  static BOOL overrideCornerRadius;
  static NSInteger cornerRadius;
  static NSString *borderColorString;
  static NSInteger borderWidth;

  /*
   * Stock iOS Dock
   */
%group StockDockHooks
%hook SBDockView
%property (nonatomic, copy) UIColor *primaryColor;
%property (nonatomic, copy) UIColor *secondaryColor;

  -(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
    return stockDockView = %orig;
  }

  -(void)didMoveToWindow {
    %orig;

    if(!gradientLayer) {
      UIView *backgroundView = [self valueForKey:@"backgroundView"];

      gradientLayer = [CAGradientLayer layer];
      gradientLayer.frame = backgroundView.bounds;
      [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
    }

    [self updateGradient];
  }

  -(void)layoutSubviews {
    %orig;

    UIView *backgroundView = [self valueForKey:@"backgroundView"];
    if([backgroundView respondsToSelector:@selector(_materialLayer)]) {
      ((MTMaterialView *)backgroundView).weighting = 0;
      gradientLayer.cornerRadius = (overrideCornerRadius) ? cornerRadius : ((MTMaterialView *)backgroundView).materialLayer.cornerRadius;
    }
    if([backgroundView respondsToSelector:@selector(blurView)]) {
      ((SBWallpaperEffectView *)backgroundView).blurView.hidden = YES;
    }

    gradientLayer.frame = backgroundView.bounds;
  }

%new
  -(void)updateGradient {
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } else {
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
    gradientLayer.opacity = dockAlpha;

    borderColor = LCPParseColorString(borderColorString, @"#FFFFFF");
    gradientLayer.borderColor = borderColor.CGColor;
    gradientLayer.borderWidth = borderWidth;
  }
%end
%end

  /*
   * Floating Dock
   */
%group FloatingDockHooks
%hook SBFloatingDockPlatterView
%property (nonatomic, copy) UIColor *primaryColor;
%property (nonatomic, copy) UIColor *secondaryColor;
    //iOS 12
  -(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
    return floatingDockView = %orig;
  }

    //iOS 13
  -(id)initWithFrame:(CGRect)arg1 {
    return floatingDockView = %orig;
  }

  -(void)layoutSubviews {
    %orig;

    _UIBackdropView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.alpha = dockAlpha;
    if(![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
      backgroundView.backdropEffectView.hidden = YES;
    }

    if(!gradientLayer) {
      gradientLayer = [CAGradientLayer layer];
      [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
      [self updateGradient];
    }

    gradientLayer.frame = backgroundView.bounds;
  }

%new
  -(void)updateGradient {
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } else {
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
    gradientLayer.cornerRadius = (overrideCornerRadius) ? cornerRadius : [self maximumContinuousCornerRadius];

    borderColor = LCPParseColorString(borderColorString, @"#FFFFFF");
    gradientLayer.borderColor = borderColor.CGColor;
    gradientLayer.borderWidth = borderWidth;
  }
%end
%end

static void updateDock() {
  if(usingFloatingDock) {
    [floatingDockView updateGradient];
  } else {
    [stockDockView updateGradient];
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

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)colorsFromWallpaper, CFSTR("com.lacertosusrepo.navaleprefs-colorsFromWallpaper"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.navaleprefs"];
  [preferences registerBool:&usingFloatingDock default:NO forKey:@"usingFloatingDock"];
  [preferences registerInteger:&gradientDirection default:horizontal forKey:@"gradientDirection"];
  [preferences registerFloat:&dockAlpha default:1.0 forKey:@"dockAlpha"];

  [preferences registerObject:&colorOneString default:@"#3A7BD5" forKey:@"colorOneString"];
  [preferences registerObject:&colorTwoString default:@"#3A6073" forKey:@"colorTwoString"];

  [preferences registerBool:&overrideCornerRadius default:NO forKey:@"overrideCornerRadius"];
  [preferences registerInteger:&cornerRadius default:15 forKey:@"cornerRadius"];

  [preferences registerObject:&borderColorString default:@"#FFFFFF" forKey:@"borderColorString"];
  [preferences registerInteger:&borderWidth default:0 forKey:@"borderWidth"];

  [preferences registerPreferenceChangeBlock:^{
    updateDock();
  }];

  if(usingFloatingDock) {
    %init(FloatingDockHooks);
  } else {
    %init(StockDockHooks);
  }
}
