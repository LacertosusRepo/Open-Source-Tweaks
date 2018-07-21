#import <MediaRemote/MediaRemote.h>

  //--Vars--//
  UITapGestureRecognizer * playPause;
  UISwipeGestureRecognizer * skipForward;
  UISwipeGestureRecognizer * skipBack;

//Create propertys for media controls
@interface MediaControlsContainerView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

%hook MediaControlsContainerView

  //Hide the media controls on music widget
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

    skipForward = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe)];
    [skipForward setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:skipForward];

    skipBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe)];
    [skipBack setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:skipBack];

    %orig;

  }

//Need a %new for every method, thanks /u/DGh0st
%new

  -(void)handleDoubleTap {
    //Play & pause music
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);

  }

%new

  -(void)handleRightSwipe {
    //Go to next song
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
  }

%new

  -(void)handleLeftSwipe {
    //Go to previous song
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
  }

%end
