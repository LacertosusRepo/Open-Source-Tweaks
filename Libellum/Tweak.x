/*
 * Tweak.x
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

@import Alderis;
#import <Cephei/HBPreferences.h>
#import "AlderisColorPicker.h"
#import "LibellumView.h"
#import "LibellumClasses.h"
#define LD_DEBUG NO

    /*
     * Variables
     */
  static CSScrollView *scrollViewCS;
  static SBPagedScrollView *scrollViewSB;
  static BOOL isHidden;

    /*
     * Preferences Variables
     */
  static NSInteger noteSize;
  static NSInteger notePosition;
  static BOOL enableUndoRedo;
  static BOOL enableEndlessLines;
  static BOOL hideNoOlderNotifications;
  static BOOL enableAutoUnlockXBlock;
  static BOOL useKalmTintColor;

  static CGFloat cornerRadius;
  static NSString *blurStyle;
  static BOOL ignoreAdaptiveColors;
  static NSString *customBackgroundColor;
  static NSString *customTextColor;
  static NSString *lockColor;
  static NSString *customTintColor;

  static NSString *borderColor;
  static CGFloat borderWidth;

  static BOOL requireAuthentication;
  static BOOL noteBackup;

  static BOOL hideGesture;
  static BOOL useEdgeGesture;
  static BOOL useSwipeGesture;
  static BOOL useTapGesture;
  static BOOL feedback;
  static NSInteger feedbackStyle;

#pragma mark - iOS 13

  /*
   * Add Libellum to the Lockscreen
   * Axon - Nepeta & BawApple https://github.com/Baw-Appie/Axon/blob/master/Tweak/Tweak.xm
   */
