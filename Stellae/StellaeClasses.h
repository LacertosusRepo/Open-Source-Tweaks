@interface PCSimpleTimer : NSObject
@property (assign, nonatomic) BOOL disableSystemWaking;
-(id)initWithTimeInterval:(double)arg1 serviceIdentifier:(id)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
-(id)initWithFireDate:(id)arg1 serviceIdentifier:(id)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
-(void)scheduleInRunLoop:(id)arg1;
-(void)invalidate;
-(BOOL)isValid;
@end

@interface SBHomeScreenViewController : UIViewController
@property (nonatomic, retain) PCSimpleTimer *apolloTimer;
-(void)createTimer;
-(void)setStellaeWallpaper;
@end

@interface SBWallpaperController : NSObject
+(id)sharedInstance;
-(UIView *)homescreenWallpaperView;
-(UIView *)lockscreenWallpaperView;
@end

@interface SBAlertItem : NSObject
@end

@interface StellaeInitialAlertItem : SBAlertItem
+(void)activateAlertItem:(id)arg1;
-(id)alertController;
-(void)setIconImage:(UIImage *)arg1;
-(void)_setAttachmentImage:(id)arg1;
-(void)dismiss;
@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end
