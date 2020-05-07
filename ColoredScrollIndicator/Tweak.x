/*
 * Tweak.x
 * ColoredScrollIndicator
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/5/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"
#define LD_DEBUG NO

@interface _UIScrollViewScrollIndicator : UIView
@property (nonatomic,retain) UIView * roundedFillView;
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
  -(UIView *)roundedFillView {
    UIView *scroller = %orig;
    scroller.backgroundColor = [UIColor clearColor];

    one = LCPParseColorString(gradientColorOne, @"#8693AB");
    two = LCPParseColorString(gradientColorTwo, @"#BDD4E7");
    border = LCPParseColorString(gradientBorderColor, @"#FFFFFF");

    if([scroller.layer.sublayers count] == 0) {
      CAGradientLayer *gradient = [CAGradientLayer layer];
      gradient.startPoint = CGPointMake(0.5, 0.0);
      gradient.endPoint = CGPointMake(0.5, 1.0);
      gradient.colors = @[(id)one.CGColor, (id)two.CGColor];
      gradient.opacity = gradientAlpha;
      gradient.cornerRadius = gradientCornerRadius;
      gradient.borderColor = border.CGColor;
      gradient.borderWidth = gradientBorderWidth;
      [scroller.layer addSublayer:gradient];
    }

    return scroller;
  }

  -(void)layoutSubviews {
    %orig;
    for(CAGradientLayer *gradient in self.roundedFillView.layer.sublayers) {
      gradient.frame = self.roundedFillView.bounds;
    }
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.coloredscrollindicatorprefs"];
  [preferences registerObject:&gradientColorOne default:@"#8693AB" forKey:@"gradientColorOne"];
  [preferences registerObject:&gradientColorTwo default:@"#BDD4E7" forKey:@"gradientColorTwo"];
  [preferences registerFloat:&gradientAlpha default:0.5 forKey:@"gradientAlpha"];
  [preferences registerFloat:&gradientCornerRadius default:1.5 forKey:@"gradientCornerRadius"];
  [preferences registerFloat:&gradientBorderWidth default:0 forKey:@"gradientBorderWidth"];
  [preferences registerObject:&gradientBorderColor default:@"#FFFFFF" forKey:@"gradientBorderColor"];
}
