/*
 * Tweak.xm
 * Stellae
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/11/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#import <PhotoLibrary/PLStaticWallpaperImageViewController.h>
#import "StellaeClasses.h"
#import "StellaeController.h"
#define LD_DEBUG NO

  /*
   * Preference variables
   */
  static BOOL stellaeSwitch;
  static BOOL imageSizeFilter;
  static BOOL useTimer;
  static BOOL nsfwFilter;
  static int numberOfPostsGrabbed;
  static int stellaeTimerInterval;
  static int wallpaperMode;
  static NSString *subreddit;

  /*
   * Global variables
   */
  BOOL stellaeInitalAlertShown;
  BOOL savedInitalWallpaper;
  NSData *redditImageData;
  NSString *baseURL = @"https://reddit.com/r/SUB/hot.json?limit=NUM";
  NSString *currentImageURL;
  NSString *currentRedditURL;
  PCSimpleTimer *timer;
  SBHomeScreenViewController *HomeScreenViewController;

  NSString *mainPrefs = @"/User/Library/Preferences/com.lacertosusrepo.stellaeprefs.plist";
  NSString *secondaryPrefs = @"/User/Library/Preferences/com.lacertosusrepo.stellaesaveddata.plist";
  extern "C" CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

  /*
   * Thanks /u/andreashenriksson!
   * https://old.reddit.com/r/jailbreakdevelopers/comments/b3gbec/help_showing_uialert_after_respring/ej6koko/
   *
   * Creates a alert that prompts the user to save thier wallpapers if they want
   */
%subclass StellaeInitialAlertItem : SBAlertItem
  -(void)configure:(BOOL)arg1 requirePasscodeForActions:(BOOL)arg2 {
    UIAlertController *alertController = [self alertController];
    [alertController setTitle:@"Stellae"];
    [alertController setMessage:@"Thanks for installing Stellae!\n\nWould you like to backup your wallpaper(s) to your photo library?"];
    [self setIconImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stellaeprefs.bundle/icon.png"]];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Sure!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"]) {
        NSData *homeData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"];
        CFArrayRef homeArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)homeData, NULL, 1, NULL);
        NSArray *homeArray = (__bridge NSArray*)homeArrayRef;
        UIImage *homeWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(homeArray[0])];
        UIImageWriteToSavedPhotosAlbum(homeWallpaper, nil, nil, nil);
        CFRelease(homeArrayRef);

      } if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"]) {
        NSData *lockData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
        CFArrayRef lockArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)lockData, NULL, 1, NULL);
        NSArray *lockArray = (__bridge NSArray*)lockArrayRef;
        UIImage *lockWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(lockArray[0])];
        UIImageWriteToSavedPhotosAlbum(lockWallpaper, nil, nil, nil);
        CFRelease(lockArrayRef);
      }
      [self dismiss];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
      [self dismiss];
    }];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
  }

  -(BOOL)reappearsAfterUnlock {
    return YES;
  }

  -(void)dismiss {
    %orig;
  }
%end

%hook SBDashBoardViewController
  -(void)finishUIUnlockFromSource:(int)arg1 {
    %orig;
    NSMutableDictionary *saveddata = [[NSMutableDictionary alloc] initWithContentsOfFile:secondaryPrefs];
    stellaeInitalAlertShown = [[saveddata objectForKey:@"stellaeInitalAlertShown"] boolValue];
    if(!stellaeInitalAlertShown || LD_DEBUG) {
      [saveddata setObject:[NSNumber numberWithBool:1] forKey:@"stellaeInitalAlertShown"];
      [saveddata writeToFile:secondaryPrefs atomically:YES];

      SBAlertItem *item = [[%c(StellaeInitialAlertItem) alloc] init];
      [[%c(SBAlertItemsController) sharedInstance] activateAlertItem:item];
    }
    [saveddata release];
  }
%end

  /*
   * Main chunk of it all. Sends the subreddit name, posts to grab, NSFW filter setting, and current image url to
   * StellaeController, which spits out a UIImage from that information.
   *
   * Creates timer on init, goes off based on amount of seconds (1-5 hs)
   * Once the timer fires it calls setStellaeWallpaper, invalidates the timer and creates another
   */
%hook SBHomeScreenViewController
%property (nonatomic, retain) PCSimpleTimer *apolloTimer;

  -(id)initWithNibName:(id)arg1 bundle:(id)arg2 {
    if(stellaeSwitch && useTimer) {
      [self createTimer];
    }
    return HomeScreenViewController = %orig;
  }

