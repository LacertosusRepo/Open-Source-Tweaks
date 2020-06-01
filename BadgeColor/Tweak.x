/*
 * Tweak.x
 * BadgeColor
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on XX/XX/XXXX.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
//#import <Cephei/HBPreferences.h>
#define LD_DEBUG NO
@import Alderis;
#import "AlderisColorPicker.h"
#import <Cephei/HBPreferences.h>

@interface SBDarkeningImageView : UIImageView
@end

  static NSString *badgeColor;

%hook SBDarkeningImageView
  -(void)setImage:(UIImage *)image {
    self.layer.backgroundColor = [UIColor PF_colorWithHex:badgeColor].CGColor;
    self.layer.masksToBounds = YES;

    %orig(nil);
  }

  -(void)layoutSubviews {
    %orig;
    
    self.layer.cornerRadius = self.bounds.size.height / 2;
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.badgecolorprefs"];
  [preferences registerObject:&badgeColor default:@"#D83244" forKey:@"badgeColor"];
}
