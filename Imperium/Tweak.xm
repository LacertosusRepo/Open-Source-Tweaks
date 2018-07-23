#import <MediaRemote/MediaRemote.h>
#import "Headers.h"

  //--Vars--//
  UITapGestureRecognizer * tapGesture;
  UIPanGestureRecognizer * panGesture;
  UILongPressGestureRecognizer * longPressGesture;
  BOOL killScroll = NO;

  //--Pref Vars--//
  BOOL showTimeLine;
  int feedbackOption;
  float longPressTime;
  int doubleTap;
  int leftSwipe;
  int rightSwipe;
  int upSwipe;
  int downSwipe;
  int longPress;

@implementation ImperiumGestureController
+(void)callImpact {
  //Feedback thanks to CPDigitalDarkroom's MuscicBar! https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L156
  //Allocate feedback generatorpanGesture
  UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackOption];
  [generator prepare];
  [generator impactOccurred];

  //Allows scrolling after action is done
  killScroll = NO;
}
+(void)selectGesture:(int)command {

  NSLog(@"Command # - %i",command);
  if(command == 0) {
    //Do nothing
  } else if(command == 1) {
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
  } else if(command == 2) {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
  } else if(command == 3) {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
  } else if(command == 4) {
    //MusicBar by CPDigitalDarkroom, helpful to say the least
    SBApplication * nowPlaying = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).nowPlayingApplication;
    [[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:nowPlaying];
  } else {
    NSLog(@"Imperium - No action selected! HOW?");
  }
  [self callImpact];
}
@end

%hook MediaControlsTransportStackView
  //Hide the media controls on music widget by setting the view property "hidden" to yes
  -(void)layoutSubviews {
    self.hidden = YES;
    %orig;
  }
%end
%hook MediaControlsTimeControl
  -(void)layoutSubviews {
    self.hidden = showTimeLine;
  }
%end

%hook MediaControlsParentContainerView

  -(void)layoutSubviews {

    //Creating and adding the gestures
    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)] autorelease];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];

    panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)] autorelease];
    [self addGestureRecognizer:panGesture];

    longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] autorelease];
    longPressGesture.minimumPressDuration = longPressTime;
    longPressGesture.allowableMovement = 0;
    [self addGestureRecognizer:longPressGesture];

    //Detects swipe and kills scrolling
    if(panGesture.state == UIGestureRecognizerStateBegan) {
      killScroll = YES;
    }

    %orig;
  }

//Need a %new for every method, thanks /u/DGh0st
%new

  -(void)handleDoubleTap {
    [ImperiumGestureController selectGesture:doubleTap];
  }

%new

  -(void)handleSwipe:(UIPanGestureRecognizer *)sender {
    //Get UIPanGestureRecognizer x,y swipes
    CGPoint distance = [sender translationInView: self];

    if(sender.state == UIGestureRecognizerStateEnded) {
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
        [ImperiumGestureController selectGesture:longPress];
      }
    }
%end

%hook UIScrollView

  -(void)layoutSubviews {

    //Stops page changing on NC/CC, but stops scrolling EVERYWHERE. Theres probably a better way to do this
    if(killScroll) {
      self.scrollEnabled = NO;
    }
    %orig;
  }

%end

  //--Preferences--//
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

NSNumber * a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"feedbackOption" inDomain:domainString];
feedbackOption = (a)? [a intValue]:0;

NSNumber * b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"doubleTap" inDomain:domainString];
doubleTap = (b)? [b intValue]:1;

NSNumber * c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"leftSwipe" inDomain:domainString];
leftSwipe = (c)? [c intValue]:2;

NSNumber * d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"rightSwipe" inDomain:domainString];
rightSwipe = (d)? [d intValue]:3;

NSNumber * e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"longPress" inDomain:domainString];
longPress = (e)? [e intValue]:4;

NSNumber * f = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"longPressTime" inDomain:domainString];
longPressTime = (f)? [f floatValue]:1.0;

NSNumber * g = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"showTimeLine" inDomain:domainString];
showTimeLine = (g)? [g boolValue]:NO;

}

%ctor {

NSAutoreleasePool *pool = [NSAutoreleasePool new];
//set initial `enable' variable
notificationCallback(NULL, NULL, NULL, NULL, NULL);

//register for notifications
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
[pool release];
}
