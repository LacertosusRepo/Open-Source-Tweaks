/*
 * Tweak.xm
 * Imperium
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 10/20/2019.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "ImperiumController.h"
#import "ImperiumClasses.h"
#define LD_DEBUG NO

  //Variables
  UIScrollView *dashBoardScrollView;

  //Preference Variables
  static CGFloat longPressDuration;
  static NSInteger feedbackForce;

  static NSInteger rightSwipeCommand;
  static NSInteger leftSwipeCommand;
  static NSInteger upSwipeCommand;
  static NSInteger downSwipeCommand;
  static NSInteger tapGestureCommand;
  static NSInteger pressGestureCommand;

  //Hide music controls
%hook MediaControlsTransportButton
  -(void)layoutSubviews {
    %orig;
    self.hidden = YES;
  }
%end

%hook SBDashBoardScrollGestureController
  -(id)initWithDashBoardView:(id)arg1 {
    dashBoardScrollView = [self valueForKey:@"_scrollView"];

    return %orig;
  }
%end

%hook MediaControlsTransportStackView
    //Add gesture to view
  -(id)initWithFrame:(CGRect)arg1 {
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];

    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:upSwipe];

    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:downSwipe];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    longPressGesture.minimumPressDuration = longPressDuration;
    longPressGesture.allowableMovement = 0;
    [self addGestureRecognizer:longPressGesture];


    return %orig;
  }

%new
  -(void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    switch (gesture.direction) {
      case UISwipeGestureRecognizerDirectionRight:
      [ImperiumController gestureWithCommand:rightSwipeCommand];
      [ImperiumController feedbackWithForce:feedbackForce];
      break;

      case UISwipeGestureRecognizerDirectionLeft:
      [ImperiumController gestureWithCommand:leftSwipeCommand];
      [ImperiumController feedbackWithForce:feedbackForce];
      break;

      case UISwipeGestureRecognizerDirectionUp:
      [ImperiumController gestureWithCommand:upSwipeCommand];
      [ImperiumController feedbackWithForce:feedbackForce];
      break;

      case UISwipeGestureRecognizerDirectionDown:
      [ImperiumController gestureWithCommand:downSwipeCommand];
      [ImperiumController feedbackWithForce:feedbackForce];
      break;
    }
  }

%new
  -(void)handleTap:(UITapGestureRecognizer *)gesture {
    [ImperiumController gestureWithCommand:tapGestureCommand];
    [ImperiumController feedbackWithForce:feedbackForce];
  }

%new
  -(void)handlePress:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      [ImperiumController gestureWithCommand:pressGestureCommand];
      [ImperiumController feedbackWithForce:feedbackForce];
    }
  }

%new  //Compatibility for SpinXI
  -(float)longPressTime {
    return longPressDuration;
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.imperiumprefs"];
  [preferences registerFloat:&longPressDuration default:0.75 forKey:@"longPressDuration"];
  [preferences registerInteger:&feedbackForce default:lightForce forKey:@"feedbackForce"];

  [preferences registerInteger:&leftSwipeCommand default:skipForward forKey:@"leftSwipeCommand"];
  [preferences registerInteger:&rightSwipeCommand default:skipBack forKey:@"rightSwipeCommand"];
  [preferences registerInteger:&upSwipeCommand default:doNothing forKey:@"upSwipeCommand"];
  [preferences registerInteger:&downSwipeCommand default:doNothing forKey:@"downSwipeCommand"];
  [preferences registerInteger:&tapGestureCommand default:togglePlayPause forKey:@"tapGestureCommand"];
  [preferences registerInteger:&pressGestureCommand default:openNowPlaying forKey:@"pressGestureCommand"];
}
