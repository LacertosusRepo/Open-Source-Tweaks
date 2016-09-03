/*
////================================////
				Oh Hello!
  This is my tweak HaptikCenter, Enjoy
			 
			 ~LacertosusDeus
				
		    If you use anything, 
		 please credit the author.
////================================////
*/

//Headers
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>


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
static float timeLength = 0.05;
static BOOL haptikButtons = YES;
static BOOL haptikSliders = YES;
static int sliderVibrateOptions = 2;

//Vibration Method Implementation
@interface FeedbackCall : NSObject
+ (void)vibrateDevice;
+ (void)vibrateDeviceForTimeLength:(CGFloat)timeLength;
@end

@implementation FeedbackCall
+ (void)vibrateDevice {
		[FeedbackCall vibrateDeviceForTimeLength:timeLength];
}

+ (void)vibrateDeviceForTimeLength:(CGFloat)timeLength {
			NSMutableDictionary* dict = [NSMutableDictionary dictionary];
			NSMutableArray* arr = [NSMutableArray array];
    
			[arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for time length
			[arr addObject:[NSNumber numberWithInt:timeLength*1000]];
		
			[arr addObject:[NSNumber numberWithBool:NO]];
			[arr addObject:[NSNumber numberWithInt:50]];
    
			[dict setObject:arr forKey:@"VibePattern"];
			[dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    
			AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dict);
}
@end

//Code:
//CC Toggles
%hook SBUIControlCenterButton

	-(void)_pressAction {
		
		if(haptikButtons == YES) {
 
			[FeedbackCall vibrateDevice];
	
			%orig;
		
		} else {
			
			%orig;
		
		}
	
	}
	
%end

//CC Brightnedd Slider
%hook SBUIControlCenterSlider

	-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 1) {
		
			[FeedbackCall vibrateDevice];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
		}
	return %orig;
	}

	-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall vibrateDevice];
			
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
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
			
		}
	%orig;
	}
	
	-(void)_volumeSliderStoppedChanging:(id)arg1 {
		
		if(haptikSliders == YES && sliderVibrateOptions == 2) {
		
			[FeedbackCall vibrateDevice];
		
		} if(haptikSliders == YES && sliderVibrateOptions == 3) {
		
			[FeedbackCall vibrateDevice];
			
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
	
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"timeLength" inDomain:domainString];
	timeLength = (e)? [e floatValue]:0.05;
	
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}