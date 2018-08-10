#import <MediaRemote/MediaRemote.h>
#import "Spotify.h"
#import "../ImperiumClasses.h"

  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;

  //--Vars--//
  NSMutableDictionary *preferences;
  static BOOL firstPlay;
  SPTStatefulPlayer *playerControl;

  //--Pref Vars--//
  static BOOL spotifySwitch;
  static int feedbackOption;
  static float longPressTime;
  static int doubleTap;
  static int leftSwipe;
  static int rightSwipe;
  static int upSwipe;
  static int downSwipe;
  static int longPress;

       /////////////////
      //   Spotify   //
     /////////////////

%hook SPTStatefulPlayer
  -(id)initWithPlayer:(id)arg1 {
    return playerControl = %orig;
  }
%end

     //Hide music controls
%hook SPTNowPlayingBaseHeadUnitView
  -(UIButton *)playPauseButton {
    %orig.hidden = spotifySwitch;
    %orig.userInteractionEnabled = !spotifySwitch;
    return %orig;
  }
  -(UIButton *)skipToNextButton {
    %orig.hidden = spotifySwitch;
    %orig.userInteractionEnabled = !spotifySwitch;
    return %orig;
  }
  -(UIButton *)skipToPreviousButton {
    %orig.hidden = spotifySwitch;
    %orig.userInteractionEnabled = !spotifySwitch;
    return %orig;
  }

     //Adds gestures to view
  -(id)initWithTheme:(id)arg1 {
    if(spotifySwitch) {
      firstPlay = YES;

      tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)] autorelease];
      tapGesture.numberOfTapsRequired = 2;
      [self addGestureRecognizer:tapGesture];

      panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)] autorelease];
      [self addGestureRecognizer:panGesture];

      longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
      longPressGesture.minimumPressDuration = longPressTime;
      longPressGesture.allowableMovement = 0;
      [self addGestureRecognizer:longPressGesture];

    }
    return %orig;
  }

%new    //Need a %new for each method, thanks /u/DGh0st

  -(void)handleDoubleTap {
    [ImperiumGestureController callImpact:feedbackOption];
    if(firstPlay) {   //Allows the play action to start spotify and not the apple music app
      [playerControl setPaused:NO];
      firstPlay = NO;
    } else {
      [ImperiumGestureController selectGesture:doubleTap];
    }
  }

%new

  -(void)handleSwipe:(UIPanGestureRecognizer *)sender {
    CGPoint distance = [sender translationInView:self];
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

       /////////////////
      // Preferences //
     /////////////////

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
  } else {
    spotifySwitch = [[preferences objectForKey:@"spotifySwitch"] boolValue];
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
