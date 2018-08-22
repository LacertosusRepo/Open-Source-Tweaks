  //Headers
#import "NavaleClasses.h"
#import "libcolorpicker.h"

  //Vars
  CAGradientLayer * gradientLayer;

  //Pref Vars
  static BOOL usingFloatingDock;
  static int gradientDirection;
  static float dockAlpha;
  //static float gradientPosition;

%hook SBDockView
  -(void)layoutSubviews {
    %orig;
    if(!usingFloatingDock) {
      SBWallpaperEffectView * backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
      backgroundView.blurView.hidden = YES;
      backgroundView.alpha = dockAlpha;

      NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      UIColor * colorOne = LCPParseColorString([preferences objectForKey:@"colorOne"], @"#2c3e50");
      UIColor * colorTwo = LCPParseColorString([preferences objectForKey:@"colorTwo"], @"#2980b9");

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
      gradientLayer.frame = backgroundView.bounds;
      gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
      [backgroundView.layer insertSublayer:gradientLayer atIndex:6];
    }
  }
%end

%hook SBFloatingDockPlatterView
  -(void)layoutSubviews {
    %orig;
    if(usingFloatingDock) {
      _UIBackdropView * backgroundView = MSHookIvar<_UIBackdropView *>(self, "_backgroundView");
      backgroundView.backdropEffectView.hidden = YES;
      backgroundView.alpha = dockAlpha;

      NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      UIColor * colorOne = LCPParseColorString([preferences objectForKey:@"colorOne"], @"#2c3e50");
      UIColor * colorTwo = LCPParseColorString([preferences objectForKey:@"colorTwo"], @"#2980b9");

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
      gradientLayer.frame = backgroundView.bounds;
      gradientLayer.cornerRadius = [backgroundView _cornerRadius];
      gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
      [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
    }
  }
%end

static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void loadPrefs() {
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist"];
	if(!preferences) {
		preferences = [[NSMutableDictionary alloc] init];
    usingFloatingDock = NO;
    gradientDirection = verticle;
    dockAlpha = 1.0;
    //gradientPosition = 0.5;
	} else if(![[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"]) {
    NSMutableDictionary * otherData = [[NSMutableDictionary alloc] init];
    [otherData writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist" atomically:YES];
  } else {
		usingFloatingDock = [[preferences objectForKey:@"usingFloatingDock"] boolValue];
    gradientDirection = [[preferences objectForKey:@"gradientDirection"] intValue];
    dockAlpha = [[preferences objectForKey:@"dockAlpha"] floatValue];
    //gradientPosition = [[preferences objectForKey:@"gradientPosition"] floatValue];
	}
	[preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.navaleprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.navaleprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  [pool release];
}
