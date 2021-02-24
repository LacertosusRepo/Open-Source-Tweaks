#import <UIKit/UIKit.h>

@interface __NSSingleObjectArrayI : NSArray
@end

@interface SBIcon : NSObject
-(NSString *)applicationBundleID;
-(id)application;
-(id)parentFolderIcon;
@end

@interface SBIconView : UIView
@end

@interface SBIconImageView : UIView
-(SBIcon *)icon;
@end

@interface SBIconImageCrossfadeView : UIView
@end

@interface SBApplication : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end

@interface SBApplicationIcon : SBIcon
@end

@interface SBIconModel : NSObject
-(SBApplicationIcon *)applicationIconForBundleIdentifier:(NSString *)arg1;
@end

@interface SBMediaController : NSObject
+(id)sharedInstance;
-(SBApplication *)nowPlayingApplication;
@end

@interface SBHIconImageCache : NSObject
@property (nonatomic, readonly) UIImage *overlayImage;
-(void)cacheImage:(UIImage *)arg1 forIcon:(SBApplicationIcon *)arg2;
-(void)notifyObserversOfUpdateForIcon:(SBApplicationIcon *)arg1;
-(void)purgeCachedImagesForIcons:(id)arg1;
@end

@interface SBFolderIconImageCache : NSObject
-(void)iconImageCache:(id)arg1 didUpdateImageForIcon:(id)arg2;
@end

@interface SBHIconManager : NSObject
-(SBHIconImageCache *)iconImageCache;
-(SBFolderIconImageCache *)folderIconImageCache;
@end

@interface SBIconController : NSObject
@property (nonatomic, readonly) SBHIconManager *iconManager;
@property (nonatomic, readonly) SBHIconImageCache *appSwitcherHeaderIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *appSwitcherUnmaskedIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *tableUIIconImageCache;
@property (nonatomic, readonly) SBHIconImageCache *notificationIconImageCache;
@property (nonatomic, retain) SBIconModel *model;
+(instancetype)sharedInstance;

  //NowPlayingIcon
-(void)setNowPlayingArtworkForApp:(SBApplicationIcon *)appIcon withArtwork:(UIImage *)artwork;
@end
