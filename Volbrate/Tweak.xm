		//---Headers---//
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>
#import "Headers.h"

		//---Variables---//
static int vibOption = 1;
static BOOL hideHUD = NO;
static BOOL useTaptic = NO;
static float timeLength = 0.05;
static float vibeIntensity = 0.75;

		//---Preferences---//
static NSString *domainString = @"com.lacertosusrepo.volbrateprefs";
static NSString *notificationString = @"com.lacertosusrepo.volbrateprefs/preferences.changed";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@implementation FeedbackCall
+(void)vibrateDevice {
	
	if(useTaptic == YES) {
	
		[[UIDevice currentDevice]._tapticEngine actuateFeedback:1];
		
	} else {
		
		[FeedbackCall vibrateDeviceForTimeLengthIntensity:timeLength vibrationIntensity:vibeIntensity];

	}
		
}

+(void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity {

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

		//---Global Vars---//
	static BOOL volMax;
	static BOOL volMin;
	static float x;

		//---Code---//	
%hook VolumeControl
	
	-(void)increaseVolume {
			
		if(vibOption == 2) {
				
			[FeedbackCall vibrateDevice];
				
		} if(vibOption == 1 && volMax == YES){

			[FeedbackCall vibrateDevice];
				
		}
		
	%orig;
	}
			
	-(void)decreaseVolume {
	
		if(vibOption == 2) {
				
			[FeedbackCall vibrateDevice];
				
		} if(vibOption == 1 && volMin == YES){
				
			[FeedbackCall vibrateDevice];
				
		}
				
	%orig;				
	}
		
	-(float)volume {

		x = %orig;

		if(x == 0){
				
			volMin = YES;
				
		} if(x == 1){
				
			volMax = YES;
			
		} if(x > 0 && x < 1) {
				
			volMin = NO;
			volMax = NO;
				
		}
			
	return %orig;
	}

	-(void)_presentVolumeHUDWithMode:(int)arg1 volume:(float)arg2 {	
	
		if(hideHUD == YES) {
			
			return ;
			
		}
		
	%orig;
	}

%end			
			
		//---Preferences---//
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"vibOption" inDomain:domainString];
	vibOption = (a)? [a intValue]:1;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"timeLength" inDomain:domainString];
	timeLength = (b)? [b floatValue]:0.05;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"vibeIntensity" inDomain:domainString];
	vibeIntensity = (c)? [c floatValue]:0.75;
	
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideHUD" inDomain:domainString];
	hideHUD = (d)? [d boolValue]:NO;
	
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useTaptic" inDomain:domainString];
	useTaptic = (e)? [e boolValue]:NO;

}

%ctor {
		
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
