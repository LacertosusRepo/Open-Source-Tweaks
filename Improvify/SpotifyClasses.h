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
@end

@interface SPTNowPlayingButton : UIButton
@property(nonatomic) struct CGSize iconSize;
@property(nonatomic) long long icon;
@property(nonatomic) unsigned long long buttonState;
@property(nonatomic, copy, readwrite) UIColor *iconColor;
-(void)applyIcon;
-(void)setIconColor:(UIColor *)arg1;
@end

@interface SPTNowPlayingFooterUnitViewController : UIViewController
@property(retain, nonatomic) SPTNowPlayingButton *shareButton;
@property(retain, nonatomic) SPTNowPlayingButton *addToPlayistButton;
@end

@interface GLUEEntityRowTableViewCell : UITableViewCell
@end

@interface PlaylistViewController : UIViewController
@property(retain, nonatomic) SPTPlaylistCosmosModel *viewModel;
@property(nonatomic) UITableView *tableView;
-(NSURL *)spt_pageURI;
@end

@interface SPTPlaylistPlatformPlaylistTrackFieldsImplementation : NSObject
@property(retain, nonatomic) NSURL *URL;
@end
