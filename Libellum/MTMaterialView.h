typedef NS_ENUM(NSInteger, MTMaterialRecipe) {
    MTMaterialRecipeNone,
    MTMaterialRecipeNotifications,
    MTMaterialRecipeWidgetHosts,
    MTMaterialRecipeWidgets,
    MTMaterialRecipeControlCenterModules,
    MTMaterialRecipeSwitcherContinuityItem,
    MTMaterialRecipePreviewBackground,
    MTMaterialRecipeNotificationsDark,
    MTMaterialRecipeControlCenterModulesSheer
};

typedef NS_OPTIONS(NSUInteger, MTMaterialOptions) {
    MTMaterialOptionsNone             = 0,
    MTMaterialOptionsGamma            = 1 << 0,
    MTMaterialOptionsBlur             = 1 << 1,
    MTMaterialOptionsZoom             = 1 << 2,
    MTMaterialOptionsLuminanceMap     = 1 << 3,
    MTMaterialOptionsBaseOverlay      = 1 << 4,
    MTMaterialOptionsPrimaryOverlay   = 1 << 5,
    MTMaterialOptionsSecondaryOverlay = 1 << 6,
    MTMaterialOptionsAuxiliaryOverlay = 1 << 7,
    MTMaterialOptionsCaptureOnly      = 1 << 8
};

@interface MTMaterialView : UIView
@property (assign, nonatomic) BOOL recipeDynamic;
@property (nonatomic, assign, readwrite) NSUInteger recipe;
+(instancetype)materialViewWithRecipeNamed:(NSString *)arg1 inBundle:(NSBundle *)arg2 configuration:(NSInteger)arg3 initialWeighting:(float)arg4 scaleAdjustment:(id)arg5;
+(instancetype)materialViewWithRecipe:(NSInteger)arg1 configuration:(NSInteger)arg2;
+(instancetype)materialViewWithRecipe:(NSInteger)arg1 options:(NSInteger)arg2;
@end
