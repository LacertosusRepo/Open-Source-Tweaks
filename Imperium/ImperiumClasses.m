#import "ImperiumClasses.h"
#import <MediaRemote/MediaRemote.h>
#import <SpringBoard/SpringBoard.h>

@implementation ImperiumGestureController

  +(void)selectGesture:(int)command withForceLevel:(int)forceLevel {
    if(command == doNothing) {
      return; //Do nothing
    }

    [self callImpact:forceLevel];
    if(command == playPause) {
      MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    } else if(command == skipForward) {
      MRMediaRemoteSendCommand(kMRNextTrack, nil);
    } else if(command == skipBack) {
      MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    } else if(command == nowPlaying) {
      //MusicBar by CPDigitalDarkroom, helpful to say the least
      SBApplication * currentlyPlaying = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).nowPlayingApplication;
      [[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:currentlyPlaying];
    } else if(command == volumeUp) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] increaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
    } else if(command == volumeDown) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] decreaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
    } else if(command == volumeMute) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] toggleMute];
    } else {
      NSLog(@"Imperium - No action selected! HOW?");
    }
    NSLog(@"|| Command # - %i || Force - %i ||", command, forceLevel);
  }

  +(void)callImpact:(int)withForceLevel {
    //Feedback thanks to CPDigitalDarkroom's MuscicBar! https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L156
    if(withForceLevel == noForce) {
      return; //Do nothing
    }
    //Allocate feedback generatorpanGesture, modidified by hmm-norah on github
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:withForceLevel];
    [generator prepare];
    [generator impactOccurred];
  }

@end
