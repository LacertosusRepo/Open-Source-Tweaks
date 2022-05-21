@interface SPTPlayerTrack : NSObject
@property(copy, nonatomic) NSURL *URI;
@end

@interface SPTStatefulPlayerImplementation : NSObject
-(SPTPlayerTrack *)currentTrack;
@end

@interface SPTPlaylistCosmosModel : NSObject
-(void)addTrackURLs:(id)arg1 toPlaylistURL:(id)arg2 bySource:(id)arg3 fromContext:(id)arg4 completion:(id)arg5;
-(void)removeTrackURLs:(id)arg1 fromPlaylistURL:(id)arg2 completion:(id)arg3;
-(void)playlistContainsTrackURLs:(id)arg1 playlistURL:(id)arg2 completion:(id)arg3;
@end

@interface SPTProgressView : UIView
+(void)showGaiaContextMenuProgressViewWithTitle:(id)arg1;
@end

@interface SPTPopupDialog : NSObject
+(instancetype)popupWithTitle:(NSString *)arg1 message:(NSString *)arg2 dismissButtonTitle:(NSString *)arg3;
@end

@interface SPTPopupManager : NSObject
@property(nonatomic, readwrite, assign) NSMutableArray *presentationQueue;
+(SPTPopupManager *)sharedManager;
-(void)presentNextQueuedPopup;
@end

@interface SPTNowPlayingButton : UIButton
@property(nonatomic) struct CGSize iconSize;
@property(nonatomic) long long icon;
@property(nonatomic, copy, readwrite) UIColor *iconColor;
-(void)applyIcon;
-(void)setIconColor:(UIColor *)arg1;
@end

@interface GLUEButton : UIButton
@end

@interface VISREFArtworkContentView : UIView
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@end

@interface SPTContextMenuViewController : UIViewController
-(NSURL *)spt_pageURI;
-(NSURL *)trackURL;
@end

@interface SPTNowPlayingFooterUnitViewController : UIViewController
@property (nonatomic, strong, readwrite) UIViewController *rightButtonViewController;

  //SpotifyAddToFavorites
@property (retain, nonatomic) SPTNowPlayingButton *addToPlaylistButton;
-(void)handleButtonPressed:(UIGestureRecognizer *)gesture;
-(void)updateButtonColor;
@end