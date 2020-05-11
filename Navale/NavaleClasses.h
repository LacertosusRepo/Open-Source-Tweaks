#import "ColorFlowAPI.h"

enum gradientDirections {
  verticle = 0,
  horizontal
};

@interface SBDockView : UIView
@property (nonatomic, copy) UIColor *primaryColor;
@property (nonatomic, copy) UIColor *secondaryColor;
-(void)updateGradient;
@end

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic, copy) UIColor *primaryColor;
@property (nonatomic, copy) UIColor *secondaryColor;
-(double)maximumContinuousCornerRadius;
-(void)updateGradient;
@end

@interface SBWallpaperEffectView : UIView
@property (nonatomic,retain) UIView * blurView;
@end

@interface MTMaterialLayer : CALayer
@end

@interface MTMaterialView : UIView
@property (getter=_materialLayer,nonatomic,readonly) MTMaterialLayer *materialLayer;
@property (assign, nonatomic) double weighting;
@end

@interface _UIBackdropEffectView : UIView
@end

@interface _UIBackdropView : UIView
@property (nonatomic, retain) _UIBackdropEffectView * backdropEffectView;
-(double)_cornerRadius;
@end
