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

  static NSInteger blurStyle;
  static NSString *customTextColor;
  static NSString *customBackgroundColor;
  static NSInteger noteSize;
  static BOOL requireAuthentication;

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
    self.LBMNoteView.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *stackView = [self valueForKey:@"_stackView"];
    [stackView insertArrangedSubview:self.LBMNoteView atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
      [self.LBMNoteView.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor constant:10],
      [self.LBMNoteView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:-10],
      [self.LBMNoteView.heightAnchor constraintEqualToConstant:noteSize],
    ]];
  }

%new
  -(void)dismissLibellum {
    UIStackView *stackView = [self valueForKey:@"_stackView"];
    [stackView removeArrangedSubview:self.LBMNoteView];
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

  /*
   * Update Preferences
   */
static void libellumPreferencesChanged() {
  LibellumView *LBMNoteView = [LibellumView sharedInstance];
  LBMNoteView.blurStyle = blurStyle;
  LBMNoteView.customTextColor = LCPParseColorString(customTextColor, @"#FFFFFF");
  LBMNoteView.customBackgroundColor = LCPParseColorString(customBackgroundColor, @"#000000");
  LBMNoteView.noteSize = noteSize;
  LBMNoteView.requireAuthentication = requireAuthentication;
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
  [preferences registerObject:&customTextColor default:@"#FFFFFF" forKey:@"customTextColor"];
  [preferences registerObject:&customBackgroundColor default:@"#000000" forKey:@"customBackgroundColor"];
  [preferences registerInteger:&noteSize default:120 forKey:@"noteSize"];
  [preferences registerBool:&requireAuthentication default:NO forKey:@"requireAuthentication"];

  [preferences registerPreferenceChangeBlock:^{
    libellumPreferencesChanged();
  }];
}
