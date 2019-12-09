#import "LibellumView.h"

@interface CSNotificationAdjunctListViewController : UIViewController
@property (nonatomic, retain) UIStackView *stackView;
@property (nonatomic, assign) CGSize sizeToMimic;
@property (nonatomic, retain) LibellumView *LBMNoteView;
-(void)_removeItem:(id)arg1 animated:(BOOL)arg2;
-(void)_insertItem:(id)arg1 animated:(BOOL)arg2;
@end

@interface CSScrollView : UIScrollView
@end
