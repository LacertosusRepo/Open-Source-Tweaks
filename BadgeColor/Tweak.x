/*
 * Tweak.x
 * BadgeColor
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 6/1/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#define LD_DEBUG NO
@import Alderis;
#import "AlderisColorPicker.h"
#import <Cephei/HBPreferences.h>

@interface SBDarkeningImageView : UIImageView
@end

@interface SBIconAccessoryImage : UIImage
@end

@interface SBIconBadgeView : UIView
@end

  static NSString *numberColor;
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

%hook SBIconBadgeView
  -(void)configureForIcon:(id)arg1 infoProvider:(id)arg2 {
    %orig;

    UIImageView *textView = [self valueForKey:@"_textView"];
    //You could just do this, but instead I opted for hooking the class method that creates the image
    //textView.image = [textView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    textView.tintColor = [UIColor PF_colorWithHex:numberColor];
  }

  +(SBIconAccessoryImage *)_createImageForText:(NSString *)arg1 font:(id)arg2 highlighted:(BOOL)arg3 {
    return (SBIconAccessoryImage *)[%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.badgecolorprefs"];
  [preferences registerObject:&numberColor default:@"D4D4D4" forKey:@"numberColor"];
  [preferences registerObject:&badgeColor default:@"#D83244" forKey:@"badgeColor"];
  [preferences registerFloat:&badgeCornerRadius default:13 forKey:@"badgeCornerRadius"];
}
