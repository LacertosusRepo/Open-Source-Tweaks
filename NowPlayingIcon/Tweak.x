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
  NSString *lastNowPlayingBunldeID;
  UIImage *artwork;
  CALayer *artLayer;
  CALayer *maskLayer;

void nowPlayingInfoDidChange() {
  nowPlayingApp = [[NSClassFromString(@"SBMediaController") sharedInstance] nowPlayingApplication];
  if(iconController) {
    if((![nowPlayingApp.bundleIdentifier isEqualToString:lastNowPlayingBunldeID] && [lastNowPlayingBunldeID length] > 0) || !nowPlayingApp)  {
      __NSSingleObjectArrayI *purgeTheseIcons = [NSClassFromString(@"__NSSingleObjectArrayI") arrayWithObjects:appIcon, nil];
      //NSLog(@"%@ || %@ || %@", nowPlayingApp, [appIcon applicationBundleID], purgeTheseIcons);
      [[iconController.iconManager iconImageCache] purgeCachedImagesForIcons:purgeTheseIcons];
      [[iconController.iconManager iconImageCache] notifyObserversOfUpdateForIcon:appIcon];
    }

    [iconController setNowPlayingArtworkForApp:nowPlayingApp];
    lastNowPlayingBunldeID = nowPlayingApp.bundleIdentifier;
  }
}

void logginIt(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  NSLog(@"center - %@", center);
  NSLog(@"observer - %@", observer);
  NSLog(@"name - %@", name);
  NSLog(@"object - %@", object);
  NSLog(@"userInfo - %@", userInfo);
}

%hook SBIconController
  -(id)initWithApplicationController:(id)arg1 applicationPlaceholderController:(id)arg2 userInterfaceController:(id)arg3 policyAggregator:(id)arg4 alertItemsController:(id)arg5 assistantController:(id)arg6 {

      //the-casle ♥ Straw
      //https://github.com/the-casle/straw/blob/master/TCMediaNotificationController.mm#L214-L220
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, nowPlayingInfoDidChange, (__bridge CFStringRef)@"com.apple.springboard.nowPlayingAppChanged", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    appIcon = [NSClassFromString(@"SBApplicationIcon") alloc];

    return iconController = %orig;
  }

%new
  -(void)setNowPlayingArtworkForApp:(SBApplication *)app {
    if(app) {
      appIcon = [appIcon initWithApplication:app];

      MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *nowPlayingInfo = (__bridge NSDictionary *)information;
        NSData *artworkData = [nowPlayingInfo objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];

        if(artworkData) {
          NSData *oldArtworkData = UIImageJPEGRepresentation(artwork, 1.0);
          NSData *newArtworkData = UIImageJPEGRepresentation([UIImage imageWithData:artworkData], 1.0);
          if([oldArtworkData isEqualToData:newArtworkData]) {
            NSLog(@"NowPlayingIcon || Duplicate artwork data");
            return;
          }

          SBHIconImageCache *hsImageCache = [self.iconManager iconImageCache];
          NSArray *imageCaches = @[hsImageCache,
                                  self.appSwitcherHeaderIconImageCache,
                                  /*self.appSwitcherUnmaskedIconImageCache,
                                  self.tableUIIconImageCache,
                                  self.notificationIconImageCache,*/];

          artwork = [UIImage imageWithData:artworkData];

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
          UIImage *artworkIcon = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();

          for(SBHIconImageCache *cache in imageCaches) {
            [cache cacheImage:artworkIcon forIcon:appIcon];
            [cache notifyObserversOfUpdateForIcon:appIcon];
          }

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
  if([[icon applicationBundleID] isEqualToString:nowPlayingApp.bundleIdentifier] && artwork) {
    arg1.layer.contents = (id)artwork.CGImage;
  }

  return %orig;
}
%end
