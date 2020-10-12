typedef NS_ENUM(NSInteger, DIPNotificationAnimationType) {
  DIPNotificationAnimationTypeNone,
  DIPNotificationAnimationTypeBounce,
  DIPNotificationAnimationTypeShakeX,
  DIPNotificationAnimationTypeShakeY,
  DIPNotificationAnimationTypeGlow,
  DIPNotificationAnimationTypeHeartbeat,
};

@interface SBIcon : NSObject
@property (nonatomic, readonly) NSInteger badgeValue;
@end

@interface SBApplicationIcon : SBIcon
@end

@interface SBApplicationProcessState : NSObject
@property (getter=isRunning, nonatomic, readonly) BOOL running;
@end

@interface SBApplication : NSObject
@property (nonatomic, readonly) SBApplicationProcessState *processState;
@end

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, readonly) UIImage *iconImageSnapshot;
@property (nonatomic, strong, readwrite) id folderIcon;
@property (nonatomic, copy, readonly) NSString *applicationBundleIdentifierForShortcuts;

  //DockIndicators
@property (nonatomic, retain) UIView *runningIndicator;
@end

@interface SBIconListView : UIView
@end

@interface SBDockIconListView : SBIconListView
@end
