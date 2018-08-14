//--Headers--//
#import "libcolorpicker.h"
#import "VitrumHeaders.h"

  //--Vars--//
  NSMutableDictionary * preferences;
  _UIBackdropView * backdropView;
  UIImageView * customImage;

  //--Pref Vars--//
  static BOOL hideCheveron;
  static BOOL useCustomImage;
  static BOOL backgroundColorSwitch;
  static float backgroundAlpha;
  static float moduleBackgroundAlpha;
  //static float backgroundBrightness;
  //static float backgroundSaturation;
  static float controlCenterColorAlpha;
  static NSString * controlCenterColor;

    //--SpringBoard--//
    //CC Background hooks
%hook CCUIModularControlCenterOverlayViewController
  -(void)viewWillLayoutSubviews {
    %orig;

    if(useCustomImage) {
    	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist"];
      UIImage * customUIImage = [UIImage imageWithData:[preferences objectForKey:@"imageData"]];
      if(!customImage) {
        customImage = [[UIImageView alloc] initWithImage:customUIImage];
        customImage.frame = self.view.bounds;
        customImage.alpha = 0.0;
        customImage.contentMode = UIViewContentModeScaleAspectFill;
      }
      [self.view addSubview:customImage];
    }
    [self.view sendSubviewToBack:customImage];

    MTMaterialView * backgroundView = MSHookIvar<MTMaterialView *>(self, "_backgroundView");
    backdropView = [backgroundView _mtBackdropView];
    if(backgroundColorSwitch == YES) {
      UIColor * ccColor = LCPParseColorString(controlCenterColor, @"#95a5a6");
      backdropView.colorAddColor = ccColor;
      backdropView.colorAddColor = [backdropView.colorAddColor colorWithAlphaComponent:controlCenterColorAlpha];
    }
    backdropView.alpha = backgroundAlpha;
    //backdropView.brightness = backgroundBrightness;
    //[backdropView setSaturation:backgroundSaturation];
  }

  -(id)_beginPresentationAnimated:(BOOL)arg1 interactive:(BOOL)arg2 {
    if(useCustomImage) {
      [self performSelector:@selector(showWallpaper)];
    }
    return %orig;
  }

  -(id)_beginDismissalAnimated:(BOOL)arg1 interactive:(BOOL)arg2 {
    if(useCustomImage) {
      [self performSelector:@selector(hideWallpaper)];
    }
    return %orig;
  }

  -(void)cancelPresentationWithLocation:(CGPoint)arg1 translation:(CGPoint)arg2 velocity:(CGPoint)arg {
    if(useCustomImage) {
      [self performSelector:@selector(hideWallpaper)];
    }
    %orig;
  }

%new
  -(void)showWallpaper {
    [UIView animateWithDuration:0.3 animations:^{
      customImage.alpha = 1.0;
    } completion:nil];
  }
%new
  -(void)hideWallpaper {
    [UIView animateWithDuration:0.3 animations:^{
      customImage.alpha = 0.0;
    } completion:nil];
  }
%end

    //Hide backgrounds of modules
%hook MediaControlsMaterialView
  -(void)layoutSubviews {
    %orig;
    self.alpha = moduleBackgroundAlpha;
  }
%end
%hook CCUIContentModuleContentContainerView
  -(void)layoutSubviews {
    %orig;
    MTMaterialView * moduleMaterialView = MSHookIvar<MTMaterialView *>(self, "_moduleMaterialView");
    moduleMaterialView.alpha = moduleBackgroundAlpha;
  }
%end

    //Hides cheveron
%hook CCUIHeaderPocketView
  -(void)layoutSubviews {
    %orig;
    self.hidden = hideCheveron;
  }
%end

    //--Preferences--//
static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void loadPrefs() {
	static NSString * file = @"/User/Library/Preferences/com.lacertosusrepo.vitrumprefs.plist";
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
	if(!preferences) {
		preferences = [[NSMutableDictionary alloc] init];
    hideCheveron = YES;
    useCustomImage = NO;
    backgroundColorSwitch = NO;
    backgroundAlpha = 1.0;
    moduleBackgroundAlpha = 0.0;
    //backgroundBrightness = 0;
    //backgroundSaturation = 1.9;
    controlCenterColorAlpha = 0.4;
	} else {
		hideCheveron = [[preferences objectForKey:@"hideCheveron"] boolValue];
    useCustomImage = [[preferences objectForKey:@"useCustomImage"] boolValue];
		backgroundColorSwitch = [[preferences objectForKey:@"backgroundColorSwitch"] boolValue];
    backgroundAlpha = [[preferences objectForKey:@"backgroundAlpha"] floatValue];
    moduleBackgroundAlpha = [[preferences objectForKey:@"moduleBackgroundAlpha"] floatValue];
    //backgroundBrightness = [[preferences objectForKey:@"backgroundBrightness"] floatValue];
		//backgroundSaturation = [[preferences objectForKey:@"backgroundSaturation"] floatValue];
    controlCenterColorAlpha = [[preferences objectForKey:@"controlCenterColorAlpha"] floatValue];
		controlCenterColor = [preferences objectForKey:@"controlCenterColor"];
	}
	[preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.vitrumprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.vitrumprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  [pool release];
}
