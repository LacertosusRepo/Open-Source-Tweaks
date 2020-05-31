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
  static BOOL enableUndoRedo;
  static BOOL enableEndlessLines;
  static BOOL enableAutoUnlockXBlock;
  static NSInteger notePosition;
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
%property (nonatomic, retain) LibellumView *LBMNoteView;
  -(void)viewDidLoad {    
    %orig;
    if(!self.LBMNoteView) {
      self.LBMNoteView = [[LibellumView sharedInstance] initWithFrame:CGRectZero];
      [self.LBMNoteView setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

      [[scrollViewCS panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.swipeGesture];

      if(isHidden) {
        [self.LBMNoteView toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if(!self.LBMNoteView.hidden) {
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
%property (nonatomic, retain) LibellumView *LBMNoteView;
  -(void)viewDidLoad {
    %orig;

    if(!self.LBMNoteView) {
      self.LBMNoteView = [[LibellumView sharedInstance] initWithFrame:CGRectZero];
      [self.LBMNoteView setSizeToMimic:self.sizeToMimic];
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

      [[scrollViewSB panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.swipeGesture];

      if(isHidden) {
        [self.LBMNoteView toggleLibellum:nil];
      }
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if(!self.LBMNoteView.hidden) {
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
   * Update Preferences
   */
static void libellumPreferencesChanged() {
  LibellumView *LBMNoteView = [LibellumView sharedInstance];
  LBMNoteView.noteSize = noteSize;
  LBMNoteView.enableUndoRedo = enableUndoRedo;
  LBMNoteView.enableEndlessLines = enableEndlessLines;
  LBMNoteView.cornerRadius = cornerRadius;
  LBMNoteView.blurStyle = blurStyle;
  LBMNoteView.ignoreAdaptiveColors = ignoreAdaptiveColors;
  LBMNoteView.customBackgroundColor = [UIColor PF_colorWithHex:customBackgroundColor];
  LBMNoteView.customTextColor = [UIColor PF_colorWithHex:customTextColor];
  LBMNoteView.lockColor = [UIColor PF_colorWithHex:lockColor];
  LBMNoteView.customTintColor = [UIColor PF_colorWithHex:customTintColor];
  LBMNoteView.borderColor = [UIColor PF_colorWithHex:borderColor];
  LBMNoteView.borderWidth = borderWidth;
  LBMNoteView.requireAuthentication = requireAuthentication;
  LBMNoteView.noteBackup = noteBackup;
  LBMNoteView.hideGesture = hideGesture;
  LBMNoteView.useEdgeGesture = useEdgeGesture;
  LBMNoteView.useSwipeGesture = useSwipeGesture;
  LBMNoteView.useTapGesture = useTapGesture;
  LBMNoteView.feedback = feedback;
  LBMNoteView.feedbackStyle = feedbackStyle;
  [LBMNoteView preferencesChanged];
}

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerInteger:&noteSize default:121 forKey:@"noteSize"];
  [preferences registerInteger:&notePosition default:1 forKey:@"notePosition"];
  [preferences registerBool:&enableUndoRedo default:NO forKey:@"enableUndoRedo"];
  [preferences registerBool:&enableEndlessLines default:NO forKey:@"enableEndlessLines"];
  [preferences registerBool:&enableAutoUnlockXBlock default:NO forKey:@"enableAutoUnlockXBlock"];
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
}
