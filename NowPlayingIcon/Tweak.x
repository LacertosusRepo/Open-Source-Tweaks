/*
 * Tweak.x
 * NowPlayingIcon
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/8/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "MediaRemote.h"
#import "NowPlayingIcon.h"
#import "HBLog.h"

  NSString *lastNowPlayingBundleID;
  UIImage *currentArtwork;
  UIImage *currentMaskedArtwork;

%hook SBIconController
  -(instancetype)initWithApplicationController:(id)arg1 applicationPlaceholderController:(id)arg2 userInterfaceController:(id)arg3 policyAggregator:(id)arg4 alertItemsController:(id)arg5 assistantController:(id)arg6 {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoDidChange) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingAppDidChange) name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationDidChangeNotification object:nil];

    return %orig;
  }

%new
  -(void)nowPlayingInfoDidChange {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        //Check if artwork image is the same
      NSDictionary *nowPlayingInfo = (__bridge NSDictionary *)information;
      NSData *artworkData = [nowPlayingInfo objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
      if(artworkData) {
        NSData *oldArtworkData = UIImageJPEGRepresentation(currentArtwork, 1.0);
        NSData *newArtworkData = UIImageJPEGRepresentation([UIImage imageWithData:artworkData], 1.0);
        if([oldArtworkData isEqualToData:newArtworkData]) {
          //HBLogInfo(@"NowPlayingIcon || Duplicate artwork data");
          return;
        } else {
          currentArtwork = [UIImage imageWithData:artworkData];
        }

        SBIconController *iconController = [%c(SBIconController) sharedInstance];
        SBApplication *nowPlayingApp = [[%c(SBMediaController) sharedInstance] nowPlayingApplication];
        SBApplicationIcon *appIcon = [iconController.model applicationIconForBundleIdentifier:nowPlayingApp.bundleIdentifier];

          //Set artwork for app
        [self setNowPlayingArtworkForApp:appIcon withArtwork:currentArtwork];
        lastNowPlayingBundleID = nowPlayingApp.bundleIdentifier;
      }
    });
  }

%new
  -(void)nowPlayingAppDidChange {
      //Reset last icon when the app has changed or the now playing app is killed
    SBIconController *iconController = [%c(SBIconController) sharedInstance];
    SBApplicationIcon *appIcon = [iconController.model applicationIconForBundleIdentifier:lastNowPlayingBundleID];

    if([appIcon application]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        __NSSingleObjectArrayI *iconsToPurge = [%c(__NSSingleObjectArrayI) arrayWithObjects:appIcon, nil];
        [[iconController.iconManager iconImageCache] purgeCachedImagesForIcons:iconsToPurge];
        [[iconController.iconManager iconImageCache] notifyObserversOfUpdateForIcon:appIcon];
      });
    }
  }

%new
  -(void)setNowPlayingArtworkForApp:(SBApplicationIcon *)appIcon withArtwork:(UIImage *)artwork {
    if(appIcon && artwork) {
      SBHIconImageCache *imageCacheHS = [self.iconManager iconImageCache];
      SBFolderIconImageCache *imageCacheFLDR = [self.iconManager folderIconImageCache];
      NSArray *imageCaches = @[imageCacheHS,
                              self.appSwitcherHeaderIconImageCache,
                              /*self.appSwitcherUnmaskedIconImageCache,
                              self.tableUIIconImageCache,
                              self.notificationIconImageCache,*/];

      CALayer *maskLayer = [CALayer layer];
      maskLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
      maskLayer.contents = (id)imageCacheHS.overlayImage.CGImage;

      CALayer *artLayer = [CALayer layer];
      artLayer.frame = CGRectMake(0, 0, artwork.size.width, artwork.size.height);
      artLayer.contents = (id)artwork.CGImage;
      artLayer.masksToBounds = YES;
      artLayer.mask = maskLayer;

      UIGraphicsBeginImageContext(artwork.size);
      [artLayer renderInContext:UIGraphicsGetCurrentContext()];
      currentMaskedArtwork = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();

        //Update icon image caches and notify
      for(SBHIconImageCache *cache in imageCaches) {
        [cache cacheImage:currentMaskedArtwork forIcon:appIcon];
        [cache notifyObserversOfUpdateForIcon:appIcon];
      }

      [imageCacheFLDR iconImageCache:imageCacheHS didUpdateImageForIcon:appIcon];
    }
  }
%end

%hook SBIconImageCrossfadeView
  //iOS 13
  -(instancetype)initWithImageView:(SBIconImageView *)arg1 crossfadeView:(UIView *)arg2 {
    SBIcon *icon = [arg1 icon];
    SBApplication *nowPlayingApp = [[%c(SBMediaController) sharedInstance] nowPlayingApplication];
    if([[icon applicationBundleID] isEqualToString:nowPlayingApp.bundleIdentifier] && currentMaskedArtwork) {
      arg1.layer.contents = (id)currentMaskedArtwork.CGImage;
    }

    return %orig;
  }

  //iOS 14
  -(instancetype)initWithSource:(SBIconImageView *)arg1 crossfadeView:(UIView *)arg2 {
    SBIcon *icon = [arg1 icon];
    SBApplication *nowPlayingApp = [[%c(SBMediaController) sharedInstance] nowPlayingApplication];
    if([[icon applicationBundleID] isEqualToString:nowPlayingApp.bundleIdentifier] && currentMaskedArtwork) {
      arg1.layer.contents = (id)currentMaskedArtwork.CGImage;
    }

    return %orig;
  }
%end
