		//---Headers---//
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

		//---Variables---//
static int volVibrationOptions = 1;
static float timeLength = 0.05;
static float vibeIntensity = 0.75;

		//---Preferences---//
static NSString *domainString = @"com.lacertosusrepo.volbrateprefs";
static NSString *notificationString = @"com.lacertosusrepo.volbrateprefs/preferences.changed";

@interface NSUserDefaults (UFS_Category)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

		//---Vibration Implementation---//
FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);

@interface FeedbackCall : NSObject
+(void)vibrateDevice;
+(void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity;
@end

		//---Vibration Method---//
@implementation FeedbackCall
+(void)vibrateDevice {	
	[FeedbackCall vibrateDeviceForTimeLengthIntensity:timeLength vibrationIntensity:vibeIntensity];
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
			
			//Calls FeedbackCall to vibrate EVERY volume increase
			if(volVibrationOptions == 2) {
				
				[FeedbackCall vibrateDevice];
				
				
			//Calls FeedbackCall to vibrate only at max volume
			} if(volVibrationOptions == 1 && volMax == YES){
				
				[FeedbackCall vibrateDevice];
				
			} else {
				
				%orig;
				
			}
		}
			
		-(void)decreaseVolume {

			//Calls FeedbackCall to vibrate EVERY volume decrease
			if(volVibrationOptions == 2) {
				
				[FeedbackCall vibrateDevice];

			//Calls FeedbackCall to vibrate only at min volume
			} if(volVibrationOptions == 1 && volMin == YES){
				
				[FeedbackCall vibrateDevice];
				
			} else {
				
				%orig;
				
			}
		}
		
		//These are just simple if statements to figure what the volume is at
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
	%end
	
		//---Preferences---//
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"volVibrationOptions" inDomain:domainString];
	volVibrationOptions = (a)? [a intValue]:1;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"timeLength" inDomain:domainString];
	timeLength = (b)? [b floatValue]:0.05;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"vibeIntensity" inDomain:domainString];
	vibeIntensity = (c)? [c floatValue]:0.75;

}

%ctor {
		
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}