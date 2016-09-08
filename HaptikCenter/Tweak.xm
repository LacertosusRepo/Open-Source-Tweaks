//Headers
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>
#import "BBHeaders.h"

//Defines
#define RESET_BANNER_T @"HaptikCenter"
#define RESET_BANNER_M @"Succesfully Reset Settings."
#define RESET_BANNER_M_FAIL @"Failed to Reset Settings."

//Preference Setup
@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Preference Variabled
static NSString *domainString = @"com.lacertosusrepo.hcprefs";
static NSString *notificationString = @"com.lacertosusrepo.hcprefs/preferences.changed";

//Vibration Declaration
FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);

//Variables
//////////
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

//Other:
static BOOL logSwitch = YES;

//Vibration Method Implementation
@interface FeedbackCall : NSObject
+ (void)vibrateDevice;
+ (void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity;
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
@end

//Code Control Center:
/////////////////////
//CC Toggles
%hook SBUIControlCenterButton

	-(void)_pressAction {
		
		if(haptikButtons == YES) {
 
			[FeedbackCall vibrateDevice];
		
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
		
			[FeedbackCall vibrateDevice];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
		} if(logSwitch) {
		
		%log;
		
	}
	return %orig;
	}

	-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall vibrateDevice];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
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
			
			[FeedbackCall vibrateDevice];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	-(void)_volumeSliderStoppedChanging:(id)arg1 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall vibrateDevice];
		
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
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

	
			[FeedbackCall vibrateDevice];
	
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
	-(void)beginPresentationWithTouchLocation:(CGPoint)arg1 presentationBegunHandler:(/*^block*/id)arg2 {
		
		if (haptikInduce && inducedVibrateOptions == 2) {
	
			[FeedbackCall vibrateDevice];
	
		} if(logSwitch) {
		
			%log;
		
		}
	return %orig;
	}
	
	-(void)_beginPresentation {
	
		if(haptikInduce && inducedVibrateOptions == 3) {
			
			[FeedbackCall vibrateDevice];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}
	
%end

//Code Notification Center:
//////////////////////////
//NC Clear Button:
%hook SBNotificationsClearButton

	-(void)setState:(long long)arg1 animated:(BOOL)arg2 {
		
		if(haptikClear && arg1 == 1) {
			
			[FeedbackCall vibrateDevice];
		
		} if(haptikClear && arg1 == 0) {
			
			[FeedbackCall vibrateDevice];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}

%end;

//NC Actions
%hook SBNotificationCenterLayoutViewController

-(void)todayViewSettingsViewControllerWillPresent:(id)arg1 {
		
		if(haptikClear) {
			
			[FeedbackCall vibrateDevice];
		
		} if(logSwitch) {
		
			%log;
		
		}
	%orig;
	}

%end

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
}

%ctor {
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}