#import <MediaRemote/MediaRemote.h>
#import "AppleMusic.h"
#import "../ImperiumClasses.h"

  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;

  //--Vars--//
  NSMutableDictionary *preferences;
  BOOL killScroll = NO;

  //--Pref Vars--//
  static BOOL appleMusicSwitch;
  static int feedbackOption;
  static float longPressTime;
  static int doubleTap;
  static int leftSwipe;
  static int rightSwipe;
  static int upSwipe;
  static int downSwipe;
  static int longPress;

       /////////////////
      // Apple Music //
     /////////////////

     //Hides music controls
%hook AppleMusicTransportButtons
  -(void)layoutSubviews {
    ((AppleMusicTransportButtons*)self).hidden = appleMusicSwitch;
    %orig;
  }
%end
    //Adds gestures
%hook AppleMusicTransportControls
  -(id)initWithFrame:(id)arg1 {

    if(appleMusicSwitch == YES) {

      tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)] autorelease];
      tapGesture.numberOfTapsRequired = 2;
      [((AppleMusicTransportControls*)self) addGestureRecognizer:tapGesture];

      panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)] autorelease];
      [((AppleMusicTransportControls*)self) addGestureRecognizer:panGesture];

      longPressGesture= [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
      longPressGesture.minimumPressDuration = longPressTime;
      longPressGesture.allowableMovement = 0;
      [((AppleMusicTransportControls*)self) addGestureRecognizer:longPressGesture];
    }
    return %orig;
  }

%new

  -(void)handleDoubleTap {
    [ImperiumGestureController callImpact:feedbackOption];
    [ImperiumGestureController selectGesture:doubleTap];
  }

%new

  -(void)handleSwipe:(UIPanGestureRecognizer *)sender {
    CGPoint distance = [sender translationInView:((AppleMusicTransportControls*)self)];
    if(sender.state == UIGestureRecognizerStateEnded) {
      [ImperiumGestureController callImpact:feedbackOption];
        //Left swipe
        if(distance.x < -70 && distance.y > -50 && distance.y < 50) {
          [ImperiumGestureController selectGesture:leftSwipe];
        //Right swipe
        } else if(distance.x > -70 && distance.y > -50 && distance.y < 50) {
          [ImperiumGestureController selectGesture:rightSwipe];
        //Up swipe
        } else if(distance.y < 0) {
          [ImperiumGestureController selectGesture:upSwipe];
        //Down swipe
        } else if(distance.y > 0) {
          [ImperiumGestureController selectGesture:downSwipe];
        }
      }
    }

%new

  -(void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded) {
      [ImperiumGestureController callImpact:feedbackOption];
      [ImperiumGestureController selectGesture:longPress];
    }
  }

%end

    //Acapella-style now playing info, not done (obvi)
/*%hook MusicNowPlayingControlsViewController
  -(void)viewDidLoad {
    %orig;
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
    feedbackOption = [[preferences objectForKey:@"feedbackOption"] intValue];
    appleMusicSwitch = [[preferences objectForKey:@"appleMusicSwitch"] boolValue];
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

  %init(_ungrouped, AppleMusicTransportButtons = NSClassFromString(@"Music.NowPlayingTransportButton"),
    AppleMusicTransportControls = NSClassFromString(@"Music.NowPlayingTransportControlStackView"));
}
