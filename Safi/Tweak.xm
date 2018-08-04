//--Headers--//
#import <SpringBoard/SpringBoard.h>
#import "SafiHeaders.h"

//--Vars--//
NSMutableDictionary * preferences;
UIBlurEffect * blurEffect;
UITapGestureRecognizer * tap;

//--Pref Vars--//
static BOOL hideFolderTitle;
static BOOL hideFolderDots;
static BOOL hideFolderIcon;
static BOOL hideApps;
static float folderBackgroundAlpha;
static int blurOption;
static float blurAlpha;

//--SpringBoard--//

%hook SBFloatyFolderView

	//Hide folder title
	-(BOOL)_showsTitle {
		return !hideFolderTitle;
	}

	//Add gesture
	-(id)initWithFolder:(id)arg1 orientation:(long long)arg2 viewMap:(id)arg3 context:(id)arg4 {
		tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)] autorelease];
		[self addGestureRecognizer:tap];
		return %orig;
	}

%new

	//Closes current folder
	-(void)handleTap {
		[[NSClassFromString(@"SBIconController") sharedInstance] _closeFolderController:self animated:YES withCompletion:nil];
	}

%end

%hook SBIconListPageControl

	//Hide folder dots
	-(void)layoutSubviews {
		if(self.hidden == NO && hideFolderDots) {
			self.hidden = hideFolderDots;
		} else {
		%orig;
		}
	}

%end

%hook SBFolderBackgroundView

	//Folder background alpha
	-(void)layoutSubviews {
		self.alpha = folderBackgroundAlpha;
	}

%end

%hook SBFolderIconImageView

	-(void)layoutSubviews {
		UIView * backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
		backgroundView.hidden = hideFolderIcon;
		%orig;
	}

%end

%hook SBFolderControllerBackgroundView

	//Set blur
	-(id)_blurEffect {
		if(blurOption == noBlur) {
			blurEffect = nil;
		} else if(blurOption == darkBlur) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		} else if(blurOption == lightBlur) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		} else if(blurOption == extraLightBlur) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
		}
		self.alpha = blurAlpha;
		return blurEffect;
	}

%end

//Fade icons when in folder, not working yet
/*	static BOOL folderIsOpen;
	static float animationLength = 0.2;

%hook SBIconController

	-(void)loadView {

		%orig;
	}

%end

%hook SBRootFolderView

	-(void)layoutSubviews {
		if(folderIsOpen == YES) {
			[UIView animateWithDuration:animationLength animations:^(void) {
				self.alpha = 0.0;
			}];
		} else if(folderIsOpen == NO) {
			[UIView animateWithDuration:animationLength animations:^(void) {
				self.alpha = 1.0;
			}];
		}
		NSLog(@"folder open - %i", folderIsOpen);
		return %orig;
	}

%end*/

static void loadPrefs() {
	static NSString * file = @"/User/Library/Preferences/com.lacertosusrepo.safiprefs.plist";
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];

	if(!preferences) {
		preferences = [[NSMutableDictionary alloc] init];
	} else {
		hideFolderTitle = [[preferences objectForKey:@"hideFolderTitle"] boolValue];
		hideFolderDots = [[preferences objectForKey:@"hideFolderDots"] boolValue];
		hideFolderIcon = [[preferences objectForKey:@"hideFolderIcon"] boolValue];
		hideApps = [[preferences objectForKey:@"hideApps"] boolValue];
		folderBackgroundAlpha = [[preferences objectForKey:@"folderBackgroundAlpha"] floatValue];
		blurOption = [[preferences objectForKey:@"blurOption"] intValue];
		blurAlpha = [[preferences objectForKey:@"blurAlpha"] floatValue];
	}
	[preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.safiprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
