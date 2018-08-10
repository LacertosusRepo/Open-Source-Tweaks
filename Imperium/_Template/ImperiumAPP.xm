#import <MediaRemote/MediaRemote.h>
#import "APP.h"
#import "../ImperiumClasses.h"

  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;

  //--Vars--//
  NSMutableDictionary *preferences;

  //--Pref Vars--//
  static BOOL APPSwitch;
  static int feedbackOption;
  static float longPressTime;
  static int doubleTap;
  static int leftSwipe;
  static int rightSwipe;
  static int upSwipe;
  static int downSwipe;
  static int longPress;

       /////////////////
      //     APP     //
     /////////////////

       /////////////////
      // Preferences //
     /////////////////

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
  } else {
    APPSwitch = [[preferences objectForKey:@"APPSwitch"] boolValue];
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
