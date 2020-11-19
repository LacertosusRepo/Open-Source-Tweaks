#import "LibellumView.h"

@interface CSNotificationAdjunctListViewController : UIViewController
@property (nonatomic, retain) UIStackView *stackView;
@property (nonatomic, assign) CGSize sizeToMimic;
@property (nonatomic, retain) LibellumView *libellum;
@end

@interface CSQuickActionsViewController : UIViewController
@end

@interface CSScrollView : UIScrollView
@end

@interface SBDashBoardNotificationAdjunctListViewController : UIViewController
@property (nonatomic, retain) UIStackView *stackView;
@property (nonatomic, assign) CGSize sizeToMimic;
@property (nonatomic, retain) LibellumView *libellum;
@end

@interface SBDashBoardQuickActionsViewController : UIViewController
@end

@interface SBPagedScrollView : UIScrollView
@end

@interface NCNotificationListSectionRevealHintView : UIView
@end
