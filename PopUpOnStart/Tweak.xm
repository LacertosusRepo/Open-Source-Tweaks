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

UIAlertController *alert;
static NSString *titleText = @"Respring Successful";
static NSString *messageText = @"Device Ready to Use";
static NSString *cancelText = @"Confirm";

//Tweak Code
%hook SpringBoard

  -(void)applicationDidFinishLaunching:(id)application {
		
		if(enableAlert == YES && firstUse == NO) {
		
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:titleText
								      message:messageText
							  	      preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelText
							       style:UIAlertActionStyleDefault
							       handler:^(UIAlertAction * action)
                    {
                        [alert dismissViewControllerAnimated:YES completion:nil];                          
                    }];
					
			[alert addAction:cancel];

		} if(enableAlert == YES && firstUse == YES) {

			//This message will appear on first respring
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thanks For Installing"
								      message:@"Configure options if settings!"
							  	      preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok!"
							       style:UIAlertActionStyleDefault
							       handler:^(UIAlertAction * action)
                    {
                        [alert dismissViewControllerAnimated:YES completion:nil];                          
                    }];
	
			firstUse = NO;
			[alert addAction:cancel];
		}
	
	[self presentViewController:alert animated:YES completion:nil];
	
	%orig;
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

	//Register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
