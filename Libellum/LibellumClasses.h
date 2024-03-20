@interface CSNotificationAdjunctListViewController : UIViewController
@property(nonatomic, retain) UIStackView *stackView;
@property (nonatomic, assign) CGSize sizeToMimic;
@end

@interface CSQuickActionsViewController : UIViewController
@end

@interface CSScrollView : UIScrollView
@end

@interface SBDashBoardNotificationAdjunctListViewController : UIViewController
@property (nonatomic, retain) UIStackView *stackView;
@property (nonatomic, assign) CGSize sizeToMimic;
@end

@interface SBDashBoardQuickActionsViewController : UIViewController
@end

@interface SBPagedScrollView : UIScrollView
@end

@interface NCNotificationListSectionRevealHintView : UIView
@end

@interface UISUserInterfaceStyleMode : NSObject
@property (nonatomic, assign) long long modeValue;
@end
