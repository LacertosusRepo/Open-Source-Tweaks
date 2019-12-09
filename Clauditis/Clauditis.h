@interface SBIconController : UIViewController
+(id)sharedInstance;
-(BOOL)isEditing;

  //iOS 13
-(id)iconManager;
@end

@interface SpringBoard : NSObject
-(void)_simulateLockButtonPress;
@end

@interface SBHomeScreenViewController : UIViewController
@end
