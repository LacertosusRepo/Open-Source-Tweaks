/*
 * Tweak.xm
 * Navale
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 4/30/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#define LD_DEBUG NO
#import "NavaleClasses.h"
#import "ColorsFromImage.h"
#import "ColorFlowAPI.h"
#import "libcolorpicker.h"
extern "C" CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

  //Vars
  CAGradientLayer *gradientLayer;
  SBFloatingDockPlatterView *floatingDockView;
  SBDockView *dockView;
  UIColor *colorOne;
  UIColor *colorTwo;

  //Prefs
  static BOOL usingFloatingDock;
  static BOOL useColorFlow;
  static int gradientDirection;
  static float dockAlpha;

  /*
   * Regular Dock
   */
%group RegularDockHooks
%hook SBDockView
%property (nonatomic, copy) UIColor *primaryColor;
%property (nonatomic, copy) UIColor *secondaryColor;

  -(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
    if(useColorFlow) {
      [[%c(CFWSBMediaController) sharedInstance] addColorDelegate:self];
    }
    return dockView = %orig;
  }

  -(void)layoutSubviews {
    %orig;

      //Get background view and set alpha
    SBWallpaperEffectView *backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
    backgroundView.blurView.hidden = YES;
    backgroundView.alpha = dockAlpha;

      //Create gradient layer
    if(!gradientLayer) {
      gradientLayer = [CAGradientLayer layer];
    }

      //Set gradient layer orientation
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } if(gradientDirection == horizontal) {
      gradientLayer.startPoint = CGPointMake(0.0, 0.5);
      gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }

    if(self.primaryColor == nil || self.secondaryColor == nil) {
      NSMutableDictionary *colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      colorOne = LCPParseColorString([colorData objectForKey:@"colorOne"], @"000000");
      colorTwo = LCPParseColorString([colorData objectForKey:@"colorTwo"], @"000000");
    } else {
      colorOne = self.primaryColor;
      colorTwo = self.secondaryColor;
    }

    gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    gradientLayer.frame = backgroundView.bounds;
    [backgroundView.layer insertSublayer:gradientLayer atIndex:6];
  }

%new
  -(void)songAnalysisComplete:(MPModelSong *)song artwork:(UIImage *)artwork colorInfo:(CFWColorInfo *)colorInfo {
    self.primaryColor = colorInfo.primaryColor;
    self.secondaryColor = colorInfo.secondaryColor;
    [self layoutSubviews];
  }

%new
  -(void)songHadNoArtwork:(MPModelSong *)song {
    self.primaryColor = nil;
    self.secondaryColor = nil;
    [self layoutSubviews];
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

  -(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
    if(useColorFlow) {
      [[%c(CFWSBMediaController) sharedInstance] addColorDelegate:self];
    }
    return floatingDockView = %orig;
  }

  -(void)layoutSubviews {
    %orig;
    NSLog(@"Dock Updated");

      //Get background view and set alpha
    _UIBackdropView *backgroundView = MSHookIvar<_UIBackdropView *>(self, "_backgroundView");
    backgroundView.backdropEffectView.hidden = YES;
    backgroundView.alpha = dockAlpha;

      //Create gradient layer
    if(!gradientLayer) {
      gradientLayer = [CAGradientLayer layer];
    }

      //Set gradient layer orientation
    if(gradientDirection == verticle) {
      gradientLayer.startPoint = CGPointMake(0.5, 0.0);
      gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    } if(gradientDirection == horizontal) {
      gradientLayer.startPoint = CGPointMake(0.0, 0.5);
      gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }

    if(self.primaryColor == nil || self.secondaryColor == nil) {
      NSMutableDictionary *colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      colorOne = LCPParseColorString([colorData objectForKey:@"colorOne"], @"000000");
      colorTwo = LCPParseColorString([colorData objectForKey:@"colorTwo"], @"000000");
    } else {
      colorOne = self.primaryColor;
      colorTwo = self.secondaryColor;
    }

    gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    gradientLayer.frame = backgroundView.bounds;
    gradientLayer.cornerRadius = [self maximumContinuousCornerRadius];
    [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
  }

%new
  -(void)songAnalysisComplete:(MPModelSong *)song artwork:(UIImage *)artwork colorInfo:(CFWColorInfo *)colorInfo {
    NSLog(@"Color Analysis Finished - %@", colorInfo);
    self.primaryColor = colorInfo.primaryColor;
    self.secondaryColor = colorInfo.secondaryColor;
    [self layoutSubviews];
  }

%new
  -(void)songHadNoArtwork:(MPModelSong *)song {
    NSLog(@"Color Analysis");
    self.primaryColor = nil;
    self.secondaryColor = nil;
    [self layoutSubviews];
  }
%end
%end

static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
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
    NSLog(@"Navale || Home wallpaper not found");
    return;
  }

  NSDictionary *colors = [[%c(ColorsFromImage) sharedInstance] colorsFromImage:homeWallpaper fromEdge:3];
  NSString *primaryColor = [UIColor hexFromColor:colors[@"primary"]];
  NSString *secondaryColor = [UIColor hexFromColor:colors[@"secondary"]];
  //NSLog(@"colors - %@ || primaryColor - %@ || secondaryColor - %@", colors, primaryColor, secondaryColor);

  NSMutableDictionary *colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
  [colorData setObject:primaryColor forKey:@"colorOne"];
  [colorData setObject:secondaryColor forKey:@"colorTwo"];
  [colorData writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist" atomically:YES];

  updateDock();
}

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    usingFloatingDock = NO;
    useColorFlow = NO;
    gradientDirection = horizontal;
    dockAlpha = 1.0;
  } else {
    usingFloatingDock = [[preferences objectForKey:@"usingFloatingDock"] boolValue];
    useColorFlow = [[preferences objectForKey:@"useColorFlow"] boolValue];
    gradientDirection = [[preferences objectForKey:@"gradientDirection"] intValue];
    dockAlpha = [[preferences objectForKey:@"dockAlpha"] floatValue];
  }
}

static NSString *nsNotificationString = @"com.lacertosusrepo.navaleprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)colorsFromWallpaper, CFSTR("com.lacertosusrepo.navaleprefs-colorsFromWallpaper"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updateDock, CFSTR("com.lacertosusrepo.navaleprefs-updateDock"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.navaleprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  if(usingFloatingDock) {
    %init(FloatingDockHooks);
  } else {
    %init(RegularDockHooks);
  }
}
