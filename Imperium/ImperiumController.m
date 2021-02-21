#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <SpringBoard/SpringBoard.h>
#import "MediaRemote.h"
#import "ImperiumController.h"
#import "ImperiumClasses.h"

  SBApplication *nowPlayingApplication;

@implementation ImperiumController
  +(void)gestureWithCommand:(NSInteger)command {
    switch ((int)command) {
      case doNothing:
      return;
      break;

      case togglePlayPause:
      MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
      break;

      case skipForward:
      MRMediaRemoteSendCommand(kMRNextTrack, nil);
      break;

      case skipBack:
      MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
      break;

      case openNowPlaying:
      //MusicBar by CPDigitalDarkroom
      //https://github.com/CPDigitalDarkroom/MusicBar/blob/master/CPDDMBBarView.m#L176
      nowPlayingApplication = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).nowPlayingApplication;
      [[NSClassFromString(@"SBUIController") sharedInstance] _activateApplicationFromAccessibility:nowPlayingApplication];
      break;

      case volumeUp:
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] increaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
      break;

      case volumeDown:
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] decreaseVolume];
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] cancelVolumeEvent];
      break;

      case volumeMute:
      [[NSClassFromString(@"VolumeControl") sharedVolumeControl] toggleMute];
      break;
    }
  }

  +(void)feedbackWithForce:(NSInteger)force {
    if(force <= 2) {
      UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(int)force];
      [impactFeedback prepare];
      [impactFeedback impactOccurred];
    } if(force == 4) {
      AudioServicesPlaySystemSound(1519);
    }
  }
@end
