	//Headers
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

	//Prefs
static NSString *domainString = @"com.lacertosusrepo.safiprefs";
static NSString *notificationString = @"com.lacertosusrepo.safiprefs/preferences.changed";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

	//Vars
static BOOL safiSwitch = YES;
static BOOL folderTitle = NO;
static BOOL folderDots = NO;
static float folderBackground = 0.0;
static int blurOption = 1;

//UIView *windowWallpaper;
//UIImageView* homeBG;
UIBlurEffect *blurEffect;

extern "C" CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

	//Folder Name
%hook SBFolderView

	-(_Bool)_showsTitle {
		
		return folderTitle;
		
	}
	
	-(void)setFolderName:(id)arg1 {
		
		if(folderTitle == NO) {
			
			%orig(nil);
		
		}
		
	%orig;
	}
	
%end

	//Folder Background
%hook SBFloatyFolderView
	
	-(_Bool)_showsTitle {
		
		return folderTitle;
		
	}
	
	-(void)setBackgroundAlpha:(double)arg1 {
		
		%orig(folderBackground);
		
	}
	
%end

	//Blur Effect
%hook SBFolderControllerBackgroundView

	-(id)_blurEffect {
		
		if(blurOption == 1) {

			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		
		} if(blurOption == 2) {
			
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			
		} if(blurOption == 3) {
			
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
			
		}		
		
		return blurEffect;
		
	}
	
/*	-(void)layoutSubviews {
		
		//[super layoutSubviews];
		
		if(folderDots == NO) {
		
			windowWallpaper = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
			windowWallpaper.tintColor = [UIColor redColor];
			[self addSubview:windowWallpaper];
			
		} if(folderDots == YES) {
			
			windowWallpaper = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			windowWallpaper.backgroundColor = [UIColor clearColor];
			windowWallpaper.hidden = NO;
			windowWallpaper.alpha = 0;

			NSData *homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
			CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeWallpaperData;
			NSArray *imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
			UIImage *homeWallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
				
			homeBG = [[UIImageView alloc] initWithImage:homeWallpaper];
			homeBG.frame = windowWallpaper.bounds;
			[self addSubview:homeBG];
		}
		
	%orig;
	}*/
	
%end

	//Page Dots
%hook SBIconListPageControl

	-(id)initWithFrame:(CGRect)arg1 {
		
		if(folderDots == NO) {
			
			return nil;
		
		}
		
	return %orig;
	}

%end

	//Preferences
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

}

%ctor {
		
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}