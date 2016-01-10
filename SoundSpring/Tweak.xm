#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Audio Variables

	AVAudioPlayer *audioPlayer;
	NSURL *witfURL;
	NSURL *adeleURL;
	NSURL *kobeURL;
	
	
	//MLG
	NSString *witfPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"WITF" ofType:@"mp3"];
	
	//Adele
	NSString *adelePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"ADELE" ofType:@"mp3"];

	//Kobe
	NSString *kobePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"KOBE" ofType:@"mp3"];

	
//Variables
static BOOL resetRespring = NO;
static int soundOption = 1;

static NSString *domainString = @"com.lacertosusrepo.soundspring";
static NSString *notificationString = @"com.lacertosusrepo.soundspring/preferences.changed";

//Code
%hook SpringBoard
	-(void)applicationDidFinishLaunching:(id)application {
		%orig;
		resetRespring = YES;	
	}
%end

%hook SBLockScreenManager
	-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
			%orig;
			
		if(resetRespring == YES && soundOption == 0) {
			
			witfURL = [[NSURL alloc] initFileURLWithPath:witfPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:witfURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
		
			[audioPlayer play];
		} if(resetRespring == YES && soundOption == 1) {
			
			adeleURL = [[NSURL alloc] initFileURLWithPath:adelePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:adeleURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
		
			[audioPlayer play];
		} if(resetRespring == YES && soundOption == 2) {
			
			kobeURL = [[NSURL alloc] initFileURLWithPath:kobePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:kobeURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
		} else {
			%orig;
		}
	}

%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"soundOption" inDomain:domainString];
	soundOption = (a)? [a intValue]:1;
}
	
%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}