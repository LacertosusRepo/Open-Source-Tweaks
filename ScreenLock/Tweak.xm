#import <libactivator/libactivator.h>

//Variables
static BOOL canInteract = YES;			//Master Lock

//Tweak Code
//Disables Screen Interaction
%hook UIView
-(BOOL)isUserInteractionEnabled {
	if(canInteract == NO) {
		return NO;
	} else {
		%orig;
	}
	return %orig;
}

-(void)setUserInteractionEnabled:(BOOL)arg1 {
		if(canInteract == NO) {
		%orig(NO);
	} else {
		%orig;
	}
}
%end


//Disables Volume Control
%hook VolumeControl
-(void)_changeVolumeBy:(float)arg1 {
	if(canInteract == NO) {
		%orig(nil);
	} else {
		%orig;
	}
}
%end


//Disables Screen Orientation
%hook SBOrientationLockManager
-(BOOL)_effectivelyLocked {
	if(canInteract == NO) {
		return YES;
	} else {
		return %orig;
	}
	return %orig;
}

-(void)_updateLockStateWithOrientation:(long long)arg1 forceUpdateHID:(BOOL)arg2 changes:(/*^block*/id)arg3 {
	if(canInteract == NO) {
		%orig(arg1,NO,arg3);
	} else { 
		%orig;
	}
}

-(BOOL)lockOverrideEnabled {
	if(canInteract == NO) {
		return NO;
	} else {
		%orig;
	}
	return %orig;
}

-(BOOL)isLocked {
	if(canInteract == NO) {
		return YES;
	} else {
		%orig;
	}
	return %orig;
}
%end

%hook SBUIActiveOrientationObserver
-(void)activeInterfaceOrientationWillChangeToOrientation:(long long)arg1 {
	if(canInteract == NO) {
		%orig(nil);
	} else {
		%orig;
	}
}
%end


//Disables Home Button
// NOTE: Makes events using home button useless
//%hook SpringBoard
//-(void)_setMenuButtonTimer:(id)arg1 {
//	if(canInteract == NO) {
//		return ;
//	} else {
//		%orig;
//	}
//}

//Activator Stuff
@interface ScreenLock : NSObject <LAListener>
@end
 
@implementation ScreenLock
 
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if(canInteract == NO) {	//Checks if its already activated
		canInteract = YES;
		return;
		}
		
	//Disables Interaction
		canInteract = NO;
		 
	[event setHandled:YES]; // To prevent the default OS implementation
}
 
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {

	// Enables Interaction
		canInteract = YES;
}

//Makes Tweak Show Up in Activator
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"ScreenLock";
		//Name in Activator Selection
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Disable screen interaction";
		//Decription of Activator Action
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
		//Where Action can be Activated
}
 
+ (void)load {
	if ([LASharedActivator isRunningInsideSpringBoard]) {
		[LASharedActivator registerListener:[self new] forName:@"com.lacertosus.screenlock"];
	}
}
@end