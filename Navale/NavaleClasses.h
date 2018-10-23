enum gradientDirections {
  verticle = 0,
  horizontal
};

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBDockView : UIView
@end

@interface SBFloatingDockPlatterView : UIView
@end

@interface SBWallpaperEffectView : UIView
@property (nonatomic,retain) UIView * blurView;
@end

@interface _UIBackdropEffectView : UIView
@end

@interface _UIBackdropView : UIView
@property (nonatomic, retain) _UIBackdropEffectView * backdropEffectView;
-(double)_cornerRadius;
@end
