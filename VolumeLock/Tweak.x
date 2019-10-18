/*
 * Tweak.xm
 * VolumeLock
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 9/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#define LD_DEBUG NO

@interface VolumeControl : NSObject
@end

  static BOOL toggleVolumeLock = NO;

%hook VolumeControl


  -(void)handleVolumeButtonWithType:(long long)arg1 down:(BOOL)arg2 {
    %orig;

    volUpButton = (arg1 == 102 && arg2 == 1) ? YES : NO;
    volDownButton = (arg1 == 103 && arg2 == 1) ? YES : NO;
  }

  -(void)increaseVolume {
    if(toggleVolumeLock) {
      return ;
    }

    %orig;
  }

  -(void)decreaseVolume {
    if(toggleVolumeLock) {
      return ;
    }

    %orig;
  }
%end
