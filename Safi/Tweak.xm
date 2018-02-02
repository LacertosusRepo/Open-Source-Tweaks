	// [Headers] -------------------------------------------------------
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

	// [Prefs] ---------------------------------------------------------
static NSString *domainString = @"com.lacertosusrepo.safiprefs";
static NSString *notificationString = @"com.lacertosusrepo.safiprefs/preferences.changed";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

	// [Vars] ----------------------------------------------------------
static BOOL safiSwitch = YES;
static BOOL folderTitle = NO;
static BOOL folderDots = NO;
static BOOL hideApps = NO;
static float folderBackground = 0.0;
static float fadeTime = 0.5;
static int blurOption = 1;

static BOOL canFadeApps = NO;
static BOOL canShowApps = NO;
UIBlurEffect *blurEffect;

	// [Code] ----------------------------------------------------------
%hook SBFolderView
	
	//Folder Title
	-(void)setFolderName:(id)arg1 {
		
		if(safiSwitch == YES && folderTitle == NO) {
			
			%orig(nil);
		
		}
		
	%orig;
	}
	
%end

%hook SBFloatyFolderView
	
	//Folder Title
	-(_Bool)_showsTitle {
		
		return folderTitle;
		
	}
	
	//Folder Background
	-(void)setBackgroundAlpha:(double)arg1 {

		%orig;
		
		if(safiSwitch == YES) {
			
			%orig(folderBackground);
		
		}
	}		
	
%end

	//Blur Effect
%hook SBFolderControllerBackgroundView

	-(id)_blurEffect {

		if (safiSwitch == YES) {
		
			if (blurOption == 0) {
			
				blurEffect = nil;
			
			} if(blurOption == 1) {

				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		
			} if(blurOption == 2) {
			
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			
			} if(blurOption == 3) {
			
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
			
			}
		
		return blurEffect;
		}
	
	return %orig;
	}
	
%end

	//Page Dots
%hook SBIconListPageControl

	-(id)initWithFrame:(CGRect)arg1 {
		
		if(safiSwitch == YES && folderDots == NO) {
			
			return nil;
		
		}
		
	return %orig;
	}

%end

%hook SBFolderController

	-(void)prepareToOpen {
		canFadeApps = YES;
		%orig;	
	}
	
	-(void)prepareToClose {
		canShowApps = YES;
		%orig;
	}
	
%end

%hook SBRootFolderView 

	-(void)_layoutSubviews {
		
		if(canFadeApps == YES && hideApps == YES) {
		
			//Fade In Icons
			[UIView animateWithDuration:fadeTime animations:^(void) {
				[self setAlpha:1];
				canFadeApps = NO;
			}];
			
		} if(canShowApps == YES && hideApps == YES) {
		
			//Fade Out Icons
			[UIView animateWithDuration:fadeTime animations:^(void) {
				[self setAlpha:0];
				canShowApps = NO;
			}];
			
		}
		
	%orig;
	}

%end

	// [Preferences] ------------------------------------------------------
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	
	
	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"safiSwitch" inDomain:domainString];
	safiSwitch = (a)? [a boolValue]:YES;
	
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"folderTitle" inDomain:domainString];
	folderTitle = (b)? [b boolValue]:NO;
	
	NSNumber *c = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"folderDots" inDomain:domainString];
	folderDots = (c)? [c boolValue]:NO;
	
	NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"folderBackground" inDomain:domainString];
	folderBackground = (d)? [d floatValue]:0.0;
	
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"blurOption" inDomain:domainString];
	blurOption = (e)? [e intValue]:1;
	
	NSNumber *f = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"fadeTime" inDomain:domainString];
	fadeTime = (f)? [f floatValue]:0.5;
	
	NSNumber *g = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideApps" inDomain:domainString];
	hideApps = (g)? [g boolValue]:NO;

}

%ctor {
		
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}