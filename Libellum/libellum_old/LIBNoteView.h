@interface LIBNoteView : UIWindow <UITextViewDelegate>
@property(nonatomic, assign) UIView *view;
@property(nonatomic, assign) UITextView *textView;
@property(nonatomic, assign) CGRect noteViewSavedPosition;
@property(nonatomic, assign) BOOL isEditing;
@property(nonatomic, readonly) BOOL authenticated;
+(id)sharedInstance;
-(void)showNoteView;
-(void)hideNoteView;
@end
