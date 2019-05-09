/*
 * Tweak.xm
 * Swiper
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/8/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "MediaRemote.h"
#define LD_DEBUG NO

@interface SBFloatingDockPlatterView : UIView
@end

%hook SBFloatingDockPlatterView
  -(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];

    return %orig;
  }

%new
  -(void)handleRightSwipe:(UISwipeGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    }
  }

%new
  -(void)handleLeftSwipe:(UISwipeGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      MRMediaRemoteSendCommand(kMRNextTrack, nil);
    }
  }
%end
