#import "FLEXManager.h"

%hook UIStatusBar
  -(void)touchesMoved:(id)arg1 withEvent:(id)arg2 {
    %orig;

    /*
     * Thanks StackOverflow <3
     * https://stackoverflow.com/questions/32771947/3d-touch-force-touch-implementation
     *
     * maximumPossibleForce - gets maximumPossibleForce from UITouch
     * force - gets the amount of force from UITouch
     * normalizedForce - normalize the total force
     * forceThreshold - custom set force amount that is needed to activate FLEX
     */
    UITouch *touch = [arg1 anyObject];
    CGFloat maximumPossibleForce = touch.maximumPossibleForce;
    CGFloat force = touch.force;
    CGFloat normalizedForce = force/maximumPossibleForce;
    CGFloat forceThreshold = 0.65;

    //check if force is enough to pass the threshold
    if(normalizedForce >= forceThreshold) {
      [[%c(FLEXManager) sharedManager] showExplorer];
    }
  }
%end

%hook UIWindow
  //Allows the flex window on the lockscreen
  -(BOOL)_isSecure {
    return NO;
  }
%end

%ctor {
  NSString *flexPath = @"/Library/Application Support/FLEXible/FLEX.dylib";

  /*
   * Check for the FLEX dylib, then load it
   */
  if([[NSFileManager defaultManager] fileExistsAtPath:flexPath]) {
    dlopen([flexPath UTF8String], RTLD_NOW);
  }
}
