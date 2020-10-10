@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite) NSUInteger recipe;
@property (assign, nonatomic) BOOL recipeDynamic;
+(instancetype)materialViewWithRecipeNamed:(id)arg1 inBundle:(id)arg2 configuration:(long long)arg3 initialWeighting:(double)arg4 scaleAdjustment:(/*^block*/id)arg5 ;
@end
