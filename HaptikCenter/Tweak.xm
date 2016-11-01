//Headers
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>
#import "BBHeaders.h"
#import <UIKit/_UITapticEngine.h>
#include <sys/types.h>
#include <sys/sysctl.h>

//Preference Setup
@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Preference Variables
static NSString *domainString = @"com.lacertosusrepo.hcprefs";
static NSString *notificationString = @"com.lacertosusrepo.hcprefs/preferences.changed";

//Vibration Declaration
FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);
static int const UITapticEngineFeedbackPop = 1002;
_UITapticEngine *tapticEngine;

		/////////////////////////
		////////Variables////////
		/////////////////////////
	
	//Vibration:
	static float timeLength = 0.05;
	static float vibeIntensity = 0.75;

	//CC:
	static BOOL haptikButtons = YES;
	static BOOL haptikSliders = YES;
	static BOOL haptikInduce = YES;

	static int sliderVibrateOptions = 2;
	static int inducedVibrateOptions = 3;

	//NC:
	static BOOL haptikClear = YES;
	static BOOL haptikReach = YES;
	static BOOL haptikAction = YES;

	static int reachVibrateOptions = 3;

	//Other:
	static BOOL logSwitch = YES;
	static BOOL useTapticEngine = NO;
	static BOOL tapticSupported;

//Vibration Method Implementation
@interface FeedbackCall : NSObject
+ (void)vibrateDevice;
+ (void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity;

+ (void)tapticDevice;

- (NSString *)platform;
- (BOOL)tapticSupported;
+ (void)actuateVibration;
@end

@implementation FeedbackCall
+ (void)vibrateDevice {
	[FeedbackCall vibrateDeviceForTimeLengthIntensity:timeLength vibrationIntensity:vibeIntensity];
}

+ (void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity {

	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	NSMutableArray* arr = [NSMutableArray array];
 
	[arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for time length
	[arr addObject:[NSNumber numberWithInt:timeLength*1000]];

	[arr addObject:[NSNumber numberWithBool:NO]];
	[arr addObject:[NSNumber numberWithInt:50]];
    
	[dict setObject:arr forKey:@"VibePattern"];
	[dict setObject:[NSNumber numberWithFloat:vibeIntensity] forKey:@"Intensity"];
    
	AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dict);

}

- (NSString *)platform {
	
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);

    return platform;
	
}	

- (BOOL)tapticSupported {
	
	if([[[self platform] substringToIndex: 8] isEqualToString:@"iPhone8,"]) {
		
		return YES;
		
	} else {
		
		return NO;	
	
	}
}

+ (void)tapticDevice {
	
	[tapticEngine actuateFeedback:UITapticEngineFeedbackPop];
	
}

+ (void)actuateVibration {
	
	if(tapticSupported && useTapticEngine == YES) {
		
		[self tapticDevice];
		
	} else {
		
		[self vibrateDevice];
	
	}
}
@end

	
	////////////////////////
	//Code Control Center://
	////////////////////////

//CC Toggles
%hook SBUIControlCenterButton

	-(void)_pressAction {
		
		if(haptikButtons == YES && useTapticEngine == NO) {
 
			[FeedbackCall actuateVibration];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;	
	}
	
%end

//CC Brightnedd Slider
%hook SBUIControlCenterSlider

	-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 1) {
		
			[FeedbackCall actuateVibration];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall actuateVibration];
			
		} if(logSwitch) {
		
		%log;
		
	}
	return %orig;
	}

	-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall actuateVibration];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall actuateVibration];
			
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}

%end

//Media Controls
//CC Volume Slider
%hook MPUMediaControlsVolumeView
	
	-(void)_volumeSliderBeganChanging:(id)arg1 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 1) {
			
			[FeedbackCall actuateVibration];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall actuateVibration];
			
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	-(void)_volumeSliderStoppedChanging:(id)arg1 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall actuateVibration];
		
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall actuateVibration];
			
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
%end

