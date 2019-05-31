  //UILabels
@interface GLUELabel : UILabel
@end

  //UIButtons
@interface SPTNowPlayingButton : UIButton
@property(nonatomic) struct CGSize iconSize;
@property(nonatomic) long long icon;
@property(nonatomic, copy, readwrite) UIColor *iconColor;
-(void)applyIcon;
-(void)setIconColor:(UIColor *)arg1;
@end

  //UIViews
@interface GLUEEntityRowContentView : UIView
@property(readonly, nonatomic) GLUELabel *subtitleLabel;
@property(readonly, nonatomic) GLUELabel *titleLabel;
@end

@interface SPTFreeTierPlaylistHeaderContentView : UIView
@property(retain, nonatomic) GLUELabel *titleLabel;
@end

  //NSObjects
@interface SPTPlaylistCosmosModel : NSObject
@property (nonatomic) NSArray *tracks;
-(void)addTrackURLs:(id)arg1 toPlaylistURL:(id)arg2 completion:(id)arg3;
-(void)removeTrackURLs:(id)arg1 fromPlaylistURL:(id)arg2 completion:(id)arg3;
-(void)playlistContainsTrackURLs:(id)arg1 playlistURL:(id)arg2 completion:(id)arg3;
@end

@interface SPTStatefulPlayer : NSObject
-(id)currentTrack;
@end

@interface SPTPlayerTrack : NSObject
@property(copy, nonatomic) NSURL *URI;
@property(copy, nonatomic) NSURL *contextSource;
@property(retain, nonatomic) NSString *advertiserTitle;
@end

@interface SPTNowPlayingTrackPosition : NSObject
@property(nonatomic) CGFloat currentTrackProgress;
@property(nonatomic) CGFloat trackLength;
@end

@interface SPTStationViewModel : NSObject
@property(readonly, nonatomic) NSArray *trackURIs;
@end

@interface SPTFreeTierPlaylistHeaderConfigurator : NSObject
@property(retain, nonatomic) SPTFreeTierPlaylistHeaderContentView *contentView;
@end

@interface SPTFreeTierCollectionSongsViewModelImplementation : NSObject
-(id)trackURIAtIndexPath:(id)arg1;
@end

@interface SPTPopupButton : NSObject
+(id)buttonWithTitle:(NSString *)arg1;
+(id)buttonWithTitle:(NSString *)arg1 actionHandler:(id)arg2;
@end

@interface SPTPopupManager : NSObject
@property(nonatomic, readwrite, assign) NSMutableArray *presentationQueue;
+(SPTPopupManager *)sharedManager;
-(void)presentNextQueuedPopup;
@end

@interface SPTPlaylistPlatformPlaylistTrackFieldsImplementation : NSObject
@property(retain, nonatomic) NSURL *URL;
@end

@interface SPTNowPlayingInformationUnitViewModelImplementation : NSObject
@property(nonatomic, copy, readwrite) NSString *subtitle;
@end

@interface SPTAlbumData : NSObject
@property(readonly, nonatomic) NSArray *playableTracks;
@end

@interface SPTAlbumViewModel : NSObject
@property(retain, nonatomic) SPTAlbumData *albumData;
@end

@interface SPTAlbumTrackData : NSObject
@property(readonly, nonatomic) NSURL *trackURL;
@end

  //UIViewControllers
@interface SPTNowPlayingBarContainerViewController : UIViewController
@property(retain, nonatomic) SPTPlayerTrack *currentTrack;
@property(readonly, nonatomic) SPTNowPlayingTrackPosition *trackPositionModel;
@end

@interface SPTNowPlayingFooterUnitViewController : UIViewController
@property(retain, nonatomic) SPTNowPlayingButton *shareButton;
@property(retain, nonatomic) SPTNowPlayingButton *addToPlayistButton;
-(void)setAddToPlaylistButtonColor:(UIColor *)color;
-(void)checkIsNowPlayingSongInPlaylist;
@end

@interface PlaylistViewController : UIViewController
@property(retain, nonatomic) SPTPlaylistCosmosModel *viewModel;
@property(nonatomic) UITableView *tableView;
-(NSURL *)spt_pageURI;
@end

@interface SPTStationViewController : UIViewController
@property(retain, nonatomic) SPTStationViewModel *viewModel;
@end

@interface SPTFreeTierPlaylistHeaderViewController : UIViewController
@property(retain, nonatomic) SPTFreeTierPlaylistHeaderConfigurator *configurator;
@end

@interface SPTFreeTierPlaylistViewController : UIViewController
@property(retain, nonatomic) SPTPlaylistCosmosModel *playlistViewModel;
@property(retain, nonatomic) SPTFreeTierPlaylistHeaderViewController *headerViewController;
@property(nonatomic) UITableView *tableView;
-(NSURL *)spt_pageURI;
@end

@interface SPTFreeTierCollectionSongsViewController : UIViewController
@property(retain, nonatomic) SPTFreeTierCollectionSongsViewModelImplementation *viewModel;
@end

@interface SPTPopupDialog : UIViewController
+(id)popupWithTitle:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)buttonTitle;
+(id)popupWithTitle:(NSString *)title message:(NSString *)message buttons:(id)buttons;
-(void)dismissSelf;
@end

@interface SPTAlbumViewController : UIViewController
@property(retain, nonatomic) SPTAlbumViewModel *viewModel;
@end

  //Spotify
@interface SPTNowPlayingFreeTierFeedbackButton : SPTNowPlayingButton
@property(nonatomic, strong, readwrite) UIColor *selectedColor;
@end

  //Misc
@interface GLUETrackRowTableViewCell : UITableViewCell
@property(retain, nonatomic) GLUEEntityRowContentView *entityContentView;
@property(retain, nonatomic) GLUELabel *titleLabel;
@property(retain, nonatomic) GLUELabel *subtitleLabel;
@end
