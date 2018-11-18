  //Headers
#import "NavaleClasses.h"
#import "NavaleController.h"
#import "libcolorpicker.h"

  //Vars
  CAGradientLayer * gradientLayer;
  SBFloatingDockPlatterView * floatingDockView;
  SBDockView * dockView;

  //Pref Vars
  static BOOL usingFloatingDock;
  static BOOL useColorFlow;
  static int gradientDirection;
  static float dockAlpha;
  //static float gradientPosition;

  //Default Dock Hook
%hook SBDockView
    //get dock instance and if using colorflow colors, start listening
  -(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
    if(useColorFlow) {
      [[NSClassFromString(@"NavaleController") alloc] init];
    }
    return dockView = %orig;
  }

  -(void)layoutSubviews {
    %orig;
      //check that user is not using floating dock
    if(!usingFloatingDock) {
        //hide dock blur and set alpha
      SBWallpaperEffectView * backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
      backgroundView.blurView.hidden = YES;
      backgroundView.alpha = dockAlpha;

        //get colors from other plist. regular preferences and color data are stored seperate due to libcolorpicker resetting colors often
      NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      UIColor * colorOne = LCPParseColorString([colorData objectForKey:@"colorOne"], @"#2c3e50");
      UIColor * colorTwo = LCPParseColorString([colorData objectForKey:@"colorTwo"], @"#2980b9");

        //if theres no gradient layer yet, make one;
      if(!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
      }

        //sets the gradient either verticle or horizontal
      if(gradientDirection == verticle) {
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
      } if(gradientDirection == horizontal) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
      }

        //if using colorflow and if neither of the colors are null, get the colors from controller
      if(useColorFlow && !([[NSClassFromString(@"NavaleController") sharedInstance] primaryColor] == nil || [[NSClassFromString(@"NavaleController") sharedInstance] secondaryColor] == nil)) {
        colorOne = [[NSClassFromString(@"NavaleController") sharedInstance] primaryColor];
        colorTwo = [[NSClassFromString(@"NavaleController") sharedInstance] secondaryColor];
      }

        //set gradient colors and frame
      gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
      gradientLayer.frame = backgroundView.bounds;
      [backgroundView.layer insertSublayer:gradientLayer atIndex:6];
    }
  }
%end

  //Floating Dock Hook
%hook SBFloatingDockPlatterView
    //get dock instance and if using colorflow colors, start listening
  -(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
    if(useColorFlow) {
      [[NSClassFromString(@"NavaleControllerNavaleController") alloc] init];
    }
    return floatingDockView = %orig;
  }

  -(void)layoutSubviews {
    %orig;
      //check that user is using floating dock
    if(usingFloatingDock) {
        //remove lightening effect and set dock alpha
      _UIBackdropView * backgroundView = MSHookIvar<_UIBackdropView *>(self, "_backgroundView");
      backgroundView.backdropEffectView.hidden = YES;
      backgroundView.alpha = dockAlpha;

        //get colors from other plist. regular preferences and color data are stored seperate due to libcolorpicker resetting colors often
      NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
      UIColor * colorOne = LCPParseColorString([colorData objectForKey:@"colorOne"], @"#2c3e50");
      UIColor * colorTwo = LCPParseColorString([colorData objectForKey:@"colorTwo"], @"#2980b9");

        //if theres no gradient layer yet, make one;
      if(!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
      }

        //sets the gradient either verticle or horizontal
      if(gradientDirection == verticle) {
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
      } if(gradientDirection == horizontal) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
      }

        //if using colorflow and if neither of the colors are null, get the colors from controller
      if(useColorFlow && !([[NSClassFromString(@"NavaleController") sharedInstance] primaryColor] == nil || [[NSClassFromString(@"NavaleController") sharedInstance] secondaryColor] == nil)) {
        colorOne = [[NSClassFromString(@"NavaleController") sharedInstance] primaryColor];
        colorTwo = [[NSClassFromString(@"NavaleController") sharedInstance] secondaryColor];
      }

        //set gradient colors and bounds, then get the corner radius
      gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
      gradientLayer.frame = backgroundView.bounds;
      gradientLayer.cornerRadius = [backgroundView _cornerRadius];
      [backgroundView.layer insertSublayer:gradientLayer atIndex:0];
    }
  }

%end

static void updateDock() {
    //call layoutSubviews to update the colors
  if(usingFloatingDock) {
    [floatingDockView layoutSubviews];
  } else {
    [dockView layoutSubviews];
  }
}

static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void loadPrefs() {
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist"];
    //if preference file doesnt exist, make one and set default values
  if(!preferences) {
		preferences = [[NSMutableDictionary alloc] init];
    usingFloatingDock = NO;
    useColorFlow = NO;
    gradientDirection = verticle;
    dockAlpha = 1.0;
    //gradientPosition = 0.5;
    [preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist" atomically:YES];
    //if the colors preference file doesnt exist, make one and set default values
	} if(![[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"]) {
    NSMutableDictionary * colorData = [[NSMutableDictionary alloc] init];
    [colorData setValue:@"#FFFFFF" forKey:@"colorOne"];
    [colorData setValue:@"#FFFFFF" forKey:@"colorTwo"];
    [colorData writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist" atomically:YES];
  } else {
		usingFloatingDock = [[preferences objectForKey:@"usingFloatingDock"] boolValue];
    useColorFlow = [[preferences objectForKey:@"useColorFlow"] boolValue];
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
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updateDock, CFSTR("com.lacertosusrepo.navaleprefs-updateDock"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.navaleprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  [pool release];
}
