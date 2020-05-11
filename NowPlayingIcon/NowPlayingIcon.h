/*
 * NowPlayingIcon.h
 * NowPlayingIcon
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/8/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
//#import <Cephei/HBPreferences.h>
#import "MediaRemote.h"

struct SBIconImageInfo {
    CGSize size;
    CGFloat scale;
    CGFloat continuousCornerRadius;
};

@interface __NSSingleObjectArrayI : NSArray
@end

@interface SBIcon : NSObject
-(NSString *)applicationBundleID;
@end

@interface SBIconView : UIView
@end

@interface SBIconImageView : UIView
-(void)clearCachedImages;
-(SBIconView *)iconView;
-(SBIcon *)icon;
-(id)contentsImage;
@end

@interface SBIconImageCrossfadeView : UIView
@property (nonatomic, readonly) SBIconImageView *iconImageView;
@property (nonatomic, readonly) UIView *containerView;
@end

@interface SBApplication : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end

@interface SBApplicationIcon : SBIcon
-(id)initWithApplication:(SBApplication *)arg1;
-(void)reloadIconImage;
@end

@interface SBMediaController : NSObject
+(id)sharedInstance;
-(SBApplication *)nowPlayingApplication;
@end

@interface SBHIconImageCache : NSObject
@property (nonatomic, readonly) struct SBIconImageInfo iconImageInfo;
@property (nonatomic, readonly) UIImage *overlayImage;
-(void)cacheImage:(UIImage *)arg1 forIcon:(SBApplicationIcon *)arg2;
-(void)iconImageDidUpdate:(SBApplicationIcon *)arg1;
-(void)notifyObserversOfUpdateForIcon:(SBApplicationIcon *)arg1;
-(void)purgeCachedImagesForIcons:(id)arg1;
-(void)purgeAllCachedImages;
-(UIImage *)imageForIcon:(SBApplicationIcon *)arg1;
@end

@interface SBHIconManager : NSObject
-(SBHIconImageCache *)iconImageCache;
@end

@interface SBIconController : NSObject
@property (nonatomic, readonly) SBHIconManager *iconManager;
@property (nonatomic, readonly) SBHIconImageCache *appSwitcherHeaderIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *appSwitcherUnmaskedIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *tableUIIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *notificationIconImageCache;
  //NowPlayingIcon
-(void)setNowPlayingArtworkForApp:(SBApplication *)app;
@end
