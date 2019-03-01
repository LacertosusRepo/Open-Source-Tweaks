		//---Headers---//
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import "Headers.h"

		//---Variables---//
	static int vibrationChoice;
	static int forceLevel;
	static BOOL hideHUD;
	static BOOL useHaptic;

@implementation FeedbackCall
+(void)vibrateDevice {
	if(useHaptic) {
		UIImpactFeedbackGenerator * feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:forceLevel];
		[feedback prepare];
		[feedback impactOccurred];
	} if(!useHaptic) {
		AudioServicesPlaySystemSound(1519);
	}
}
@end

		//---Hooks---//
%hook VolumeControl
	-(void)increaseVolume {
		if(vibrationChoice == 2) {
			[FeedbackCall vibrateDevice];
		} if(vibrationChoice == 1 && [[NSClassFromString(@"VolumeControl") sharedVolumeControl] volume] == 1){
			[FeedbackCall vibrateDevice];
		}
	%orig;
	}

	-(void)decreaseVolume {
		if(vibrationChoice == 2) {
			[FeedbackCall vibrateDevice];
		} if(vibrationChoice == 1 && [[NSClassFromString(@"VolumeControl") sharedVolumeControl] volume] == 0){
			[FeedbackCall vibrateDevice];
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

		//---Test Vibration---//
void startTestVibration() {
	[FeedbackCall vibrateDevice];
}

		//---Respring---//
static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

		//---Preferences---//
static void loadPrefs() {
	static NSString *file = @"/User/Library/Preferences/com.lacertosusrepo.volbratexiprefs.plist";
	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
	if(!preferences) {
		preferences = [[NSMutableDictionary alloc] init];
		vibrationChoice = 2;
		forceLevel = 0;
		hideHUD = YES;
		useHaptic = YES;
		[preferences writeToFile:file atomically:YES];
	} else {
		vibrationChoice = [[preferences objectForKey:@"vibrationChoice"] intValue];
		forceLevel = [[preferences objectForKey:@"forceLevel"] intValue];
		hideHUD = [[preferences objectForKey:@"hideHUD"] boolValue];
		useHaptic = [[preferences objectForKey:@"useHaptic"] boolValue];
	}
	[preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.volbratexiprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)startTestVibration, CFSTR("com.lacertosusrepo.volbratexi-testvibration"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.volbratexi-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
