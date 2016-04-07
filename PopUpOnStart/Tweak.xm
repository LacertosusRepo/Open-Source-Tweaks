#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Preference Variables
static NSString *domainString = @"com.lacertosusrepo.popuponstart";
static NSString *notificationString = @"com.lacertosusrepo.popuponstart/preferences.changed";

//Variables
static BOOL enableAlert = YES;
static BOOL firstUse = YES;

static NSString *titleText = @"Respring Successful";
static NSString *messageText = @"Device Ready to Use";
static NSString *cancelText = @"Confirm";

//Tweak Code
%hook SpringBoard

  -(void)applicationDidFinishLaunching:(id)application {
		
		%orig;
		
		if(enableAlert == YES) {

			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:titleText
					message:messageText
					delegate:self
					cancelButtonTitle:cancelText
					otherButtonTitles:nil];
			
				[alert show];
				[alert release];
		} if(enableAlert == YES && firstUse == YES) {

			//This message will appear on first respring
			UIAlertView* alert1 = [[UIAlertView alloc] initWithTitle:@"Thank You For Installing!"
					message:@"Configure This Message in Settings!"
					delegate:self
					cancelButtonTitle:@"Confirm"
					otherButtonTitles:nil];
			
				[alert1 show];
				[alert1 release];
				
				firstUse = NO;
		}
	}
%end

//Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enableAlert" inDomain:domainString];
	enableAlert = (a)? [a boolValue]:YES;
	NSString *b = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"titleText" inDomain:domainString];
	titleText = (b)? (b):titleText;
	NSString *c = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"messageText" inDomain:domainString];
	messageText = (c)? (c):messageText;
	NSString *d = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"cancelText" inDomain:domainString];
	cancelText = (d)? (d):cancelText;
}

//Receiver for preferences 
%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
