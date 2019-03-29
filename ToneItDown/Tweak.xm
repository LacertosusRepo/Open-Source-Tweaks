/*
 * Tweak.xm
 * ToneItDown
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/27/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#define LD_DEBUG NO

@interface AVSystemController : NSObject
+(id)sharedAVSystemController;
-(BOOL)getVolume:(float*)arg1 forCategory:(id)arg2;
-(BOOL)setVolumeTo:(float)arg1 forCategory:(id)arg2;
@end

    //Preference variables
  static int toneMode;
  static float toneVolume;

    //Global variables
  float originalVolume;

%hook TKTonePickerController
  -(void)_playToneWithIdentifier:(id)arg1 {
    if(toneMode == 1) {
      NSLog(@"ToneItDown || Shhhhhh 1");
      return;
    } if(toneMode == 2) {
        //Set the volume to user selected and save original volume
      [[%c(AVSystemController) sharedAVSystemController] getVolume:&originalVolume forCategory:@"Ringtone"];
      [[%c(AVSystemController) sharedAVSystemController] setVolumeTo:toneVolume forCategory:@"Ringtone"];
      %orig;
    } else {
      %orig;
    }
  }

  -(void)finishedWithPicker {
    %orig;
    if(toneMode == 2) {
        //After closing tone picker set ringtone volume back to original
      [[%c(AVSystemController) sharedAVSystemController] setVolumeTo:originalVolume forCategory:@"Ringtone"];
    }
  }

  -(void)_didFinishPlayingAlert:(id)arg1 {
    %orig;
    if(toneMode == 2) {
        //After tone finishes set ringtone volume back to original
      [[%c(AVSystemController) sharedAVSystemController] setVolumeTo:originalVolume forCategory:@"Ringtone"];
    }
  }
%end

  /*
   * Loads my preferences.
   */
 static void loadPrefs() {
   NSString *mainPrefs = @"/User/Library/Preferences/com.lacertosusrepo.toneitdownprefs.plist";
   NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:mainPrefs];
   if(!preferences) {
     preferences = [[NSMutableDictionary alloc] init];
     toneMode = 1;
     toneVolume = 0.2;
   } else {
     toneMode = [[preferences objectForKey:@"toneMode"] intValue];
     toneVolume = [[preferences objectForKey:@"toneVolume"] floatValue];
   }
   [preferences release];
 }

 static NSString *nsNotificationString = @"com.lacertosusrepo.toneitdownprefs/preferences.changed";
 static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
   loadPrefs();
 }

  /*
   * Setup notifications
   */
%ctor {
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  loadPrefs();
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  [pool release];
}
