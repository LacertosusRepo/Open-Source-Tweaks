/*
 * Tweak.x
 * NowPlayingIcon
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/8/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "NowPlayingIcon.h"

  SBApplicationIcon *appIcon;
  SBApplication *nowPlayingApp;
  NSString *lastNowPlayingBunldeID;
  UIImage *artwork;
  UIImage *maskedArtwork;
  CALayer *artLayer;
  CALayer *maskLayer;

void nowPlayingInfoDidChange() {
  nowPlayingApp = [[NSClassFromString(@"SBMediaController") sharedInstance] nowPlayingApplication];
  if(![nowPlayingApp.bundleIdentifier isEqualToString:lastNowPlayingBunldeID] || !nowPlayingApp)  {
    if([appIcon application]) {
      __NSSingleObjectArrayI *purgeTheseIcons = [NSClassFromString(@"__NSSingleObjectArrayI") arrayWithObjects:appIcon, nil];
      [[((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]).iconManager iconImageCache] purgeCachedImagesForIcons:purgeTheseIcons];
      [[((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]).iconManager iconImageCache] notifyObserversOfUpdateForIcon:appIcon];
      //os_log(OS_LOG_DEFAULT, "%@ || %@ || %@", nowPlayingApp, [appIcon applicationBundleID], purgeTheseIcons);
      maskedArtwork = nil;

    } else {
      os_log(OS_LOG_DEFAULT, "NowPlayingIcon || SBApplicationIcon is not initialized with any application");
    }
  }

  [[NSClassFromString(@"SBIconController") sharedInstance] setNowPlayingArtworkForApp:nowPlayingApp];
  lastNowPlayingBunldeID = nowPlayingApp.bundleIdentifier;
}

%hook SBIconController
  -(id)initWithApplicationController:(id)arg1 applicationPlaceholderController:(id)arg2 userInterfaceController:(id)arg3 policyAggregator:(id)arg4 alertItemsController:(id)arg5 assistantController:(id)arg6 {
      //the-casle ♥ Straw
      //https://github.com/the-casle/straw/blob/master/TCMediaNotificationController.mm#L214-L220
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, nowPlayingInfoDidChange, (__bridge CFStringRef)@"com.apple.springboard.nowPlayingAppChanged", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    return %orig;
  }

%new
  -(void)setNowPlayingArtworkForApp:(SBApplication *)app {
    if(app) {
      appIcon = [((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]).model applicationIconForBundleIdentifier:app.bundleIdentifier];

      MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *nowPlayingInfo = (__bridge NSDictionary *)information;
        NSData *artworkData = [nowPlayingInfo objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];

        if(artworkData) {
          NSData *oldArtworkData = UIImageJPEGRepresentation(artwork, 1.0);
          NSData *newArtworkData = UIImageJPEGRepresentation([UIImage imageWithData:artworkData], 1.0);
          if([oldArtworkData isEqualToData:newArtworkData]) {
            os_log(OS_LOG_DEFAULT, "NowPlayingIcon || Duplicate artwork data");
            return;
          }

          SBHIconImageCache *imageCacheHS = [self.iconManager iconImageCache];
          SBFolderIconImageCache *imageCacheFLDR = [self.iconManager folderIconImageCache];
          NSArray *imageCaches = @[imageCacheHS,
                                  self.appSwitcherHeaderIconImageCache,
                                  /*self.appSwitcherUnmaskedIconImageCache,
                                  self.tableUIIconImageCache,
                                  self.notificationIconImageCache,*/];

          artwork = [UIImage imageWithData:artworkData];

          maskLayer = (maskLayer) ? maskLayer : [CALayer layer];
          maskLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
          maskLayer.contents = (id)imageCacheHS.overlayImage.CGImage;

          artLayer = (artLayer) ? artLayer : [CALayer layer];
          artLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
          artLayer.contents = (id)artwork.CGImage;
          artLayer.masksToBounds = YES;
          artLayer.mask = maskLayer;

          UIGraphicsBeginImageContext(artwork.size);
          [artLayer renderInContext:UIGraphicsGetCurrentContext()];
          maskedArtwork = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();

            //Update icon image caches
          for(SBHIconImageCache *cache in imageCaches) {
            [cache cacheImage:maskedArtwork forIcon:appIcon];
            [cache notifyObserversOfUpdateForIcon:appIcon];
          }

          [imageCacheFLDR iconImageCache:imageCacheHS didUpdateImageForIcon:appIcon];

        } else {
          artwork = nil;
        }
      });
    }
  }
%end

%hook SBIconImageCrossfadeView
  -(id)initWithImageView:(SBIconImageView *)arg1 crossfadeView:(UIView *)arg2 {
    SBIcon *icon = [arg1 icon];
    if([[icon applicationBundleID] isEqualToString:nowPlayingApp.bundleIdentifier] && maskedArtwork) {
      arg1.layer.contents = (id)maskedArtwork.CGImage;
    }

    return %orig;
  }
%end
