/*
 * Tweak.x
 * ColoredScrollIndicator
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/5/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <UIKit/UIKit.h>
@import Alderis;
#import "AlderisColorPicker.h"
#import <Cephei/HBPreferences.h>
#import <os/log.h>
#define LD_DEBUG NO

@interface _UIScrollViewScrollIndicator : UIView
@property (nonatomic, retain) UIView *roundedFillView;
@property (nonatomic, retain) CAGradientLayer *gradient;
@end

@interface UIView (iOS13)
@property (nonatomic, assign, readwrite) CGFloat _cornerRadius;
@end

    //Vars
  UIColor *one;
  UIColor *two;
  UIColor *border;

    //Preferences
  static NSString *gradientColorOne;
  static NSString *gradientColorTwo;
  static CGFloat gradientAlpha;
  static CGFloat gradientCornerRadius;
  static CGFloat gradientBorderWidth;
  static NSString *gradientBorderColor;

%hook _UIScrollViewScrollIndicator
%property (nonatomic, retain) CAGradientLayer *gradient;
  -(UIView *)roundedFillView {
    %orig.backgroundColor = [UIColor clearColor];

    one = [UIColor PF_colorWithHex:gradientColorOne];
    two = [UIColor PF_colorWithHex:gradientColorTwo];
    border = [UIColor PF_colorWithHex:gradientBorderColor];

    if(!self.gradient) {
      self.gradient = [CAGradientLayer layer];
      self.gradient.startPoint = CGPointMake(0.5, 0.0);
      self.gradient.endPoint = CGPointMake(0.5, 1.0);
      self.gradient.colors = @[(id)one.CGColor, (id)two.CGColor];
      self.gradient.opacity = gradientAlpha;
      self.gradient.cornerRadius = gradientCornerRadius;
      self.gradient.borderColor = border.CGColor;
      self.gradient.borderWidth = gradientBorderWidth;
      [%orig.layer addSublayer:self.gradient];
    }

    return %orig;
  }

  -(void)layoutSubviews {
    %orig;

    self.gradient.frame = self.roundedFillView.bounds;
  }
%end

%ctor {
  os_log(OS_LOG_DEFAULT, "%@", [[[NSProcessInfo processInfo] arguments] objectAtIndex:0]);
  if([[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@".app"]) {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
    [preferences registerObject:&gradientColorOne default:@"#8693AB" forKey:@"gradientColorOne"];
    [preferences registerObject:&gradientColorTwo default:@"#BDD4E7" forKey:@"gradientColorTwo"];
    [preferences registerFloat:&gradientAlpha default:0.5 forKey:@"gradientAlpha"];
    [preferences registerFloat:&gradientCornerRadius default:1.5 forKey:@"gradientCornerRadius"];
    [preferences registerFloat:&gradientBorderWidth default:0 forKey:@"gradientBorderWidth"];
    [preferences registerObject:&gradientBorderColor default:@"#FFFFFF" forKey:@"gradientBorderColor"];
    %init;
  }
}
