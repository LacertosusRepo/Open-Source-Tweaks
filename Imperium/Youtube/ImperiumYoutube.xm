#import <MediaRemote/MediaRemote.h>
#import "Youtube.h"
#import "../ImperiumClasses.h"

  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;

  //--Vars--//
  NSMutableDictionary *preferences;
  BOOL killScroll = NO;

  //--Pref Vars--//
  static BOOL youtubeSwitch;
  static int feedbackOption;
  static float longPressTime;
  static int doubleTap;
  static int leftSwipe;
  static int rightSwipe;
  static int upSwipe;
  static int downSwipe;
  static int longPress;

       /////////////////
      //   Youtube   //
     /////////////////

%hook YTPlaybackButton
  -(id)initWithFrame:(CGRect)arg1 {
    if(youtubeSwitch) {
      return nil;
      self.hidden = YES;
    } else {
      return %orig;
    }
  }
%end
/*%hook YTButton
  -(void)layoutSubviews {
    %orig;
    if(youtubeSwitch) {
      self.hidden = YES;
    }
  }
%end*/

       /////////////////
      // Preferences //
     /////////////////

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
  } else {
    youtubeSwitch = [[preferences objectForKey:@"youtubeSwitch"] boolValue];
    feedbackOption = [[preferences objectForKey:@"feedbackOption"] intValue];
    longPressTime = [[preferences objectForKey:@"longPressTime"] floatValue];
    doubleTap = [[preferences objectForKey:@"doubleTap"] intValue];
    leftSwipe = [[preferences objectForKey:@"leftSwipe"] intValue];
    rightSwipe = [[preferences objectForKey:@"rightSwipe"] intValue];
    upSwipe = [[preferences objectForKey:@"upSwipe"] intValue];
    downSwipe = [[preferences objectForKey:@"downSwipe"] intValue];
    longPress = [[preferences objectForKey:@"longPress"] intValue];
  }
  [preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.imperiumprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%ctor {
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  loadPrefs();
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  [pool release];
}
