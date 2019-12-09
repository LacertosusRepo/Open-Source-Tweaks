#import "Clauditis.h"

  UITapGestureRecognizer *tapGesture;

%hook SBHomeScreenViewController
  -(void)viewDidLoad {
      //first let the method set the frame
    %orig;

      //check if the gesture exists first
    if(tapGesture == nil) {
        //if it doesnt, create one
      tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDevice)];
        //set the number of taps
      tapGesture.numberOfTapsRequired = 2;
        //add to the view
      [self.view addGestureRecognizer:tapGesture];
    }
  }

  //add a new method to the class
%new
  -(void)lockDevice {
      //In iOS 12 SBIconController has the isEditing property we can check, in iOS 13 this has been moved to SBHIconManager
      //Method to lock device - //https:www.reddit.com/r/jailbreakdevelopers/comments/7t4u2m/lock_device_on_ios_11/dtbi750/
      //Check if device is at least on iOS 13.0.0
    if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        //If so, use SBHIconManager's isEditing property
      if(![[[%c(SBIconController) sharedInstance] iconManager] isEditing]) {
        [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];
      }

    } else {
        //If not on iOS 13, use SBIconController's isEditing property
      if(![[%c(SBIconController) sharedInstance] isEditing]) {
        [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];
      }
    }
  }
%end
