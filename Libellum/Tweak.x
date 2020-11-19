/*
 * Tweak.x
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/16/2019.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "LibellumView.h"
#import "LibellumClasses.h"
#define LD_DEBUG NO

    /*
     * Variables
     */
  static CSScrollView *scrollViewCS;
  static SBPagedScrollView *scrollViewSB;
  static HBPreferences *preferences;

#pragma mark - iOS 13/14

  /*
   * Add Libellum to the Lockscreen
   * Axon - Nepeta & BawApple https://github.com/Baw-Appie/Axon/blob/master/Tweak/Tweak.xm
   */
%group iOS13Plus
%hook CSNotificationAdjunctListViewController
%property (nonatomic, retain) LibellumView *libellum;
  -(void)viewDidLoad {
    %orig;

    if(!self.libellum) {
      self.libellum = [[LibellumView sharedInstance] init];
      [self.libellum setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.libellum atIndex:0];

      [scrollViewCS addGestureRecognizer:self.libellum.lGesture];
      [scrollViewCS.panGestureRecognizer requireGestureRecognizerToFail:self.libellum.swipeGesture];

      if([preferences boolForKey:@"isHidden"] && [preferences boolForKey:@"hideGesture"]) {
        [self.libellum toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if([preferences integerForKey:@"notePosition"] == 2) {
      [self.stackView insertArrangedSubview:self.libellum atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if(!self.libellum.hidden) {
      return YES;
    }

    return %orig;
  }
%end

  /*
   * Add hide/show gesture to lockscreen
   */
%hook CSScrollView
  -(instancetype)initWithFrame:(CGRect)ag1 {
    UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:[LibellumView sharedInstance] action:@selector(toggleLibellum:)];
    toggleGesture.enabled = [preferences boolForKey:@"useTapGesture"];
    toggleGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:toggleGesture];

    return scrollViewCS = %orig;
  }
%end

  /*
   * Hide buttons when in portrait
   */
%hook CSQuickActionsViewController
  -(BOOL)isPortrait {
    if([preferences boolForKey:@"hideQuickActions"]) {
      if(%orig) {
        self.view.hidden = YES;
      } else {
        self.view.hidden = NO;
      }
    }

    return %orig;
  }
%end
%end

#pragma mark - iOS 12

  /*
   * Add Libellum to the Lockscreen
   * Axon - Nepeta & BawApple https://github.com/Baw-Appie/Axon/blob/master/Tweak/Tweak.xm
   */
%group iOS12
%hook SBDashBoardNotificationAdjunctListViewController
%property (nonatomic, retain) LibellumView *libellum;
  -(void)viewDidLoad {
    %orig;

    if(!self.libellum) {
      self.libellum = [[LibellumView sharedInstance] init];
      [self.libellum setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.libellum atIndex:0];

      [scrollViewSB.panGestureRecognizer requireGestureRecognizerToFail:self.libellum.swipeGesture];

      if([preferences boolForKey:@"isHidden"] && [preferences boolForKey:@"hideGesture"]) {
        [self.libellum toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if([preferences integerForKey:@"notePosition"] == 2) {
      [self.stackView insertArrangedSubview:self.libellum atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if(!self.libellum.hidden) {
      return YES;
    }

    return %orig;
  }
%end

  /*
   * Add hide/show gesture to lockscreen
   */
%hook SBPagedScrollView
  -(instancetype)initWithFrame:(CGRect)ag1 {
    UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:[LibellumView sharedInstance] action:@selector(toggleLibellum:)];
    toggleGesture.enabled = [preferences boolForKey:@"useTapGesture"];
    toggleGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:toggleGesture];

    return scrollViewSB = %orig;
  }
%end

  /*
   * Hide buttons when in portrait
   */
%hook SBDashBoardQuickActionsViewController
  -(BOOL)isPortrait {
    if([preferences boolForKey:@"hideQuickActions"]) {
      if(%orig) {
        self.view.hidden = YES;
      } else {
        self.view.hidden = NO;
      }
    }

    return %orig;
  }
%end
%end

#pragma mark - iOS 12 & 13 & 14

  /*
   * Get lock state and pass instance to libellum
   * iOS 12/13
   */
%hook SBLockStateAggregator
  -(void)_updateLockState {
    %orig;

    if([preferences boolForKey:@"requireAuthentication"]) {
      [[LibellumView sharedInstance] authenticationStatusFromAggregator:self];
    }
  }
%end

  /*
   * AutoUnlockX compatibility
   */
%hook SparkAutoUnlockX
  -(BOOL)externalBlocksUnlock {
    if([LibellumView sharedInstance] && [preferences boolForKey:@"requireAuthentication"]) {
      return ![LibellumView sharedInstance].hidden;
    }

    return %orig;
  }
%end

  /*
   * Hide "No Older Notifications" label
   */
%hook NCNotificationListSectionRevealHintView
  -(void)_layoutRevealHintTitle {
    %orig;
    self.hidden = [preferences boolForKey:@"hideNoOlderNotifications"];
  }
%end

%ctor {
  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerDefaults:@{
      //Main Preferences
    @"noteSize" : @121,
    @"notePosition" : @1,
    @"blurStyle" : @"platters",
    @"cornerRadius" : @10,

    @"requireAuthentication" : @NO,
    @"noteBackup" : @NO,

    @"hideGesture" : @NO,
    @"feedback" : @YES,
    @"feedbackStyle" : @1520,

      //Color Options
    @"useKalmTintColor" : @NO,
    @"ignoreAdaptiveColors" : @NO,
    @"customBackgroundColor" : @"#000000",
    @"customTextColor" : @"#FFFFFF",
    @"lockColor" : @"FFFFFF",
    @"customTintColor" : @"#007AFF",

    @"borderColor" : @"#FFFFFF",
    @"borderWidth" : @0,

      //General Options
    @"enableUndoRedo" : @NO,
    @"enableEndlessLines" : @NO,
    @"hideNoOlderNotifications" : @YES,
    @"enableAutoUnlockXBlock" : @NO,
    @"hideQuickActions" : @NO,

      //Gesture Options
    @"useSwipeGesture" : @YES,
    @"useTapGesture" : @YES,

      //Saved Variables
    @"isHidden" : @NO,
  }];

  [preferences registerPreferenceChangeBlock:^{
    [[LibellumView sharedInstance] preferencesChanged];
  }];

    //Fix crash caused by preference value previosuly being an integer
  if([[preferences objectForKey:@"blurStyle"] intValue] > 0) {
    [preferences setObject:@"adaptive" forKey:@"blurStyle"];
  }

    //convert old notes data to rtf
  if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/LibellumNotes.txt"]) {
    NSString *contents = [NSString stringWithContentsOfFile:@"/User/Library/Preferences/LibellumNotes.txt" encoding:NSUTF8StringEncoding error:nil];
    NSAttributedString *newContents = [[NSAttributedString alloc] initWithString:contents attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    NSData *data = [newContents dataFromRange:(NSRange){0, newContents.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:nil];
    [data writeToFile:filePath atomically:YES];
    [[NSFileManager defaultManager] removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.txt" error:nil];
  }

  if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/LibellumNotes.bk"]) {
    NSString *contents = [NSString stringWithContentsOfFile:@"/User/Library/Preferences/LibellumNotes.bk" encoding:NSUTF8StringEncoding error:nil];
    NSAttributedString *newContents = [[NSAttributedString alloc] initWithString:contents attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    NSData *data = [newContents dataFromRange:(NSRange){0, newContents.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:nil];
    [data writeToFile:filePathBK atomically:YES];
    [[NSFileManager defaultManager] removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.bk" error:nil];
  }

  if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
    %init(iOS13Plus);
  } else {
    %init(iOS12);
  }
  %init;
}
