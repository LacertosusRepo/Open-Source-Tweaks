#import <libactivator/libactivator.h>

//Variables
static BOOL volLock = NO;			//Master Lock

//Activator Stuff
@interface ScreenLock : NSObject <LAListener>
@end
 
@implementation ScreenLock
 
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if(volLock == YES) {	//Checks if its already activated
		volLock = NO;
		return;
		}
		
	//Disables Buttons
		volLock = YES;
		 
	[event setHandled:YES]; // To prevent the default OS implementation
}
 
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {

	// Enables Interaction
		volLock = NO;
}

//Makes Tweak Show Up in Activator
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"VolumeLock";
		//Name in Activator Selection
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Disable volume buttons";
		//Description of Activator Action
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
		//Where Action can be Activated
}
 
+ (void)load {
	if ([LASharedActivator isRunningInsideSpringBoard]) {
		[LASharedActivator registerListener:[self new] forName:@"com.lacertosusrepo.volumelock"];
	}
}
@end

//Tweak Code
%hook VolumeControl
-(void)_changeVolumeBy:(float)arg1 {
	if(volLock == YES) {
		%orig(nil);
	} else {
		%orig;
	}
}
%end