%hook CSNotificationAdjunctListViewController
%property (nonatomic, retain) LibellumView *libellum;
  -(void)viewDidLoad {
    %orig;
    if(!self.libellum) {
      self.libellum = [[LibellumView sharedInstance] init];
      [self.libellum setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.libellum atIndex:0];

      [scrollViewCS addGestureRecognizer:self.libellum.lGesture];

      [[scrollViewCS panGestureRecognizer] requireGestureRecognizerToFail:self.libellum.swipeGesture];
      [[scrollViewCS panGestureRecognizer] requireGestureRecognizerToFail:self.libellum.lGesture];

      if(isHidden && hideGesture) {
        [self.libellum toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
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
  -(id)initWithFrame:(CGRect)ag1 {
    UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    toggleGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:toggleGesture];

    return scrollViewCS = %orig;
  }

%new
  -(void)handleTaps:(UITapGestureRecognizer *)gesture {
    if(useTapGesture) {
      [[LibellumView sharedInstance] toggleLibellum:gesture];
    }
  }
%end

#pragma mark - iOS 12

  /*
   * Add Libellum to the Lockscreen
   * Axon - Nepeta & BawApple https://github.com/Baw-Appie/Axon/blob/master/Tweak/Tweak.xm
   */
%hook SBDashBoardNotificationAdjunctListViewController
%property (nonatomic, retain) LibellumView *libellum;
  -(void)viewDidLoad {
    %orig;

    if(!self.libellum) {
      self.libellum = [[LibellumView sharedInstance] init];
      [self.libellum setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.libellum atIndex:0];

      [[scrollViewSB panGestureRecognizer] requireGestureRecognizerToFail:self.libellum.swipeGesture];

      if(isHidden && hideGesture) {
        [self.libellum toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
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
    -(id)initWithFrame:(CGRect)ag1 {
      UITapGestureRecognizer *toggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
      toggleGesture.numberOfTapsRequired = 3;
      [self addGestureRecognizer:toggleGesture];

      return scrollViewSB = %orig;
    }

  %new
    -(void)handleTaps:(UITapGestureRecognizer *)gesture {
      if(useTapGesture) {
        [[LibellumView sharedInstance] toggleLibellum:gesture];
      }
    }
  %end

#pragma mark - iOS 12 & 13

  /*
   * Get lock state and pass instance to libellum
   * iOS 12/13
   */
%hook SBLockStateAggregator
  -(void)_updateLockState {
    %orig;

    if(requireAuthentication) {
      [[LibellumView sharedInstance] authenticationStatusFromAggregator:self];
    }
  }
%end

  /*
   * AutoUnlockX compatibility
   */
%hook SparkAutoUnlockX
  -(BOOL)externalBlocksUnlock {
    if([LibellumView sharedInstance] && enableAutoUnlockXBlock) {
      return ![[LibellumView sharedInstance] isHidden];
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
    self.hidden = YES;
  }
%end

  /*
   * Update Preferences
   */
static void libellumPreferencesChanged() {
  LibellumView *libellum = [LibellumView sharedInstance];
  libellum.noteSize = noteSize;
  libellum.enableUndoRedo = enableUndoRedo;
  libellum.enableEndlessLines = enableEndlessLines;
  libellum.useKalmTintColor = useKalmTintColor;
  libellum.cornerRadius = cornerRadius;
  libellum.blurStyle = blurStyle;
  libellum.ignoreAdaptiveColors = ignoreAdaptiveColors;
  libellum.customBackgroundColor = [UIColor PF_colorWithHex:customBackgroundColor];
  libellum.customTextColor = [UIColor PF_colorWithHex:customTextColor];
  libellum.lockColor = [UIColor PF_colorWithHex:lockColor];
  libellum.customTintColor = [UIColor PF_colorWithHex:customTintColor];
  libellum.borderColor = [UIColor PF_colorWithHex:borderColor];
  libellum.borderWidth = borderWidth;
  libellum.requireAuthentication = requireAuthentication;
  libellum.noteBackup = noteBackup;
  libellum.hideGesture = hideGesture;
  libellum.useEdgeGesture = useEdgeGesture;
  libellum.useSwipeGesture = useSwipeGesture;
  libellum.useTapGesture = useTapGesture;
  libellum.feedback = feedback;
  libellum.feedbackStyle = feedbackStyle;
  [libellum preferencesChanged];
}

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerInteger:&noteSize default:121 forKey:@"noteSize"];
  [preferences registerInteger:&notePosition default:1 forKey:@"notePosition"];
  [preferences registerBool:&enableUndoRedo default:NO forKey:@"enableUndoRedo"];
  [preferences registerBool:&enableEndlessLines default:NO forKey:@"enableEndlessLines"];
  [preferences registerBool:&hideNoOlderNotifications default:YES forKey:@"hideNoOlderNotifications"];
  [preferences registerBool:&enableAutoUnlockXBlock default:NO forKey:@"enableAutoUnlockXBlock"];
  [preferences registerBool:&useKalmTintColor default:NO forKey:@"useKalmTintColor"];
  [preferences registerFloat:&cornerRadius default:15 forKey:@"cornerRadius"];
  [preferences registerObject:&blurStyle default:@"platters" forKey:@"blurStyle"];
  [preferences registerBool:&ignoreAdaptiveColors default:NO forKey:@"ignoreAdaptiveColors"];
  [preferences registerObject:&customBackgroundColor default:@"000000" forKey:@"customBackgroundColor"];
  [preferences registerObject:&customTextColor default:@"FFFFFF" forKey:@"customTextColor"];
  [preferences registerObject:&lockColor default:@"FFFFFF" forKey:@"lockColor"];
  [preferences registerObject:&customTintColor default:@"007AFF" forKey:@"customTintColor"];
  [preferences registerObject:&borderColor default:@"FFFFFF" forKey:@"borderColor"];
  [preferences registerFloat:&borderWidth default:0 forKey:@"borderWidth"];
  [preferences registerBool:&requireAuthentication default:NO forKey:@"requireAuthentication"];
  [preferences registerBool:&noteBackup default:NO forKey:@"noteBackup"];
  [preferences registerBool:&hideGesture default:YES forKey:@"hideGesture"];
  [preferences registerBool:&useEdgeGesture default:YES forKey:@"useEdgeGesture"];
  [preferences registerBool:&useSwipeGesture default:YES forKey:@"useSwipeGesture"];
  [preferences registerBool:&useTapGesture default:YES forKey:@"useTapGesture"];
  [preferences registerBool:&feedback default:YES forKey:@"feedback"];
  [preferences registerInteger:&feedbackStyle default:1520 forKey:@"feedbackStyle"];
  [preferences registerBool:&isHidden default:NO forKey:@"isHidden"];
  [preferences registerPreferenceChangeBlock:^{
    libellumPreferencesChanged();
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
}
