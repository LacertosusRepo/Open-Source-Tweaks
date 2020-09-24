/*
 * Tweak.x
 * VolbrateXI
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/13/2019.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import "VolbrateXIClasses.h"
#define LD_DEBUG NO

	/*
   * Variables
   */
	static NSInteger vibrationChoice;
	static NSInteger forceLevel;
	static BOOL hideHUD;
	static BOOL useHaptic;

static void feedBackCall() {
	if(useHaptic) {
		UIImpactFeedbackGenerator * feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(int)forceLevel];
		[feedback prepare];
		[feedback impactOccurred];
	} if(!useHaptic) {
		AudioServicesPlaySystemSound(1519);
	}
}

		/*
     * Hooks
     */
%hook VolumeControl
	-(void)increaseVolume {
		if((int)vibrationChoice == 2) {
			feedBackCall();
		} if((int)vibrationChoice == 1 && [[NSClassFromString(@"VolumeControl") sharedVolumeControl] volume] == 1){
			feedBackCall();
		}

	%orig;
	}

	-(void)decreaseVolume {
		if((int)vibrationChoice == 2) {
			feedBackCall();
		} if((int)vibrationChoice == 1 && [[NSClassFromString(@"VolumeControl") sharedVolumeControl] volume] == 0){
			feedBackCall();
		}

	%orig;
	}

	-(void)_presentVolumeHUDWithMode:(int)arg1 volume:(float)arg2 {
		if(hideHUD == YES) {
			return;
		} else {
			%orig;
		}
	}
%end

static void startTestVibration() {
	feedBackCall();
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)startTestVibration, CFSTR("com.lacertosusrepo.volbratexi-testvibration"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.volbratexiprefs"];
  [preferences registerBool:&hideHUD default:YES forKey:@"hideHUD"];
  [preferences registerBool:&useHaptic default:YES forKey:@"useHaptic"];
  [preferences registerInteger:&vibrationChoice default:2 forKey:@"vibrationChoice"];
  [preferences registerInteger:&forceLevel default:0 forKey:@"forceLevel"];
}
