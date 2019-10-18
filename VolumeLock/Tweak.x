/*
 * Tweak.xm
 * VolumeLock
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 9/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#define LD_DEBUG NO

  static BOOL toggleVolumeLock = NO;

  //Thanks Gilshahar7
  //https://github.com/gilshahar7/VolumeSongSkipper113/blob/master/Tweak.xm#L88
%hook SpringBoard
  -(BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)event {
    BOOL upPressed = NO;
    BOOL downPressed = NO;

    for(UIPress *press in event.allPresses.allObjects) {
      if(press.type == 102 && press.force == 1) {
        upPressed = YES;
      }
      if(press.type == 103 && press.force == 1) {
        downPressed = YES;
      }
    }

    if(upPressed && downPressed) {
      toggleVolumeLock = !toggleVolumeLock;
    }

    return %orig;
  }
%end

%hook VolumeControl
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
