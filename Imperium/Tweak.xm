#import <MediaRemote/MediaRemote.h>
#import<SpringBoard/SpringBoard.h>
#import "ImperiumClasses.h"

  //--Vars--//
  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;
  NSMutableDictionary *preferences;
  BOOL killScroll = NO;

  //--Pref Vars--//
  static BOOL hideTimeLine;
  static BOOL hideVolumeSlider;
  static BOOL hideSongTime;

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

    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)] autorelease];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];

    panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)] autorelease];
    [self addGestureRecognizer:panGesture];

    longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
    longPressGesture.minimumPressDuration = longPressTime;
    longPressGesture.allowableMovement = 0;
    [self addGestureRecognizer:longPressGesture];

    return %orig;
  }

%new    //Need a %new for each method, thanks /u/DGh0st

  -(void)handleDoubleTap {
    [ImperiumGestureController callImpact:feedbackOption];
    [ImperiumGestureController selectGesture:doubleTap];
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

%new    //Method for SpinXI
  -(float)longPressTime {
    return longPressTime;
  }
%end
    //Hides time line & remaining/elapsed song time
%hook MediaControlsTimeControl
  -(void)layoutSubviews {
    %orig;
    self.hidden = hideTimeLine;
    self.elapsedTimeLabel.hidden = hideSongTime;
    self.remainingTimeLabel.hidden = hideSongTime;
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

static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void loadPrefs() {
  static NSString *file = @"/User/Library/Preferences/com.lacertosusrepo.imperiumprefs.plist";
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
      hideTimeLine = NO;
      hideVolumeSlider = NO;
      hideSongTime = NO;

      feedbackOption = lightForce;
      longPressTime = 0.75;
      doubleTap = playPause;
      leftSwipe = skipBack;
      rightSwipe = skipForward;
      upSwipe = doNothing;
      downSwipe = doNothing;
      longPress = nowPlaying;
  } else {
      //Hide items
    hideTimeLine = [[preferences objectForKey:@"hideTimeLine"] boolValue];
    hideVolumeSlider = [[preferences objectForKey:@"hideVolumeSlider"] boolValue];
    hideSongTime = [[preferences objectForKey:@"hideSongTime"] boolValue];

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
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)killApplications, CFSTR("com.lacertosusrepo.imperiumprefs-killapplications"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.imperiumprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  [pool release];
}
