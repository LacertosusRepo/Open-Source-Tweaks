#import <MediaRemote/MediaRemote.h>
#import<SpringBoard/SpringBoard.h>
#import "ImperiumClasses.h"

  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;

  //--Vars--//
  NSMutableDictionary *preferences;
  BOOL killScroll = NO;

  //--Pref Vars--//
  static BOOL hideTimeLine;
  static BOOL hideVolumeSlider;
  static int feedbackOption;
  static float longPressTime;
  static int doubleTap;
  static int leftSwipe;
  static int rightSwipe;
  static int upSwipe;
  static int downSwipe;
  static int longPress;

       /////////////////
      // SpringBoard //
     /////////////////

     //Hides music controls
%hook MediaControlsTransportButton
  -(void)layoutSubviews {
    self.hidden = YES;
    %orig;
  }
%end
    //Adds gestures to view
%hook MediaControlsTransportStackView
  -(id)initWithFrame:(CGRect)arg1 {

    killScroll = NO;

    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)] autorelease];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];

    panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)] autorelease];
    [self addGestureRecognizer:panGesture];

    longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
    longPressGesture.minimumPressDuration = longPressTime;
    longPressGesture.allowableMovement = 0;
    [self addGestureRecognizer:longPressGesture];

    if(panGesture.state == UIGestureRecognizerStateBegan) {
      killScroll = YES;
    }
    return %orig;
  }

%new    //Need a %new for each method, thanks /u/DGh0st

  -(void)handleDoubleTap {
    [ImperiumGestureController selectGesture:doubleTap withForceLevel:feedbackOption];
  }

%new

  -(void)handleSwipe:(UIPanGestureRecognizer *)sender {
    CGPoint distance = [sender translationInView:self];
    if(sender.state == UIGestureRecognizerStateEnded) {
        //Left swipe
      if(distance.x < -70 && distance.y > -50 && distance.y < 50) {
        [ImperiumGestureController selectGesture:leftSwipe withForceLevel:feedbackOption];
        //Right swipe
      } else if(distance.x > -70 && distance.y > -50 && distance.y < 50) {
        [ImperiumGestureController selectGesture:rightSwipe withForceLevel:feedbackOption];
        //Up swipe
      } else if(distance.y < 0) {
        [ImperiumGestureController selectGesture:upSwipe withForceLevel:feedbackOption];
        //Down swipe
      } else if(distance.y > 0) {
        [ImperiumGestureController selectGesture:downSwipe withForceLevel:feedbackOption];
      }
    }
  }

%new

  -(void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded) {
      [ImperiumGestureController selectGesture:longPress withForceLevel:feedbackOption];
    }
  }

%end
    //Stops scrolling, fixes pan gesture
%hook UIScrollView
  -(void)layoutSubviews {
    if(killScroll) {
      self.scrollEnabled = NO;
    }
    %orig;
  }
%end
    //Hides time line
%hook MediaControlsTimeControl
  -(void)layoutSubviews {
    self.hidden = hideTimeLine;
  }
%end
    //Hides volume slider
%hook MediaControlsVolumeContainerView
  -(UISlider *)volumeSlider{
    %orig.hidden = hideVolumeSlider;
    return %orig;
  }
%end


       /////////////////
      // Preferences //
     /////////////////

static void killApplications() {
  //Apple Music
  FBApplicationProcess * appleMusic = [[NSClassFromString(@"FBProcessManager") sharedInstance] createApplicationProcessForBundleID:@"com.apple.Music"];
  [appleMusic killForReason:1 andReport:NO withDescription:@"Imperium - Killed Apple Music" completion:nil];
  //Spotify
  FBApplicationProcess * spotifyMusic = [[NSClassFromString(@"FBProcessManager") sharedInstance] createApplicationProcessForBundleID:@"com.spotify.client"];
  [spotifyMusic killForReason:1 andReport:NO withDescription:@"Imperium - Killed Spotify" completion:nil];
}

static void loadPrefs() {
  static NSString *file = @"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist";
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
  } else {
      //Hide items
    hideTimeLine = [[preferences objectForKey:@"hideTimeLine"] boolValue];
    hideVolumeSlider = [[preferences objectForKey:@"hideVolumeSlider"] boolValue];

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
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)killApplications, CFSTR("com.lacertosusrepo.imperiumprefs-killapplications"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  loadPrefs();
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  [pool release];
}
