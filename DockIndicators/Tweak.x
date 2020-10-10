/*
 * Tweak.x
 * DockIndicators
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 10/9/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
@import Alderis;
#import "AlderisColorPicker.h"
#import <Cephei/HBPreferences.h>
#import "DockIndicators.h"

    //Global Variables
  static BOOL indicatorsNeedUpdate;

    //Preference Variables
  static NSInteger indicatorOffset;

  static NSInteger indicatorWidth;
  static NSInteger indicatorHeight;
  static CGFloat indicatorCornerRadius;

  static BOOL indicatorUseAppColor;
  static NSString *indicatorColor;

  static NSInteger indicatorAnimationType;

  //Function to create notification animation
CAAnimationGroup* animationForType(DIPNotificationAnimationType type) {
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.duration = 2;
  animationGroup.repeatCount = INT_MAX;

  switch (type) {
    case DIPNotificationAnimationTypeBounce:
    {
      CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
      bounce.additive = YES;
      bounce.calculationMode = kCAAnimationCubic;
      bounce.duration = 1.5;
      bounce.removedOnCompletion = NO;
      bounce.values = @[@0, @-3, @0, @-1.6, @0, @-0.9, @0, @-0.5, @0];
      animationGroup.animations = @[bounce];
      break;
    }

    case DIPNotificationAnimationTypeShakeX:
    {
      CAKeyframeAnimation *shakeX = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
      shakeX.additive = YES;
      shakeX.calculationMode = kCAAnimationLinear;
      shakeX.duration = 1.5;
      shakeX.removedOnCompletion = NO;
      shakeX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      shakeX.values = @[@0, @3, @-3, @3, @-1.5, @1.5, @-1.5, @0];
      animationGroup.animations = @[shakeX];
      break;
    }

    case DIPNotificationAnimationTypeShakeY:
    {
      CAKeyframeAnimation *shakeY = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
      shakeY.additive = YES;
      shakeY.calculationMode = kCAAnimationLinear;
      shakeY.duration = 1.5;
      shakeY.removedOnCompletion = NO;
      shakeY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      shakeY.values = @[@0, @-3, @3, @-3, @1.5, @-1.5, @1.5, @0];
      animationGroup.animations = @[shakeY];
      break;
    }

    case DIPNotificationAnimationTypeGlow:
    {
      CAKeyframeAnimation *glow = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
      glow.calculationMode = kCAAnimationLinear;
      glow.duration = 2;
      glow.removedOnCompletion = NO;
      glow.values = @[@0, @1, @0];
      animationGroup.animations = @[glow];
      break;
    }

    default:
    break;
  };

  return animationGroup;
}

  //https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
  //Function to obtain the average color from the icon
UIColor* colorFromImage(UIImage *image) {
  if(!image) {
    return nil;
  }

  CIImage *input = [[CIImage alloc] initWithImage:image];
  CIVector *extentVector = [CIVector vectorWithX:input.extent.origin.x Y:input.extent.origin.y Z:input.extent.size.width W:input.extent.size.height];
  CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage" withInputParameters:@{@"inputImage" : input, @"inputExtent" : extentVector}];
  CIImage *output = filter.outputImage;

  uint8_t bitmap[4] = {0, 0, 0, 0};
  CIContext *context = [CIContext contextWithOptions:@{@"kCIContextWorkingColorSpace" : [NSNull null]}];
  [context render:output toBitmap:&bitmap rowBytes:4 bounds:CGRectMake(0, 0, 1, 1) format:kCIFormatRGBA8 colorSpace:nil];

  return [UIColor colorWithRed:(CGFloat)bitmap[0]/255 green:(CGFloat)bitmap[1]/255 blue:(CGFloat)bitmap[2]/255 alpha:1];
}

%hook SBIconView
%property (nonatomic, retain) UIView *runningIndicator;

  -(BOOL)isLabelHidden {
    return YES;
  }
%end

%hook SBDockIconListView
  -(id)initWithModel:(id)arg1 layoutProvider:(id)arg2 iconLocation:(id)arg3 orientation:(long long)arg4 iconViewProvider:(id)arg5 {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRunningIndicators) name:@"SBApplicationProcessStateDidChange" object:nil];

    return %orig;
  }

%new
  -(void)updateRunningIndicators {
    for(SBIconView *iconView in self.subviews) {
      if(!iconView.runningIndicator || indicatorsNeedUpdate) {

        UIColor *averageAppColor;
        if(indicatorUseAppColor) {
           averageAppColor = colorFromImage(iconView.iconImageSnapshot);
        }

        iconView.runningIndicator = (iconView.runningIndicator) ?: [[UIView alloc] initWithFrame:CGRectZero];
        iconView.runningIndicator.alpha = (indicatorsNeedUpdate) ? iconView.runningIndicator.alpha : 0;
        iconView.runningIndicator.backgroundColor = (averageAppColor) ?: [UIColor PF_colorWithHex:indicatorColor];
        iconView.runningIndicator.layer.cornerRadius = indicatorCornerRadius;
        iconView.runningIndicator.layer.shadowColor = (averageAppColor.CGColor) ?: [UIColor PF_colorWithHex:indicatorColor].CGColor;
        iconView.runningIndicator.layer.shadowOffset = CGSizeZero;
        iconView.runningIndicator.layer.shadowOpacity = 0;
        iconView.runningIndicator.layer.shadowRadius = 3;
        iconView.runningIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [iconView addSubview:iconView.runningIndicator];

        [NSLayoutConstraint activateConstraints:@[
          [iconView.runningIndicator.centerXAnchor constraintEqualToAnchor:iconView.centerXAnchor],
          [iconView.runningIndicator.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:indicatorOffset],
          [iconView.runningIndicator.widthAnchor constraintEqualToConstant:indicatorWidth],
          [iconView.runningIndicator.heightAnchor constraintEqualToConstant:indicatorHeight],
        ]];
      }

      SBApplication *application = [(SBApplicationIcon *)iconView.icon valueForKey:@"_application"];
      [UIView transitionWithView:iconView.runningIndicator duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        iconView.runningIndicator.alpha = (application.processState.running) ? 1 : 0;
      } completion:nil];

      if(iconView.icon.badgeValue > 0 && ![iconView.runningIndicator.layer animationForKey:@"indicatorAnimation"] && indicatorAnimationType != DIPNotificationAnimationTypeNone) {
        [iconView.runningIndicator.layer addAnimation:animationForType(indicatorAnimationType) forKey:@"indicatorAnimation"];

      } else if(iconView.icon.badgeValue == 0 && [iconView.runningIndicator.layer animationForKey:@"indicatorAnimation"]) {
        [iconView.runningIndicator.layer removeAnimationForKey:@"indicatorAnimation"];
      }
    }

    if(indicatorsNeedUpdate) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        indicatorsNeedUpdate = NO;
      });
    }
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.dockindicatorsprefs"];
  [preferences registerInteger:&indicatorOffset default:5 forKey:@"indicatorOffset"];

  [preferences registerInteger:&indicatorWidth default:18 forKey:@"indicatorWidth"];
  [preferences registerInteger:&indicatorHeight default:5 forKey:@"indicatorHeight"];
  [preferences registerFloat:&indicatorCornerRadius default:2.5 forKey:@"indicatorCornerRadius"];

  [preferences registerBool:&indicatorUseAppColor default:NO forKey:@"indicatorUseAppColor"];
  [preferences registerObject:&indicatorColor default:@"#FFFFFF" forKey:@"indicatorColor"];

  [preferences registerInteger:&indicatorAnimationType default:DIPNotificationAnimationTypeBounce forKey:@"indicatorAnimationType"];

  [preferences registerPreferenceChangeBlock:^{
    indicatorsNeedUpdate = YES;
  }];
}
