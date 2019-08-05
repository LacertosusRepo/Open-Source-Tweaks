/*
 * Tweak.xm
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 4/1/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#import "LIBNoteView.h"
#define LD_DEBUG NO

@interface SBHomeScreenView : UIView
@end

%hook SBDashBoardViewController
  -(void)viewDidLoad {
    %orig;
    [LIBNoteView sharedInstance];
  }
%end

%hook UIStatusBar
  -(id)_initWithFrame:(CGRect)arg1 showForegroundView:(BOOL)arg2 inProcessStateProvider:(id)arg3{
    //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLIBNoteView:)];
    //[self addGestureRecognizer:longPress];
    return %orig;
  }
%new
  -(void)toggleLIBNoteView:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      [[LIBNoteView sharedInstance] showNoteView];
    }
  }
%end

%hook SBHomeScreenView
  -(void)setFrame:(CGRect)arg1 {
    %orig;
    UILongPressGestureRecognizer *pinchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLIBNoteView:)];
    pinchGesture.minimumPressDuration = 1.0;
    pinchGesture.allowableMovement = 0;
    [self addGestureRecognizer:pinchGesture];
  }
%new

  -(void)toggleLIBNoteView:(UIPinchGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      [[LIBNoteView sharedInstance] showNoteView];
    }
  }
%end

%ctor {
  NSString *bundleIDs = [[NSBundle mainBundle] bundleIdentifier];
  if(![bundleIDs isEqualToString:@"com.apple.springboard"]) {
    [[LIBNoteView sharedInstance] hideNoteView];
  }
}
