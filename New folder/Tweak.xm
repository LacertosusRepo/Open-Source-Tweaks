#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>

//Audio Variables
	AVAudioPlayer *audioPlayer;
	NSString *soundPath = [[NSBundle bundleWithPath:@"/Library/Application Support/SoundSpring"] pathForResource:@"Hello" ofType:@"mp3"];
    NSURL *soundURL = [[NSURL alloc] initFileURLWithPath:soundPath];
	
//Variables
static BOOL resetRespring = NO;

//Code
%hook SpringBoard

	-(void)applicationDidFinishLaunching:(id)application {
			
		%orig;
		resetRespring = YES;	
	}
%end

%hook SBLockScreenManager
	-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
		if(resetRespring == YES) {
			[audioPlayer stop];
		
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1;
		
			[audioPlayer play];
			
			resetRespring = NO;
		} else {
			%orig;
		}
	}
%end