//Thanks to ZaneH's tweak UnsplashWallpaper
//Headers
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

//Variables
static BOOL obscuriteSwitch = YES;
static BOOL useWallpaper = YES;
static BOOL useAutoLock = NO;
static int blurOption = 3;
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
extern "C" CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

UIWindow* windowBlur;
UIWindow* windowWallpaper;
UIImageView* homeBG;
UIBlurEffect* blurEffect;
static BOOL blurShouldShow;
UITapGestureRecognizer *tap;

%hook SBBacklightController

	-(void)_userEventsDidIdle {
		
		windowBlur.hidden = YES;
		windowWallpaper.hidden = YES;
	
		if(obscuriteSwitch == YES && blurShouldShow == YES) {
			
			//HBLogInfo(@"Device Idle");
			tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaChanging)];
			
			windowBlur = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			windowBlur.backgroundColor = [UIColor clearColor];
			windowBlur.hidden = NO;
			windowBlur.alpha = 0;
			windowBlur.windowLevel = UIWindowLevelStatusBar;
		
			[windowBlur addGestureRecognizer:tap];
			//HBLogInfo(@"Initializing Blur");
			
			//Get Homescreen Wallpaper
			if(useWallpaper == YES && obscuriteSwitch) {
				
				//HBLogInfo(@"Getting Homescreen Wallpaper);
				
				windowWallpaper = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
				windowWallpaper.backgroundColor = [UIColor clearColor];
				windowWallpaper.hidden = NO;
				windowWallpaper.alpha = 0;
				windowWallpaper.windowLevel = UIWindowLevelStatusBar;
				[windowWallpaper addGestureRecognizer:tap];

				NSData *homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
				CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeWallpaperData;
				NSArray *imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
				UIImage *homeWallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
				
				homeBG = [[UIImageView alloc] initWithImage:homeWallpaper];
				homeBG.frame = windowWallpaper.bounds;
				[windowWallpaper addSubview:homeBG];
				
			//Extra Light Blur
			} if(blurOption == 1 && obscuriteSwitch) {
				
				//HBLogInfo(@"Extra Light Blur Chosen");
			
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
		
				UIVisualEffectView *visualEffect;
				visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		
				visualEffect.frame = windowBlur.bounds;
				[windowBlur addSubview:visualEffect];
		
			//Light Blur
			} if(blurOption == 2 && obscuriteSwitch) {
			
				//HBLogInfo(@"Light Blur Set");
				
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		
				UIVisualEffectView *visualEffect;
				visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		
				visualEffect.frame = windowBlur.bounds;
				[windowBlur addSubview:visualEffect];
			
			//Dark Blur
			} if(blurOption == 3 && obscuriteSwitch) {
			
				//HBLogInfo(@"Dark Blur Set");
				
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
		
		//HBLogInfo(@"Screen Interacted With");
		blurShouldShow = YES;
		%orig;
	
	}
	
%new

	-(void)alphaChanging {
		
		//HBLogInfo(@"Alpha Changing");
		[UIView animateWithDuration:blurTransition
                     animations:^
						{
						if(windowBlur.alpha == 0 && blurShouldShow == NO) {
							
							//HBLogInfo(@"Alpha Increasing");
							[windowBlur setAlpha:blurAlpha];
							[windowWallpaper setAlpha:1.0f];
						
						} if(windowBlur.alpha == blurAlpha && blurShouldShow == YES) {
							
							//HBLogInfo(@"Alpha Decreasing");
							[windowBlur setAlpha:0.0f];
							[windowWallpaper setAlpha:0.0f];
						}
					}
		
				completion:^(BOOL finished)
						{
						if(windowBlur.alpha == blurAlpha && useAutoLock == YES){
						
							[[%c(SBBacklightController) sharedInstance] startFadeOutAnimationFromLockSource:1];
						
						}
					}];
	}
	
%end

%hook SpringBoard

	-(BOOL)isLocked {
		
		if(YES) {
			
			windowBlur.hidden = YES;
			windowWallpaper.hidden = YES;
			
		}
	return %orig;
	}
	
%end

//Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"obscuriteSwitch" inDomain:domainString];
	obscuriteSwitch = (a)? [a boolValue]:YES;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useWallpaper" inDomain:domainString];
	useWallpaper = (b)? [b boolValue]:YES;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurOption" inDomain:domainString];
	blurOption = (c)? [c intValue]:3;
	
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurAlpha" inDomain:domainString];
	blurAlpha = (d)? [d floatValue]:0.85;
	
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurTransition" inDomain:domainString];
	blurTransition = (e)? [e floatValue]:1.5;
	
	NSNumber *f = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useAutoLock" inDomain:domainString];
	useAutoLock = (f)? [f useAutoLock]:NO;

}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
