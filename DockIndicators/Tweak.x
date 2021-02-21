/*
 * Tweak.x
 * DockIndicators
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 10/9/2020.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <os/log.h>
#import <Cephei/HBPreferences.h>
@import Alderis;
#import "AlderisColorPicker.h"
#import "DockIndicators.h"

    //Global Variables
  static HBPreferences *preferences;

    //Preference Variables
  static NSInteger indicatorOffset;
  static NSInteger indicatorWidth;
  static NSInteger indicatorHeight;
  static CGFloat indicatorCornerRadius;
  static BOOL indicatorUseAppColor;
  static NSString *indicatorColor;
  static NSInteger indicatorAnimationType;

#pragma mark - Functions

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

    case DIPNotificationAnimationTypePulse:
    {
      CAKeyframeAnimation *pulse = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
      pulse.calculationMode = kCAAnimationLinear;
      pulse.duration = 2;
      pulse.removedOnCompletion = NO;
      pulse.values = @[@1, @0.1, @1];
      animationGroup.animations = @[pulse];
      break;
    }

    default:
    break;
  };

  return animationGroup;
}

  //https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
  //Function to obtain the average color from the icon
UIColor* averageColorFromImage(UIImage *image, NSString *identifier) {
  if(!image || !identifier) {
    return nil;
  }

  NSMutableDictionary *mutableCache = ([[preferences objectForKey:@"appColorCache"] mutableCopy]) ?: [[NSMutableDictionary alloc] init];
  if([mutableCache objectForKey:identifier]) {
    return [UIColor PF_colorWithHex:[mutableCache objectForKey:identifier]];
  }

  CIImage *input = [[CIImage alloc] initWithImage:image];
  CIVector *extentVector = [CIVector vectorWithX:input.extent.origin.x Y:input.extent.origin.y Z:input.extent.size.width W:input.extent.size.height];
  CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage" withInputParameters:@{@"inputImage" : input, @"inputExtent" : extentVector}];
  CIImage *output = filter.outputImage;

  uint8_t bitmap[4] = {0, 0, 0, 0};
  CIContext *context = [CIContext contextWithOptions:@{@"kCIContextWorkingColorSpace" : [NSNull null]}];
  [context render:output toBitmap:&bitmap rowBytes:4 bounds:CGRectMake(0, 0, 1, 1) format:kCIFormatRGBA8 colorSpace:nil];

  UIColor *averageColor = [UIColor colorWithRed:(CGFloat)bitmap[0]/255 green:(CGFloat)bitmap[1]/255 blue:(CGFloat)bitmap[2]/255 alpha:1];
  [mutableCache setObject:[UIColor PF_hexFromColor:averageColor] forKey:identifier];
  [preferences setObject:mutableCache forKey:@"appColorCache"];

  return averageColor;
}

#pragma mark - Hooks

%hook SBIconView
%property (nonatomic, retain) UIView *runningIndicator;

  -(instancetype)initWithFrame:(CGRect)arg1 {
    os_log(OS_LOG_DEFAULT, "DockIndicators - 1");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRunningIndicator:) name:@"SBApplicationProcessStateDidChange" object:nil];

    return %orig;
  }

  -(void)_updateLabelAccessoryView {
    %orig;

    if(self.runningIndicator) {
      if(self.icon.badgeValue > 0 && ![self.runningIndicator.layer animationForKey:@"indicatorAnimation"] && indicatorAnimationType != DIPNotificationAnimationTypeNone) {
        [self.runningIndicator.layer addAnimation:animationForType(indicatorAnimationType) forKey:@"indicatorAnimation"];

      } else if(self.icon.badgeValue == 0 && [self.runningIndicator.layer animationForKey:@"indicatorAnimation"]) {
        [self.runningIndicator.layer removeAnimationForKey:@"indicatorAnimation"];
      }
    }
  }
%end

%hook SBDockIconListView
  -(instancetype)initWithModel:(id)arg1 layoutProvider:(id)arg2 iconLocation:(id)arg3 orientation:(long long)arg4 iconViewProvider:(id)arg5 {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRunningIndicators:) name:@"SBApplicationProcessStateDidChange" object:nil];

    return %orig;
  }

%new
  -(void)updateRunningIndicators:(NSNotification *)notification {
    for(SBIconView *iconView in self.subviews) {
      if(![iconView isKindOfClass:[%c(SBIconView) class]] || iconView.folderIcon || ![iconView.icon isKindOfClass:[%c(SBApplicationIcon) class]]) {
        continue; //Ignore icon to fix crash for Harbor 3, if the icon is a folder, if the icon is a download/update
      }

      if(!iconView.runningIndicator || ![iconView.runningIndicator.superview isKindOfClass:[%c(SBIconView) class]]) {
          //if the iPad dock used by FloatingDockPlus13 or Dock Controller the indicator randomly gets moved to another subview, we move it back to the icon view
        if(![iconView.runningIndicator.superview isKindOfClass:[%c(SBIconView) class]]) {
          [iconView.runningIndicator removeFromSuperview];
        }

        iconView.runningIndicator = iconView.runningIndicator ?: [[UIView alloc] init];
        iconView.runningIndicator.alpha = 0;
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

      UIColor *averageAppColor;
      if(indicatorUseAppColor && iconView.iconImageSnapshot) {
         averageAppColor = averageColorFromImage(iconView.iconImageSnapshot, iconView.applicationBundleIdentifierForShortcuts);
      }

      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        iconView.runningIndicator.backgroundColor = (averageAppColor) ?: [UIColor PF_colorWithHex:indicatorColor];
        iconView.runningIndicator.layer.cornerRadius = indicatorCornerRadius;
        iconView.runningIndicator.layer.shadowColor = (averageAppColor.CGColor) ?: [UIColor PF_colorWithHex:indicatorColor].CGColor;
      } completion:nil];

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
  }
%end

%ctor {
  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.dockindicatorsprefs"];
  [preferences registerInteger:&indicatorOffset default:5 forKey:@"indicatorOffset"];
  [preferences registerInteger:&indicatorWidth default:18 forKey:@"indicatorWidth"];
  [preferences registerInteger:&indicatorHeight default:5 forKey:@"indicatorHeight"];
  [preferences registerFloat:&indicatorCornerRadius default:2.5 forKey:@"indicatorCornerRadius"];
  [preferences registerBool:&indicatorUseAppColor default:NO forKey:@"indicatorUseAppColor"];
  [preferences registerObject:&indicatorColor default:@"#FFFFFF" forKey:@"indicatorColor"];
  [preferences registerInteger:&indicatorAnimationType default:DIPNotificationAnimationTypeBounce forKey:@"indicatorAnimationType"];
}
