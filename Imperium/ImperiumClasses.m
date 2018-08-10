#import "ImperiumClasses.h"
#import <MediaRemote/MediaRemote.h>
#import <SpringBoard/SpringBoard.h>

@implementation ImperiumGestureController

  +(void)selectGesture:(int)command {
    if(command == doNothing) {
      return; //Do nothing
    } if(command == playPause) {
      MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    }  if(command == skipForward) {
      MRMediaRemoteSendCommand(kMRNextTrack, nil);
    } if(command == skipBack) {
      MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    } if(command == nowPlaying) {
      //MusicBar by CPDigitalDarkroom, helpful to say the least
      SBApplication * currentlyPlaying = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).nowPlayingApplication;
      [[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:currentlyPlaying];
    } if(command == volumeUp) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] increaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
    } if(command == volumeDown) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] decreaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
    } if(command == volumeMute) {
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] toggleMute];
    }
    NSLog(@"|| Command # - %i ||", command);
  }

  +(void)callImpact:(int)withForceLevel {
    //Feedback thanks to CPDigitalDarkroom's MuscicBar! https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L156
    if(withForceLevel == noForce) {
      return; //Do nothing
    }
    //Allocate feedback generatorpanGesture, modified by hmm-norah on github
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:withForceLevel];
    [generator prepare];
    [generator impactOccurred];
  }

@end
