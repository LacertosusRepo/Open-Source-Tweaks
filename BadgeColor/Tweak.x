/*
 * Tweak.x
 * BadgeColor
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on who/XX/XXXX.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#define LD_DEBUG NO
@import Alderis;
#import "AlderisColorPicker.h"
#import <Cephei/HBPreferences.h>

@interface SBDarkeningImageView : UIImageView
@end

  static NSString *badgeColor;
  static CGFloat badgeCornerRadius;

%hook SBDarkeningImageView
  -(void)setImage:(UIImage *)image {
    self.layer.backgroundColor = [UIColor PF_colorWithHex:badgeColor].CGColor;
    self.layer.masksToBounds = YES;

    %orig(nil);
  }

  -(void)layoutSubviews {
    %orig;

    if(self.layer.cornerRadius != badgeCornerRadius) {
      self.layer.cornerRadius = badgeCornerRadius;
    }
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.badgecolorprefs"];
  [preferences registerObject:&badgeColor default:@"#D83244" forKey:@"badgeColor"];
  [preferences registerFloat:&badgeCornerRadius default:14.5 forKey:@"badgeCornerRadius"];
}