%new
  /*
   * Thank you Tateu, very cool!
   * https://github.com/tateu/TimerExample/blob/master/Tweak.xm
   */
  -(void)createTimer {
    if(timer) {
      [timer invalidate];
      [self.apolloTimer invalidate];

      timer = nil;
      self.apolloTimer = nil;
    }

    if(stellaeTimerInterval < 3600) {
      stellaeTimerInterval = 3600;
    } else if (LD_DEBUG) {
      stellaeTimerInterval = 30;
    }
    timer = [[%c(PCSimpleTimer) alloc] initWithTimeInterval:stellaeTimerInterval serviceIdentifier:@"com.lacertosusrepo.stellae" target:self selector:@selector(setStellaeWallpaper) userInfo:nil];
    timer.disableSystemWaking = NO;
    [timer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
    self.apolloTimer = timer;

    if(LD_DEBUG) {
      NSLog(@"Timer - %@", timer);
      NSLog(@"Timer isValid - %d", [timer isValid]);
    }
  }

%new
  -(void)setStellaeWallpaper {
    if(stellaeSwitch) {
      NSMutableDictionary *saveddata = [[NSMutableDictionary alloc] initWithContentsOfFile:secondaryPrefs];
      currentImageURL = [saveddata objectForKey:@"currentImageURL"];

      UIImage *newWallpaper = [[StellaeController sharedInstance] getImageFromReddit:subreddit numberOfPostsGrabbed:numberOfPostsGrabbed nsfwFiltered:nsfwFilter currentImageURL:currentImageURL];

      if(newWallpaper == nil) {
        [self setStellaeWallpaper];
      } if((newWallpaper.size.width != [UIScreen mainScreen].bounds.size.width && newWallpaper.size.height != [UIScreen mainScreen].bounds.size.height) && imageSizeFilter) {
        NSLog(@"Stellae || Image is smaller than current device");
      } else {
        PLStaticWallpaperImageViewController *wallpaperViewController = [[[PLStaticWallpaperImageViewController alloc] initWithUIImage:newWallpaper] autorelease];
        wallpaperViewController.saveWallpaperData = YES;
        uintptr_t address = (uintptr_t)&wallpaperMode;
        object_setInstanceVariable(wallpaperViewController, "_wallpaperMode", *(PLWallpaperMode **)address);
        [wallpaperViewController _savePhoto];
      }

      if(![self.apolloTimer isValid] && useTimer) {
        [self createTimer];
      }
    }
  }
%end

  /*
   * Simple function to manually update the wallpaper
   */
static void updateSubImage() {
  [HomeScreenViewController setStellaeWallpaper];
}

  /*
   * Saves the current wallpapers based on where the reddit image is applied to
   *
   * wallpaperMode: 1 = homescreen, 2 = lockscreen, 0 = both
   */
static void saveImage() {
  if((wallpaperMode == 1 || wallpaperMode == 0) && [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"]) {
    NSData *homeData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalHomeBackground.cpbitmap"];
    CFArrayRef homeArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)homeData, NULL, 1, NULL);
    NSArray *homeArray = (__bridge NSArray*)homeArrayRef;
    UIImage *homeWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(homeArray[0])];
    UIImageWriteToSavedPhotosAlbum(homeWallpaper, nil, nil, nil);
    CFRelease(homeArrayRef);

  } if((wallpaperMode == 2 || wallpaperMode == 0) && [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"]) {
    NSData *lockData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
    CFArrayRef lockArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)lockData, NULL, 1, NULL);
    NSArray *lockArray = (__bridge NSArray*)lockArrayRef;
    UIImage *lockWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(lockArray[0])];
    UIImageWriteToSavedPhotosAlbum(lockWallpaper, nil, nil, nil);
    CFRelease(lockArrayRef);
  }
}

  /*
   * Resprings the device
   */
static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

  /*
   * Loads my preferences. If either plist has less objects than there are suppossed to be they are reset.
   */
static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:mainPrefs];
  NSMutableDictionary *saveddata = [[NSMutableDictionary alloc] initWithContentsOfFile:secondaryPrefs];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    stellaeSwitch = YES;
    imageSizeFilter = NO;
    wallpaperMode = 2;
    useTimer = NO;
    stellaeTimerInterval = 3600;
    subreddit = @"spaceporn";
    numberOfPostsGrabbed = 3;
    nsfwFilter = YES;
  } else if(!saveddata) {
    saveddata = [[NSMutableDictionary alloc] init];
    [saveddata setObject:@"" forKey:@"currentRedditURL"];
    [saveddata setObject:@"" forKey:@"currentImageURL"];
    [saveddata setObject:[NSNumber numberWithBool:0] forKey:@"stellaeInitalAlertShown"];
    [saveddata writeToFile:secondaryPrefs atomically:YES];
  } else {
    stellaeSwitch = [[preferences objectForKey:@"stellaeSwitch"] boolValue];
    imageSizeFilter = [[preferences objectForKey:@"imageSizeFilter"] boolValue];
    wallpaperMode = [[preferences objectForKey:@"setWallpaperMode"] intValue];
    useTimer = [[preferences objectForKey:@"useTimer"] boolValue];
    stellaeTimerInterval = [[preferences objectForKey:@"stellaeTimerInterval"] intValue];
    subreddit = [preferences objectForKey:@"subreddit"];
    numberOfPostsGrabbed = [[preferences objectForKey:@"numberOfPostsGrabbed"] intValue];
    nsfwFilter = [[preferences objectForKey:@"nsfwFilter"] boolValue];

    currentImageURL = [saveddata objectForKey:@"currentImageURL"];
    currentRedditURL = [saveddata objectForKey:@"currentRedditURL"];
    stellaeInitalAlertShown = [[saveddata objectForKey:@"stellaeInitalAlertShown"] boolValue];
  }
}

static NSString *nsNotificationString = @"com.lacertosusrepo.stellaeprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPrefs();
}

  /*
   * Setup notifications
   */
%ctor {
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  loadPrefs();
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updateSubImage, CFSTR("com.lacertosusrepo.stellaeprefs-updateSubImage"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)saveImage, CFSTR("com.lacertosusrepo.stellaeprefs-saveImage"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.lacertosusrepo.stellaeprefs-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  [pool release];
}
