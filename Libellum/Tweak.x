/*
 * Tweak.x
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "LibellumView.h"
#import "LibellumClasses.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

    /*
     * Preferences Variables
     */
  static NSInteger blurStyle;
  static NSString *customBackgroundColor;
  static NSString *customTextColor;
  static CGFloat cornerRadius;
  static NSInteger noteSize;
  static BOOL requireAuthentication;
  static BOOL hideGesture;
  static BOOL feedback;
  static NSInteger feedbackStyle;

  /*
   * Add Libellum to the Lockscreen
   * Axon - Nepeta https://github.com/Nepeta/Axon/blob/master/Tweak/Tweak.xm
   */
%hook SBDashBoardNotificationAdjunctListViewController
%property (nonatomic, retain) LibellumView *LBMNoteView;
  -(void)viewDidLoad {
    %orig;

    [self insertLibellum];
  }

%new
  -(void)insertLibellum {
    self.LBMNoteView = [[LibellumView sharedInstance] initWithFrame:CGRectZero];

    UIStackView *stackView = [self valueForKey:@"_stackView"];
    [stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
      [self.LBMNoteView.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor constant:10],
      [self.LBMNoteView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:-10],
      [self.LBMNoteView.heightAnchor constraintEqualToConstant:noteSize],
    ]];
  }
%end

%hook SBLockStateAggregator
  -(void)_updateLockState {
    %orig;

    if(requireAuthentication) {
      [[LibellumView sharedInstance] authenticationStatusFromAggregator:self];
    }

  }
%end

%hook SBPagedScrollView
  -(id)initWithFrame:(CGRect)arg1 {
    UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:[LibellumView sharedInstance] action:@selector(toggleLibellum)];
    dismissGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:dismissGesture];

    return %orig;
  }
%end

  /*
   * Update Preferences
   */
static void libellumPreferencesChanged() {
  LibellumView *LBMNoteView = [LibellumView sharedInstance];
  LBMNoteView.blurStyle = blurStyle;
  LBMNoteView.customBackgroundColor = LCPParseColorString(customBackgroundColor, @"#000000");
  LBMNoteView.customTextColor = LCPParseColorString(customTextColor, @"#FFFFFF");
  LBMNoteView.noteSize = noteSize;
  LBMNoteView.requireAuthentication = requireAuthentication;
  LBMNoteView.hideGesture = hideGesture;
  LBMNoteView.feedback = feedback;
  LBMNoteView.feedbackStyle = feedbackStyle;
  LBMNoteView.cornerRadius = cornerRadius;
  [LBMNoteView preferencesChanged];
}

static void speculumUseWallpaperColors() {
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
  }];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)speculumUseWallpaperColors, CFSTR("com.lacertosusrepo.libellumprefs-useWallpaperColors"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.libellumprefs"];
  [preferences registerInteger:&blurStyle default:UIBlurEffectStyleLight forKey:@"blurStyle"];
  [preferences registerFloat:&cornerRadius default:15 forKey:@"cornerRadius"];

  [preferences registerObject:&customBackgroundColor default:@"#000000" forKey:@"customBackgroundColor"];
  [preferences registerObject:&customTextColor default:@"#FFFFFF" forKey:@"customTextColor"];
  [preferences registerInteger:&noteSize default:120 forKey:@"noteSize"];
  [preferences registerBool:&requireAuthentication default:NO forKey:@"requireAuthentication"];

  [preferences registerBool:&hideGesture default:YES forKey:@"hideGesture"];
  [preferences registerBool:&feedback default:YES forKey:@"feedback"];
  [preferences registerInteger:&feedbackStyle default:1520 forKey:@"feedbackStyle"];

  [preferences registerPreferenceChangeBlock:^{
    libellumPreferencesChanged();
  }];
}
