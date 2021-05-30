/*
 * Tweak.x
 * FlashlightIndicator
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/27/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "FlashlightIndicator.h"
#import "HBLog.h"

    //Variables
  UIViewPropertyAnimator *overScaleAnimation;
  UIViewPropertyAnimator *normalScaleAnimation;
  UIViewPropertyAnimator *restScaleAnimation;
  UIViewPropertyAnimator *zeroScaleAnimation;

  SBRecordingIndicatorView *flashlightIndicator;
  NSLayoutConstraint *flashlightIndicatorWidth;
  NSLayoutConstraint *flashlightIndicatorHeight;

  FLIRVisibilityState indicatorVisibilityState;

%hook SBRecordingIndicatorViewController
  -(void)calculateInitialIndicatorPositionAndSize {
    %orig;

    if(!flashlightIndicator) {
      flashlightIndicator = [[%c(SBRecordingIndicatorView) alloc] init];
      flashlightIndicator.alpha = 0;
      flashlightIndicator.backgroundColor = [UIColor whiteColor];
      flashlightIndicator.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:flashlightIndicator];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flir_updateIndicatorForFlashlightState:) name:@"FlashlightLevel" object:nil];
    }

    CGPoint center = [[self valueForKey:@"_center"] CGPointValue];

    [NSLayoutConstraint activateConstraints:@[
      [flashlightIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:((self.view.bounds.size.width / 2) - (center.x + 12)) * -1],
      [flashlightIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:((self.view.bounds.size.height / 2) - center.y) * -1],

      flashlightIndicatorWidth = [flashlightIndicator.widthAnchor constraintEqualToConstant:0],
      flashlightIndicatorHeight = [flashlightIndicator.heightAnchor constraintEqualToConstant:0],
    ]];
  }

%new
  -(void)flir_updateIndicatorForFlashlightState:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    BOOL state = [userInfo[@"FlashlightValue"] floatValue] > 0;

    if(state && indicatorVisibilityState != FLIRVisibilityStatePresented) {
      [self flir_startShowAnimator];
    }

    if(!state && indicatorVisibilityState != FLIRVisibilityStateHidden) {
      [self flir_startHideAnimator];
    }
  }

%new
  -(void)flir_startShowAnimator {
    [self flir_stopAllAnimations];

    CGFloat size = [[self valueForKey:@"_size"] floatValue];

    dispatch_async(dispatch_get_main_queue(), ^{
      overScaleAnimation = (overScaleAnimation) ?: [[UIViewPropertyAnimator alloc] initWithDuration:0.7 curve:UIViewAnimationCurveEaseInOut animations:nil];
      [overScaleAnimation addAnimations:^{
        indicatorVisibilityState = FLIRVisibilityStateAnimating;

        [flashlightIndicator setNeedsLayout];
        flashlightIndicator.alpha = 1.0;
        flashlightIndicatorWidth.constant = size * 1.2;
        flashlightIndicatorHeight.constant = size * 1.2;
        [flashlightIndicator layoutIfNeeded];
      }];
      [overScaleAnimation addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [normalScaleAnimation startAnimation];
      }];

      normalScaleAnimation = (normalScaleAnimation) ?: [[UIViewPropertyAnimator alloc] initWithDuration:0.7 curve:UIViewAnimationCurveEaseInOut animations:nil];
      [normalScaleAnimation addAnimations:^{
        [flashlightIndicator setNeedsLayout];
        flashlightIndicator.alpha = 1.0;
        flashlightIndicatorWidth.constant = size;
        flashlightIndicatorHeight.constant = size;
        [flashlightIndicator layoutIfNeeded];
      }];
      [normalScaleAnimation addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [restScaleAnimation startAnimation];
      }];

      restScaleAnimation = (restScaleAnimation) ?: [[UIViewPropertyAnimator alloc] initWithDuration:2.0 curve:UIViewAnimationCurveEaseInOut animations:nil];
      [restScaleAnimation addAnimations:^{
        [flashlightIndicator setNeedsLayout];
        flashlightIndicator.alpha = 0.8;
        flashlightIndicatorWidth.constant = size * 0.8;
        flashlightIndicatorHeight.constant = size * 0.8;
        [flashlightIndicator layoutIfNeeded];
      }];
      [restScaleAnimation addCompletion:^(UIViewAnimatingPosition finalPosition) {
        indicatorVisibilityState = FLIRVisibilityStatePresented;
      }];

      [overScaleAnimation startAnimation];
    });
  }

%new
  -(void)flir_startHideAnimator {
    [self flir_stopAllAnimations];

    dispatch_async(dispatch_get_main_queue(), ^{
      zeroScaleAnimation = (zeroScaleAnimation) ?: [[UIViewPropertyAnimator alloc] initWithDuration:1.0 curve:UIViewAnimationCurveEaseInOut animations:nil];
      [zeroScaleAnimation addAnimations:^{
        indicatorVisibilityState = FLIRVisibilityStateAnimating;

        [flashlightIndicator setNeedsLayout];
        flashlightIndicator.alpha = 0;
        flashlightIndicatorWidth.constant = 0;
        flashlightIndicatorHeight.constant = 0;
        [flashlightIndicator layoutIfNeeded];
      }];
      [zeroScaleAnimation addCompletion:^(UIViewAnimatingPosition finalPosition) {
        indicatorVisibilityState = FLIRVisibilityStateHidden;
      }];

      [zeroScaleAnimation startAnimation];
    });
  }

%new
  -(void)flir_stopAllAnimations {
    dispatch_async(dispatch_get_main_queue(), ^{
      if(overScaleAnimation.state == UIViewAnimatingStateActive) {
        [overScaleAnimation stopAnimation:YES];
      }

      if(normalScaleAnimation.state == UIViewAnimatingStateActive) {
        [normalScaleAnimation stopAnimation:YES];
      }

      if(restScaleAnimation.state == UIViewAnimatingStateActive) {
        [restScaleAnimation stopAnimation:YES];
      }

      if(zeroScaleAnimation.state == UIViewAnimatingStateActive) {
        [zeroScaleAnimation stopAnimation:YES];
      }
    });
  }
%end
