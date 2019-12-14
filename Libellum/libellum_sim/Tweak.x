/*
 * Tweak.x
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
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
  static NSInteger noteSize = 121;
  static CGFloat cornerRadius = 10;
  static NSInteger blurStyle = 2;
  //static NSString *customBackgroundColor;
  //static NSString *customTextColor;
  //static NSString *borderColor;
  static CGFloat borderWidth = 2;
  static BOOL requireAuthentication = YES;
  static BOOL noteBackup = NO;
  static BOOL hideGesture = YES;
  static BOOL feedback = NO;
  static NSInteger feedbackStyle = 1520;

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
  if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0 ,0}]) {
    switch (blurStyle) {
      case lightStyle:
      return 12;  //UIBlurEffectStyleSystemThinMaterialLight
      break;

      case darkStyle:
      return 17;  //UIBlurEffectStyleSystemThinMaterialDark
      break;

      case colorizedStyle:
      return 3;
      break;

      case adaptive:
      return 7; //UIBlurEffectStyleSystemThinMaterial
      break;
    }
  } else {
    switch (blurStyle) {
      case lightStyle:
      return UIBlurEffectStyleLight;
      break;

      case darkStyle:
      return UIBlurEffectStyleDark;
      break;

      case colorizedStyle:
      return 3;
      break;

      case adaptive:
      return UIBlurEffectStyleRegular;
      break;
    }
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
  LBMNoteView.customBackgroundColor = [UIColor blackColor];
  LBMNoteView.customTextColor = [UIColor whiteColor];
  LBMNoteView.borderColor = [UIColor whiteColor];
  LBMNoteView.borderWidth = borderWidth;
  LBMNoteView.requireAuthentication = requireAuthentication;
  LBMNoteView.noteBackup = noteBackup;
  LBMNoteView.hideGesture = hideGesture;
  LBMNoteView.feedback = feedback;
  LBMNoteView.feedbackStyle = feedbackStyle;
  [LBMNoteView preferencesChanged];
}

/*static void libellumUseWallpaperColors() {
  NSData *lockData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
  CFArrayRef lockArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)lockData, NULL, 1, NULL);
  NSArray *lockArray = (__bridge NSArray*)lockArrayRef;
  UIImage *lockWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(lockArray[0])];
  CFRelease(lockArrayRef);

  HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [lockWallpaper getPaletteImageColorWithMode:VIBRANT_PALETTE | LIGHT_VIBRANT_PALETTE | DARK_VIBRANT_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"customTextColor"];
  }];
  [lockWallpaper getPaletteImageColorWithMode:MUTED_PALETTE | LIGHT_MUTED_PALETTE | DARK_MUTED_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"customBackgroundColor"];
    [preferences setObject:recommendColor.imageColorString forKey:@"borderColor"];
  }];
}*/

%ctor {
  libellumPreferencesChanged();

  /*CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)libellumUseWallpaperColors, CFSTR("com.lacertosusrepo.libellumprefs-useWallpaperColors"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerInteger:&noteSize default:121 forKey:@"noteSize"];
  [preferences registerFloat:&cornerRadius default:15 forKey:@"cornerRadius"];

  [preferences registerInteger:&blurStyle default:darkStyle forKey:@"blurStyle"];
  [preferences registerObject:&customBackgroundColor default:@"#000000" forKey:@"customBackgroundColor"];
  [preferences registerObject:&customTextColor default:@"#FFFFFF" forKey:@"customTextColor"];

  [preferences registerObject:&borderColor default:@"FFFFFF" forKey:@"borderColor"];
  [preferences registerFloat:&borderWidth default:0 forKey:@"borderWidth"];

  [preferences registerBool:&requireAuthentication default:NO forKey:@"requireAuthentication"];
  [preferences registerBool:&noteBackup default:NO forKey:@"noteBackup"];

  [preferences registerBool:&hideGesture default:YES forKey:@"hideGesture"];
  [preferences registerBool:&feedback default:YES forKey:@"feedback"];
  [preferences registerInteger:&feedbackStyle default:1520 forKey:@"feedbackStyle"];

  [preferences registerPreferenceChangeBlock:^{
    libellumPreferencesChanged();
  }];*/
}
