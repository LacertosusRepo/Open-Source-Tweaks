  //--Class--//
@interface SpringBoard : NSObject
-(void)_simulateLockButtonPress;
@end

  //--Vars--//
  UITapGestureRecognizer * tapGesture;

%hook SBHomeScreenView
  -(void)setFrame:(CGRect)arg1 {
      //first let the method set the frame
    %orig;

      //check if the gesture exists first
    if(tapGesture == nil) {
        //if it doesnt, create one
      tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDevice)] autorelease];
        //set the number of taps
      tapGesture.numberOfTapsRequired = 2;
        //add to the view
      [self addGestureRecognizer:tapGesture];
    }
  }
  //add a new method to the class
%new

  -(void)lockDevice {
      //https://www.reddit.com/r/jailbreakdevelopers/comments/7t4u2m/lock_device_on_ios_11/dtbi750/
    [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];
  }
%end
