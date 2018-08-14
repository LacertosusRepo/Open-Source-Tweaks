@interface _UIBackdropView : UIView
@property (nonatomic, assign, readwrite) CGFloat alpha;
@property (nonatomic, assign, readwrite) CGFloat brightness;
@property (nonatomic, copy, readwrite) UIColor * colorAddColor;
-(void)setSaturation:(CGFloat)arg1;
@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface MediaControlsMaterialView
@property (nonatomic, assign, readwrite) CGFloat alpha;
@end

@interface MTMaterialView : UIView
-(id)_mtBackdropView;
@end

@interface CCUIHeaderPocketView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property (nonatomic, retain) UIView * view;
@end
