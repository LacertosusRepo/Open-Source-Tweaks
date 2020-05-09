/*
 * Tweak.x
 * NowPlayingIcon
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/8/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "NowPlayingIcon.h"

  SBIconController *iconController;
  SBApplicationIcon *appIcon;
  SBApplication *nowPlayingApp;
  CALayer *maskLayer;
  CALayer *artLayer;
  static BOOL weightOver = YES;
  static NSString *latestNowPlayingBundleID;

void nowPlayingInfoDidChange() {
  nowPlayingApp = [[NSClassFromString(@"SBMediaController") sharedInstance] nowPlayingApplication];
  if(iconController && nowPlayingApp && weightOver) {
    if(![nowPlayingApp.bundleIdentifier isEqualToString:latestNowPlayingBundleID] && [latestNowPlayingBundleID length] > 0)  {
      __NSSingleObjectArrayI *purgeTheseIcons = [NSClassFromString(@"__NSSingleObjectArrayI") arrayWithObjects:appIcon, nil];
      [[iconController.iconManager iconImageCache] purgeCachedImagesForIcons:purgeTheseIcons];
      [[iconController.iconManager iconImageCache] notifyObserversOfUpdateForIcon:appIcon];
    }

    [iconController setNowPlayingArtworkForApp:nowPlayingApp];
    latestNowPlayingBundleID = nowPlayingApp.bundleIdentifier;

    weightOver = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      weightOver = YES;
    });
  }
}

%hook SBHIconImageCache
-(void)cacheImageForIcon:(id)arg1 options:(unsigned long long)arg2 completionHandler:(/*^block*/id)arg3 {
    %orig;
    %log;
    NSLog(@"icon %@", arg1);
    NSLog(@"options %llu", arg2);
  }
%end

%hook SBIconController
  -(id)initWithApplicationController:(id)arg1 applicationPlaceholderController:(id)arg2 userInterfaceController:(id)arg3 policyAggregator:(id)arg4 alertItemsController:(id)arg5 assistantController:(id)arg6 {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, nowPlayingInfoDidChange, (__bridge CFStringRef)@"com.apple.springboard.nowPlayingAppChanged", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    appIcon = [NSClassFromString(@"SBApplicationIcon") alloc];

    return iconController = %orig;
  }

%new
  -(void)setNowPlayingArtworkForApp:(SBApplication *)app {
    if(app) {
      MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *nowPlayingInfo = (__bridge NSDictionary *)information;
        NSData *artworkData = [nowPlayingInfo objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
        if(artworkData) {
          SBHIconImageCache *hsImageCache = [self.iconManager iconImageCache];
          UIImage *artwork = [UIImage imageWithData:artworkData];
          NSArray *imageCaches = @[self.appSwitcherHeaderIconImageCache,
                                  /*self.appSwitcherUnmaskedIconImageCache,
                                  self.tableUIIconImageCache,
                                  self.notificationIconImageCache,*/
                                  [self.iconManager iconImageCache]];

          maskLayer = (maskLayer) ? maskLayer : [CALayer layer];
          maskLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
          maskLayer.contents = (id)hsImageCache.overlayImage.CGImage;

          artLayer = (artLayer) ? artLayer : [CALayer layer];
          artLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
          artLayer.contents = (id)artwork.CGImage;
          artLayer.masksToBounds = YES;
          artLayer.mask = maskLayer;

          UIGraphicsBeginImageContext(artwork.size);
          [artLayer renderInContext:UIGraphicsGetCurrentContext()];
          artwork = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();

          appIcon = [[NSClassFromString(@"SBApplicationIcon") alloc] initWithApplication:app];
          for(SBHIconImageCache *cache in imageCaches) {
            [cache cacheImage:artwork forIcon:appIcon];
            [cache notifyObserversOfUpdateForIcon:appIcon];
          }
        }
      });
    }
  }
%end
