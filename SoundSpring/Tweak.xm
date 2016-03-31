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
	NSURL *adeleURL;
	NSURL *bassURL;
	NSURL *cenaURL;
	NSURL *kobeURL;
	NSURL *magicURL;
	NSURL *milkURL;
	NSURL *nastyURL;
	NSURL *supriseURL;
	NSURL *timeURL;
	NSURL *weedURL;
	NSURL *witfURL;


//Sounds
	//Adele
	NSString *adelePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"ADELE" ofType:@"mp3"];
	//Bass Drop
	NSString *bassPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"BASS" ofType:@"wav"];
	//Cena
	NSString *cenaPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"CENA" ofType:@"mp3"];
	//Kobe
	NSString *kobePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"KOBE" ofType:@"mp3"];
	//Peter Magic
	NSString *magicPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"MAGIC" ofType:@"wav"];
	//Milk
	NSString *milkPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"MILK" ofType:@"mp3"];
	//Thats Nasty
	NSString *nastyPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"NASTY" ofType:@"mp3"];
	//Suprise
	NSString *suprisePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"SUPRISE" ofType:@"wav"];
	//Aint Nobody Got Time
	NSString *timePath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"TIME" ofType:@"wav"];
	//Weed
	NSString *weedPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"WEED" ofType:@"mp3"];
	//What In The Fuck
	NSString *witfPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"WITF" ofType:@"mp3"];
	

//Variables
static BOOL everyUnlock = NO;
static BOOL resetRespring = NO;
static int soundOption = 0;

static NSString *domainString = @"com.lacertosusrepo.soundspring";
static NSString *notificationString = @"com.lacertosusrepo.soundspring/preferences.changed";


//Code
%hook SpringBoard
	-(void)applicationDidFinishLaunching:(id)application {
		%orig;
		resetRespring = YES;	
		 [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
	}
%end

%hook SBLockScreenManager
	-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
			
			%orig;
			[NSURL release];
			
		if(resetRespring == YES && soundOption == 0) {
			
			adeleURL = [[NSURL alloc] initFileURLWithPath:adelePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:adeleURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 1) {
			
			bassURL = [[NSURL alloc] initFileURLWithPath:bassPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bassURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 2) {
			
			cenaURL = [[NSURL alloc] initFileURLWithPath:cenaPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:cenaURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 3) {
			
			kobeURL = [[NSURL alloc] initFileURLWithPath:kobePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:kobeURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
		
		} if(resetRespring == YES && soundOption == 4) {
			
			magicURL = [[NSURL alloc] initFileURLWithPath:magicPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:magicURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
		
		} if(resetRespring == YES && soundOption == 5) {
			
			milkURL = [[NSURL alloc] initFileURLWithPath:milkPath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:milkURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
		
		} if(resetRespring == YES && soundOption == 6) {
			
			nastyURL = [[NSURL alloc] initFileURLWithPath:nastyPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:nastyURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 7) {
			
			supriseURL = [[NSURL alloc] initFileURLWithPath:suprisePath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:supriseURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 8) {
			
			timeURL = [[NSURL alloc] initFileURLWithPath:timePath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:timeURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 9) {
			
			weedURL = [[NSURL alloc] initFileURLWithPath:weedPath];
		
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:weedURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(resetRespring == YES && soundOption == 10) {
			
			witfURL = [[NSURL alloc] initFileURLWithPath:witfPath];
		
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:witfURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(everyUnlock == YES) {
			resetRespring = YES;
		} if(everyUnlock == NO) {
			resetRespring = NO;
		}
	[NSURL release];
}

%end

void playCurrentSound() {
		if(soundOption == 0) {
			
			adeleURL = [[NSURL alloc] initFileURLWithPath:adelePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:adeleURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(soundOption == 1) {
			
			bassURL = [[NSURL alloc] initFileURLWithPath:bassPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bassURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(soundOption == 2) {
			
			cenaURL = [[NSURL alloc] initFileURLWithPath:cenaPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:cenaURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(soundOption == 3) {
			
			kobeURL = [[NSURL alloc] initFileURLWithPath:kobePath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:kobeURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
		
		} if(soundOption == 4) {
			
			magicURL = [[NSURL alloc] initFileURLWithPath:magicPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:magicURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
		
		} if(soundOption == 5) {
			
			milkURL = [[NSURL alloc] initFileURLWithPath:milkPath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:milkURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
		
		} if(soundOption == 6) {
			
			nastyURL = [[NSURL alloc] initFileURLWithPath:nastyPath];
			
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:nastyURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
			
			[audioPlayer play];
			
		} if(soundOption == 7) {
			
			supriseURL = [[NSURL alloc] initFileURLWithPath:suprisePath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:supriseURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(soundOption == 8) {
			
			timeURL = [[NSURL alloc] initFileURLWithPath:timePath];

			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:timeURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(soundOption == 9) {
			
			weedURL = [[NSURL alloc] initFileURLWithPath:weedPath];
		
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:weedURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		} if(soundOption == 10) {
			
			witfURL = [[NSURL alloc] initFileURLWithPath:witfPath];
		
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:witfURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;

			[audioPlayer play];
			
		}
	[NSURL release];
}

void stopCurrentSound() {
	[audioPlayer release];
}

//Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"soundOption" inDomain:domainString];
	soundOption = (a)? [a intValue]:1;

	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"everyUnlock" inDomain:domainString];
	everyUnlock = (b)? [b boolValue]:YES;
}
	
%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)playCurrentSound, CFSTR("com.lacertosusrepo.soundspring-playcurrentsound"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)stopCurrentSound, CFSTR("com.lacertosusrepo.soundspring-stopcurrentsound"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);


	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}