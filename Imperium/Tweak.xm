#import <MediaRemote/MediaRemote.h>
#import "Headers.h"

  //--Vars--//
  UITapGestureRecognizer * playPause;
  UIPanGestureRecognizer * skipGesture;
  BOOL killScroll = NO;

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
      //Detects swipe end
      killScroll = YES;
    }

    %orig;
  }

//Need a %new for every method, thanks /u/DGh0st
%new

  //Feedback thanks to CPDigitalDarkroom's MuscicBar!
  //https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L156
  -(void)lightImpact {

    //Allocate feedback generator
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];

    //Allows scrolling after action is done
    killScroll = NO;
  }

  %new

  -(void)handleDoubleTap {
    //Play & pause music
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);

    //Initiate feedback
    [self lightImpact];
  }

%new

  -(void)handleSwipe:(UIPanGestureRecognizer *)sender {
    //Get UIPanGestureRecognizer x,y swipes
    CGPoint distance = [sender translationInView: self];

    if(sender.state == UIGestureRecognizerStateEnded) {
      //UIPanGestureRecognizer left swipe
      if(distance.x < -70 && distance.y > -50 && distance.y < 50) {
        //Go to previous song
        MRMediaRemoteSendCommand(kMRPreviousTrack, nil);

        //Initiate feedback
        [self lightImpact];
      } else if(distance.x > -70 && distance.y > -50 && distance.y < 50) {
        //Go to previous song
        MRMediaRemoteSendCommand(kMRNextTrack, nil);

        //Initiate feedback
        [self lightImpact];
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
