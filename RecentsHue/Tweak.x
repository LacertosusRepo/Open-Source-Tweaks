/*
 * Tweak.x
 * RecentsHue
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 6/18/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
@import Alderis;
#import <Cephei/HBPreferences.h>
#import "AlderisColorPicker.h"
#import "RecentsHue.h"

    //Preferences
  static CGFloat indicatorAlpha;
  static NSString *normalColorHex;
  static NSString *voicemailColorHex;
  static NSString *voipColorHex;
  static NSString *telephonyColorHex;
  static NSString *ftVideoColorHex;
  static NSString *ftAudioColorHex;
  static NSString *faceTimeColorHex;

  //Add color indicator view property to cell
%hook MPRecentsTableViewCell
%property (nonatomic, retain) UIView *_colorIndicator;
%end

%hook MPRecentsTableViewController
  -(id)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    MPRecentsTableViewCell *cell = %orig;

    if(cell) {
        //ColorCodedLogs, https://github.com/leftyfl1p/ColorCodedLogs
        //Of course it was exactly what I was trying to figure out
      CHRecentCall *recentCall = [self recentCallAtTableViewIndex:arg2.row];

        //check if color indicator view already exists, if not create it and add constaints
      if(!cell._colorIndicator) {
        cell._colorIndicator = (cell._colorIndicator) ?: [[UIView alloc] init];
        cell._colorIndicator.alpha = indicatorAlpha;
        cell._colorIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView insertSubview:cell._colorIndicator atIndex:0];

        [NSLayoutConstraint activateConstraints:@[
          [cell._colorIndicator.widthAnchor constraintEqualToConstant:5],
          [cell._colorIndicator.heightAnchor constraintEqualToAnchor:cell.contentView.heightAnchor],
          [cell._colorIndicator.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
          [cell._colorIndicator.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
        ]];
      }

        //Check what type of call it was, not sure what the difference between FaceTime and FaceTimeAudio/Video is
      switch (recentCall.callType) {
        case kCallTypeNormal:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:normalColorHex];
        break;

        case kCallTypeVoicemail:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:voicemailColorHex];
        break;

        case kCallTypeVOIP:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:voipColorHex];
        break;

        case kCallTypeTelephony:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:telephonyColorHex];
        break;

        case kCallTypeFaceTimeVideo:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:ftVideoColorHex];
        break;

        case kCallTypeFaceTimeAudio:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:ftAudioColorHex];
        break;

        case kCallTypeFaceTime:
        cell._colorIndicator.backgroundColor = [UIColor PF_colorWithHex:faceTimeColorHex];
        break;

        default:
        cell._colorIndicator.backgroundColor = [UIColor clearColor];
        break;
      }
    }

    return cell;
  }
%end

%ctor {
  //Assisted me in getting the different types of call type
  /*int i = 0;
  for(i = 0; i < 100; i++) {
    os_log(OS_LOG_DEFAULT, "%d || %@", i, [%c(CHRecentCall) callTypeAsString:i]);
  }*/

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.recentshueprefs"];
  [preferences registerFloat:&indicatorAlpha default:0.45 forKey:@"indicatorAlpha"];
  [preferences registerObject:&normalColorHex default:@"#069A9E" forKey:@"normalColorHex"];
  [preferences registerObject:&voicemailColorHex default:@"#F1D248" forKey:@"voicemailColorHex"];
  [preferences registerObject:&voipColorHex default:@"#E15D2F" forKey:@"voipColorHex"];
  [preferences registerObject:&telephonyColorHex default:@"#6DB644" forKey:@"telephonyColorHex"];
  [preferences registerObject:&ftVideoColorHex default:@"#613DBE" forKey:@"ftVideoColorHex"];
  [preferences registerObject:&ftAudioColorHex default:@"#613DBE" forKey:@"ftAudioColorHex"];
  [preferences registerObject:&faceTimeColorHex default:@"#613DBE" forKey:@"faceTimeColorHex"];
}