//Control Center Present & Dismiss
%hook SBControlCenterController
	
	-(void)_showControlCenterGestureBeganWithGestureRecognizer:(id)arg1 {
		
		if (haptikInduce && inducedVibrateOptions == 1) {

			[FeedbackCall actuateVibration];
	
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	-(void)beginPresentationWithTouchLocation:(CGPoint)arg1 presentationBegunHandler:(/*^block*/id)arg2 {
		
		if (haptikInduce && inducedVibrateOptions == 2) {
	
			[FeedbackCall actuateVibration];
	
		} if(logSwitch) {
		
			%log;
		
		}
	return %orig;
	}
	
	-(void)_beginPresentation {
	
		if(haptikInduce && inducedVibrateOptions == 3) {
			
			[FeedbackCall actuateVibration];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
%end

		/////////////////////////////
		//Code Notification Center://
		/////////////////////////////

//NC Clear Button:
%hook SBNotificationCenterHeaderView

	-(id)clearButtonFinalAction {
		
		if(haptikClear) {
			
			[FeedbackCall actuateVibration];
		
		} if(logSwitch) {
		
			%log;
		
		}
	return %orig;
	}

%end

//Rechability in NC
%hook SBNotificationCenterViewController

	//NC Reachability Activate
	-(void)handleReachabilityModeActivated {
		
		if(haptikReach && reachVibrateOptions == 1) {
			
			[FeedbackCall actuateVibration];
		
		} if(haptikReach && reachVibrateOptions == 3) {
			
			[FeedbackCall actuateVibration];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	//NC Reachability Deactivate
	-(void)handleReachabilityModeDeactivated {
		
		if(haptikReach && reachVibrateOptions == 2) {
			
			[FeedbackCall actuateVibration];
			
		} if(haptikReach && reachVibrateOptions == 3) {
			
			[FeedbackCall actuateVibration];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	//Handle Notification Action
	-(BOOL)handleAction:(id)arg1 forBulletin:(id)arg2 withCompletion:(/*^block*/id)arg3 {
		
		if(YES && haptikAction) {
			
			[FeedbackCall actuateVibration];
			
		} if(logSwitch) {
			
			%log;
			
		}
	return %orig;
	}

%end

//Test Vibration
void startTestVibration() {
	
	[FeedbackCall actuateVibration];
	
	id request = [[[%c(BBBulletinRequest) alloc] init] autorelease];
			[request setTitle: @"HaptikCenter"];
			[request setMessage: @"Starting Vibration..."];
			[request setSectionID: @"com.apple.Preferences"];
			[request setBulletinID: @"com.lacertosusrepo.haptikcenter"];
			[request setDefaultAction: [%c(BBAction) action]];
			
	id ctrl = [%c(SBBulletinBannerController) sharedInstance];
	if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2];
	} else if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:playLightsAndSirens:withReply:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2 playLightsAndSirens:YES withReply:nil];
	}
}

//No Respring Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"haptikButtons" inDomain:domainString];
	haptikButtons = (a)? [a boolValue]:YES;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"haptikSliders" inDomain:domainString];
	haptikSliders = (b)? [b boolValue]:YES;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sliderVibrateOptions" inDomain:domainString];
	sliderVibrateOptions = (c)? [c intValue]:2;
	
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"inducedVibrateOptions" inDomain:domainString];
	inducedVibrateOptions = (d)? [d intValue]:3;
	
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"timeLength" inDomain:domainString];
	timeLength = (e)? [e floatValue]:0.05;
	
	NSNumber *f = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"vibeIntensity" inDomain:domainString];
	vibeIntensity = (f)? [f floatValue]:0.75;
	
	NSNumber *g = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"haptikClear" inDomain:domainString];
	haptikClear = (g)? [g boolValue]:YES;
	
	NSNumber *h = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"logSwitch" inDomain:domainString];
	logSwitch = (h)? [h boolValue]:YES;
	
	NSNumber *i = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"haptikAction" inDomain:domainString];
	haptikAction = (i)? [i boolValue]:YES;
	
	NSNumber *j = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"haptikReach" inDomain:domainString];
	haptikReach = (j)? [j boolValue]:YES;
	
	NSNumber *k = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"reachVibrateOptions" inDomain:domainString];
	reachVibrateOptions = (k)? [k intValue]:3;
	
	NSNumber *l = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useTapticEngine" inDomain:domainString];
	useTapticEngine = (l)? [l boolValue]:NO;
}

%ctor {
	
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)startTestVibration, CFSTR("com.lacertosusrepo.haptikcenter-testvibration"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}