#import "FLEXManager.h"

%hook UIStatusBar
  -(void)touchesMoved:(id)arg1 withEvent:(id)arg2 {
    %orig;

    /*
     * Thanks StackOverflow <3
     * https://stackoverflow.com/questions/32771947/3d-touch-force-touch-implementation
     *
     * maximumPossibleForce - gets maximumPossibleForce from UITouch
     * force - gest the amount of force from UITouch
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
      [[NSClassFromString(@"FLEXManager") sharedManager] showExplorer];
    }
  }
%end

%ctor {
  NSString *flexPath = @"/Library/Application Support/FLEXible/FLEX.dylib";
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  /*
   * Check for the FLEX dylib, then load it
   */
  if([[NSFileManager defaultManager] fileExistsAtPath:flexPath]) {
    dlopen([flexPath UTF8String], RTLD_NOW);
  }
  [pool release];
}
