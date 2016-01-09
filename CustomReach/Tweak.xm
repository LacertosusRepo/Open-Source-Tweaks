#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *domainString = @"com.lacertosusrepo.customreach";
static NSString *notificationString = @"com.lacertosusrepo.customreach/preferences.changed";

static BOOL ReachEnabled = YES; 
static BOOL ReachintActiveEnabled = YES;
static BOOL ReachTimerEnabled = YES;
static BOOL TapforTriggerEnabled = YES;
static BOOL YOffsetEnabled = YES;
static BOOL StiffEnabled = YES;

static int ReachintActive = 10;
static int ReachTimer = 10;
static int NumberofTaps = 2;
static int YOffset = 20;
static int StiffNumber = 1;

%hook SBReachabilitySettings

-(BOOL)allowOnAllDevices {
	return ReachEnabled;
	}
	
-(double)reachabilityInteractiveKeepAlive {
	if(ReachintActiveEnabled) {
		return ReachintActive;
	} else {
		return %orig;
	}
}

-(double)reachabilityDefaultKeepAlive {
	if(ReachTimerEnabled) {
		return ReachTimer;
	} else {
		return %orig;
	}
}

-(unsigned long long)numberOfTapsForTapTrigger {
	if(TapforTriggerEnabled) {
		return NumberofTaps;
	} else {
		return 2;
	}
}

-(double)yOffsetFactor {
	if(YOffsetEnabled) {
		return YOffset;
	} else {
		return %orig;
	}
}
	
-(double)stiffness {
	if(StiffEnabled) {
		return StiffNumber;
	} else {
		return %orig;
	}
}

%end

//PREFERENCES
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ReachEnabled" inDomain:domainString];
	ReachEnabled = (a)? [a boolValue]:YES;
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ReachintActiveEnabled" inDomain:domainString];
	ReachintActiveEnabled = (b)? [b boolValue]:YES;
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ReachTimerEnabled" inDomain:domainString];
	ReachTimerEnabled = (c)? [c boolValue]:YES;
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TapforTriggerEnabled" inDomain:domainString];
	TapforTriggerEnabled = (d)? [d boolValue]:YES;
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"YOffsetEnabled" inDomain:domainString];
	YOffsetEnabled = (e)? [e boolValue]:YES;
	NSNumber *f = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"StiffEnabled" inDomain:domainString];
	StiffEnabled = (f)? [f boolValue]:YES;
	
	NSNumber *g = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ReachintActive" inDomain:domainString];
	ReachintActive = (g)? [g intValue]:nil;
	NSNumber *h = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ReachTimer" inDomain:domainString];
	ReachTimer = (h)? [h intValue]:nil;
	NSNumber *i = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"NumberofTaps" inDomain:domainString];
	NumberofTaps = (i)? [i intValue]:nil;
	NSNumber *j = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"YOffset" inDomain:domainString];
	YOffset = (j)? [j intValue]:nil;
	NSNumber *k = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"StiffNumber" inDomain:domainString];
	StiffNumber = (k)? [k intValue]:nil;
	NSLog(@"Preferences LAAA");
}
	
%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}