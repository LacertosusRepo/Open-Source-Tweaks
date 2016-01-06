#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>
#import <libactivator/libactivator.h>

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Preference Variables
static NSString *domainString = @"com.lacertosusrepo.homebuttonlock";
static NSString *notificationString = @"com.lacertosusrepo.homebuttonlock/preferences.changed";

//Variables
static BOOL disableMenu = NO;
static BOOL ccDisabled = NO;
static BOOL ncDisabled = NO;


//Code
%hook SpringBoard	
	-(void)handleMenuDoubleTap {
		if(disableMenu == YES) {
			return ;
		} else {
			%orig;
		}
	}
	
	-(void)_handleMenuButtonEvent {
		if(disableMenu == YES) {
			return ;
		} else {
			%orig;
		}
	}
%end

//Notifcation Center Stuff
%hook SBNotificationCenterController
	-(BOOL)gestureRecognizerShouldBegin:(id)arg1 {
		if(disableMenu == YES && ncDisabled == YES) {
				return NO;
		} else {
				%orig(arg1);
			}
		return %orig;
		}
%end

//Control Center Stuff
%hook SBControlCenterController
	-(void)_beginPresentation {
		if(disableMenu == YES && ccDisabled == YES) {
			return ;
		} else {
			%orig;
		}
	}
%end



//Activator Stuff
@interface HomeButtonLock : NSObject <LAListener>
@end
 
@implementation HomeButtonLock
 
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if(disableMenu == YES) {	//Checks if its already activated
		disableMenu = NO;
		return;
		}
		
	//Disables Interaction
		disableMenu = YES;
		 
	[event setHandled:YES]; // To prevent the default OS implementation
}
 
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {

	// Enables Interaction
		disableMenu = NO;
}

//Makes Tweak Show Up in Activator
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"HomeButtonLock";
		//Name in Activator Selection
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Disable Home Button Interaction.";
		//Decription of Activator Action
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
	return [NSArray arrayWithObjects:@"springboard", @"application", nil];
		//Where Action can be Activated
}
 
+ (void)load {
	if ([LASharedActivator isRunningInsideSpringBoard]) {
		[LASharedActivator registerListener:[self new] forName:@"com.lacertosusrepo.homebuttonlock"];
	}
}
@end



//PREFERENCES
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ccDisabled" inDomain:domainString];
	ccDisabled = (n)? [n boolValue]:YES;
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ncDisabled" inDomain:domainString];
	ncDisabled = (e)? [e boolValue]:YES;
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}