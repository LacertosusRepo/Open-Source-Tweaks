/*
 * Tweak.xm
 * DialerGradient
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 10/29/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"

@interface PHHandsetDialerView : UIView
@end

  NSString *colorOneString;
  NSString *colorTwoString;

%hook PHHandsetDialerView
  -(void)createConstraints {
    %orig;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    UIColor *colorOne = LCPParseColorString(colorOneString, @"48b1bf");
    UIColor *colorTwo = LCPParseColorString(colorTwoString, @"06beb6");

    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.dialergradientprefs"];
  [preferences registerObject:&colorOneString default:@"48b1bf" forKey:@"colorOneString"];
  [preferences registerObject:&colorTwoString default:@"06beb6" forKey:@"colorTwoString"];
}
