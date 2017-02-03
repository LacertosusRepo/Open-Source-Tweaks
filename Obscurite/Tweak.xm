//Headers
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

//Variables
static BOOL obscuriteSwitch = YES;
static int blurOption = 1;
static float blurAlpha = 0.85;
static float blurTransition = 1.5;

//Preference Variables
static NSString *domainString = @"com.lacertosusrepo.obscuriteprefs";
static NSString *notificationString = @"com.lacertosusrepo.obscuriteprefs/preferences.changed";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Other Variables
UIWindow* windowBlur;
UIBlurEffect * blurEffect;
static BOOL blurShouldShow;
UITapGestureRecognizer *tap;

%hook SBBacklightController

	-(void)_userEventsDidIdle {
	
		if(obscuriteSwitch == YES && blurShouldShow == YES) {
			
			HBLogInfo(@"Device Idle");
			tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaChanging)];
			
			windowBlur = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			windowBlur.backgroundColor = [UIColor clearColor];
			windowBlur.hidden = NO;
			windowBlur.alpha = 0;
			windowBlur.windowLevel = UIWindowLevelStatusBar;
		
			[windowBlur addGestureRecognizer:tap];
			HBLogInfo(@"Initializing Blur");
			
			//Light Blur
			if(blurOption == 1 && obscuriteSwitch) {
				
				HBLogInfo(@"Light Blur Chosen");
			
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		
				UIVisualEffectView *visualEffect;
				visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		
				visualEffect.frame = windowBlur.bounds;
				[windowBlur addSubview:visualEffect];
		
			//Dark Blur
			} if(blurOption == 2 && obscuriteSwitch) {
			
				HBLogInfo(@"Dark Blur Set");
				
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		
				UIVisualEffectView *visualEffect;
				visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		
				visualEffect.frame = windowBlur.bounds;
				[windowBlur addSubview:visualEffect];
		
			}		
		
		blurShouldShow = NO;
		
		[NSTimer scheduledTimerWithTimeInterval:0.5
										 target:self
									   selector:@selector(alphaChanging)
									   userInfo:nil
										repeats:NO];		
		}

	}
	
	-(void)_sendResetIdleTimerAction {
		
		HBLogInfo(@"Screen Interacted With");
		blurShouldShow = YES;
		
		%orig;
	
	}
	
%new

	-(void)alphaChanging {
		
		HBLogInfo(@"Alpha Changing");
		[UIView animateWithDuration:blurTransition
                     animations:^
						{
						if(windowBlur.alpha == 0 && blurShouldShow == NO) {
							
							HBLogInfo(@"Alpha Increasing");
							[windowBlur setAlpha:blurAlpha];
						
						} if(windowBlur.alpha == blurAlpha && blurShouldShow == YES) {
							
							HBLogInfo(@"Alpha Decreasing");
							[windowBlur setAlpha:0.0f];
							
						}
					}
		
				completion:nil];
	}
	
%end

//Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"obscuriteSwitch" inDomain:domainString];
	obscuriteSwitch = (a)? [a boolValue]:YES;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurOption" inDomain:domainString];
	blurOption = (b)? [b intValue]:1;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurAlpha" inDomain:domainString];
	blurAlpha = (c)? [c floatValue]:0.85;
	
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurTransition" inDomain:domainString];
	blurTransition = (d)? [d floatValue]:1.5;

}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}