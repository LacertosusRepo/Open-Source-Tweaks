/*
 * Tweak.x
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"
#import "LibellumView.h"
#import "LibellumClasses.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

    /*
     * Variables
     */
  static CSScrollView *scrollViewCS;
  static SBPagedScrollView *scrollViewSB;

    /*
     * Preferences Variables
     */
  static NSInteger noteSize;
  static NSInteger notePosition;
  static CGFloat cornerRadius;
  static NSInteger blurStyle;
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

      [[scrollViewCS panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.dismissGesture];
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if([self.LBMNoteView isDescendantOfView:self.stackView]) {
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
    [[LibellumView sharedInstance] toggleLibellum:gesture];
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

      [[scrollViewSB panGestureRecognizer] requireGestureRecognizerToFail:self.LBMNoteView.dismissGesture];
    }
  }

  -(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2 {
    %orig;

    if(notePosition == 2) {
      [self.stackView insertArrangedSubview:self.LBMNoteView atIndex:[self.stackView.arrangedSubviews count]];
    }
  }

  -(BOOL)isPresentingContent {
    if([self.LBMNoteView isDescendantOfView:self.stackView]) {
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
      [[LibellumView sharedInstance] toggleLibellum:gesture];
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
   * Function to determine blur based on iOS
   */
static NSInteger decideBlurStyle(NSInteger blurStyle) {
  BOOL iOS13 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0 ,0}];
  switch (blurStyle) {
    case lightStyle:
    //UIBlurEffectStyleSystemThinMaterialLight
    return (iOS13) ? 12 : UIBlurEffectStyleLight;
    break;

    case darkStyle:
    //UIBlurEffectStyleSystemThinMaterialDark
    return (iOS13) ? 17 : UIBlurEffectStyleDark;
    break;

    case colorizedStyle:
    return 3;
    break;

    case adaptiveStyle:
    //UIBlurEffectStyleSystemThinMaterial
    return (iOS13) ? 7 : UIBlurEffectStyleRegular;
    break;
  }

  return UIBlurEffectStyleRegular;
}

  /*
   * Update Preferences
   */
static void libellumPreferencesChanged() {
  LibellumView *LBMNoteView = [LibellumView sharedInstance];
  LBMNoteView.noteSize = noteSize;
  LBMNoteView.cornerRadius = cornerRadius;
  LBMNoteView.blurStyle = decideBlurStyle(blurStyle);
  LBMNoteView.ignoreAdaptiveColors = ignoreAdaptiveColors;
  LBMNoteView.customBackgroundColor = LCPParseColorString(customBackgroundColor, @"000000");
  LBMNoteView.customTextColor = LCPParseColorString(customTextColor, @"FFFFFF");
  LBMNoteView.lockColor = LCPParseColorString(lockColor, @"FFFFFF");
  LBMNoteView.customTintColor = LCPParseColorString(customTintColor, @"007AFF");
  LBMNoteView.borderColor = LCPParseColorString(borderColor, @"FFFFFF");
  LBMNoteView.borderWidth = borderWidth;
  LBMNoteView.requireAuthentication = requireAuthentication;
  LBMNoteView.noteBackup = noteBackup;
  LBMNoteView.hideGesture = hideGesture;
  LBMNoteView.feedback = feedback;
  LBMNoteView.feedbackStyle = feedbackStyle;
  [LBMNoteView preferencesChanged];
}

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerInteger:&noteSize default:121 forKey:@"noteSize"];
  [preferences registerInteger:&notePosition default:1 forKey:@"notePosition"];
  [preferences registerFloat:&cornerRadius default:15 forKey:@"cornerRadius"];

  [preferences registerInteger:&blurStyle default:darkStyle forKey:@"blurStyle"];
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
  [preferences registerBool:&feedback default:YES forKey:@"feedback"];
  [preferences registerInteger:&feedbackStyle default:1520 forKey:@"feedbackStyle"];

  [preferences registerPreferenceChangeBlock:^{
    libellumPreferencesChanged();
  }];
}
