#import <MediaRemote/MediaRemote.h>
#import "Headers.h"

  //--Vars--//
  UITapGestureRecognizer * playPause;
  UIPanGestureRecognizer * skipGesture;
  BOOL killScroll = NO;

  //--Pref Vars--//
  int feedbackOption;
  int doubleTap;
  int leftSwipe;
  int rightSwipe;
  int upSwipe;
  int downSwipe;

@implementation ImperiumGestureController
+(void)callImpact {
  //Feedback thanks to CPDigitalDarkroom's MuscicBar! https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L156
  //Allocate feedback generator
  UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackOption];
  [generator prepare];
  [generator impactOccurred];

  //Allows scrolling after action is done
  killScroll = NO;
}
+(void)selectGesture:(int)gesture {
  if(gesture == 1) {
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
  } else if(gesture == 2) {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
  } else if(gesture == 3) {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
  } else {
    NSLog(@"Imperium - No action selected! HOW?");
  }
  [self callImpact];
}
@end

%hook MediaControlsContainerView

  //Hide the media controls on music widget by setting the view property "hidden" to yes
  -(void)layoutSubviews {
    self.hidden = YES;
    %orig;
  }

%end

%hook MediaControlsParentContainerView

  -(void)layoutSubviews {

    //Creating and adding the three gestures
    playPause = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    playPause.numberOfTapsRequired = 2;
    [self addGestureRecognizer:playPause];

    skipGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:skipGesture];

    if(skipGesture.state == UIGestureRecognizerStateBegan) {
      //Detects swipe and kills scrolling
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

%end

%hook UIScrollView

  -(void)layoutSubviews {

    //Stops page changing on NC/CC, but stops scrolling EVERYWHERE. Probably a better way to do this
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

}

%ctor {

NSAutoreleasePool *pool = [NSAutoreleasePool new];
//set initial `enable' variable
notificationCallback(NULL, NULL, NULL, NULL, NULL);

//register for notifications
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
[pool release];
}
