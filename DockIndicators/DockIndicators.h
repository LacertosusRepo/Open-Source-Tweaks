typedef NS_ENUM(NSInteger, DIPNotificationAnimationType) {
  DIPNotificationAnimationTypeNone,
  DIPNotificationAnimationTypeBounce,
  DIPNotificationAnimationTypeShakeX,
  DIPNotificationAnimationTypeShakeY,
  DIPNotificationAnimationTypeGlow,
  DIPNotificationAnimationTypeHeartbeat,
  DIPNotificationAnimationTypePulse,
};

@interface SBIcon : NSObject
@property (readonly, nonatomic) NSInteger badgeValue;
@end

@interface SBApplicationIcon : SBIcon
-(id)application;
@end

@interface SBApplicationProcessState : NSObject
@property (getter=isRunning, nonatomic, readonly) BOOL running;
@end

@interface SBApplication : NSObject
@property (nonatomic, readonly) SBApplicationProcessState *processState;
@end

@interface SBFolderIcon : SBIcon
@end

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, readonly) UIImage *iconImageSnapshot;
@property (nonatomic, strong, readwrite) id folderIcon;
//@property (retain, nonatomic) SBFolderIcon *folderIcon; // ivar: _folderIcon //ios16
@property (nonatomic, copy, readonly) NSString *applicationBundleIdentifierForShortcuts;

  //DockIndicators
@property (nonatomic, retain) UIView *runningIndicator;
@end

@interface SBIconListView : UIView
@end

@interface SBDockIconListView : SBIconListView

  //DockIndicators
-(void)updateRunningIndicators:(NSNotification *)notification;
@end