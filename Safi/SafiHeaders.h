enum blurOptions {
  noBlur = 0,
  darkBlur,
  lightBlur,
  extraLightBlur,
};

@interface SBFloatyFolderView : UIView
@end

@interface SBFolderBackgroundView
@property (nonatomic, assign, readwrite) CGFloat alpha;
@end

@interface SBFolderControllerBackgroundView
@property (nonatomic, assign, readwrite) CGFloat alpha;
@end

@interface SBIconController : NSObject
+(id)sharedInstance;
-(void)_closeFolderController:(id)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3;
@end

@interface SBIconListPageControl
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface SBRootFolderView : UIView
@property (nonatomic, assign, readwrite) CGFloat alpha;
@end
