/*
 * Tweak.x
 * SpotifyAddToFavorites
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/15/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "SpotifyAddToFavorites.h"
#import "ColorFlowAPI.h"
#define LD_DEBUG NO
#define kSpotifyGrey [UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]
#define kSpotifyGreen [UIColor colorWithRed:0.12 green:0.73 blue:0.32 alpha:1.0]

  SPTStatefulPlayer *statefulPlayer;
  SPTPlaylistCosmosModel *playlistModel;
  SPTNowPlayingFooterUnitViewController *footerController;
  SPTNowPlayingBarViewController *barController;
  UISelectionFeedbackGenerator *feedback;

  UIColor *offStateColor;
  NSString *savedPlaylist;

static void removeSongFromPlaylist(NSURL *song, NSURL *playlist) {
  if(playlistModel && song && playlist) {
    [playlistModel removeTrackURLs:@[song] fromPlaylistURL:playlist completion:^{
      [%c(SPTProgressView) showGaiaContextMenuProgressViewWithTitle:@"Removed from Playlist."];
    }];
  }
}

static void addSongToPlaylist(NSURL *song, NSURL *playlist, BOOL songExistsInPlaylist) {
  if(!playlist || [playlist.absoluteString length] == 0) {
    SPTPopupDialog *missingPlaylistPopup = [%c(SPTPopupDialog) popupWithTitle:@"Error" message:@"You don't have a favorite playlist set. Go to a playlist and tap the heart icon in the playlist art." dismissButtonTitle:@"Ok!"];
    [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:missingPlaylistPopup];
    [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
    return;
  }

  if(playlistModel && song && playlist) {
    if(!songExistsInPlaylist) {
      [playlistModel addTrackURLs:@[song] toPlaylistURL:playlist completion:^{
        [%c(SPTProgressView) showGaiaContextMenuProgressViewWithTitle:@"Added to Playlist."];
      }];

    } else {
      removeSongFromPlaylist(song, playlist);
    }

    if(barController) {
      [barController updateButtonColor];
    }
  }
}

%hook SPTStatefulPlayer
  -(id)initWithPlayer:(id)arg1 {
    return statefulPlayer = %orig;
  }

  -(void)playerQueue:(id)arg1 didMoveToRelativeTrack:(id)arg2 {
    %orig;

    if(footerController) {
      [footerController updateButtonColor];
    }
  }
%end

%hook SPTPlaylistCosmosModel
  -(id)initWithDictionaryDataLoader:(id)arg1 dataLoader:(id)arg2 timeGetter:(id)arg3 {
    return playlistModel = %orig;
  }
%end

%hook SPTNowPlayingFooterUnitViewController
%property (retain, nonatomic) SPTNowPlayingButton *addToPlaylistButton;
  -(void)viewDidLoad {
    %orig;

    footerController = self;
    feedback = (!feedback) ? [[UISelectionFeedbackGenerator alloc] init] : feedback;

    if(!self.addToPlaylistButton) {
      self.addToPlaylistButton = [[%c(SPTNowPlayingButton) alloc] initWithFrame:CGRectZero];
      self.addToPlaylistButton.icon = 49;
      self.addToPlaylistButton.iconSize = CGSizeMake(20, 20);
      self.addToPlaylistButton.opaque = YES;
      self.addToPlaylistButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.addToPlaylistButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      [self updateButtonColor];

      [self.view addSubview:self.addToPlaylistButton];

      [NSLayoutConstraint activateConstraints:@[
        [self.addToPlaylistButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.addToPlaylistButton.centerYAnchor constraintEqualToAnchor:self.rightButtonViewController.viewIfLoaded.centerYAnchor],
        [self.addToPlaylistButton.widthAnchor constraintEqualToConstant:56],
        [self.addToPlaylistButton.heightAnchor constraintEqualToConstant:56],
      ]];
    }
  }

  -(void)viewWillAppear:(BOOL)arg1 {
    %orig;

    [self updateButtonColor];
  }

  -(void)cfw_colorizeNotification:(NSNotification *)arg1 {
    %orig;

    CFWColorInfo *colorInfo = [[arg1 userInfo] objectForKey:@"CFWColorInfo"];
    offStateColor = colorInfo.secondaryColor;

    [self updateButtonColor];
  }

%new
  -(void)handleButtonPressed {
    if(savedPlaylist) {
      [feedback selectionChanged];

      NSURL *trackURI = [statefulPlayer currentTrack].URI;
      NSURL *playlistURI = [NSURL URLWithString:savedPlaylist];

      [playlistModel playlistContainsTrackURLs:@[trackURI] playlistURL:playlistURI completion:^(NSSet *set) {
        addSongToPlaylist(trackURI, playlistURI, [set containsObject:trackURI]);
        [self performSelector:@selector(updateButtonColor) withObject:nil afterDelay:0.1];
      }];
    } else {

    }
  }

%new
  -(void)updateButtonColor {
    if(statefulPlayer && playlistModel) {
      NSURL *trackURI = [statefulPlayer currentTrack].URI;
      NSURL *playlistURI = [NSURL URLWithString:savedPlaylist];

      if([trackURI.absoluteString length] > 0) {
        [playlistModel playlistContainsTrackURLs:@[trackURI] playlistURL:playlistURI completion:^(NSSet *set) {
          UIColor *buttonColor;
          if([set containsObject:trackURI]) {
            buttonColor = kSpotifyGreen;
            [self.addToPlaylistButton setIconColor:buttonColor];
          } else {
            buttonColor = (offStateColor) ? offStateColor : kSpotifyGrey;
            [self.addToPlaylistButton setIconColor:buttonColor];
          }

          [self.addToPlaylistButton applyIcon];
        }];

        return;
      }
    }

    [self.addToPlaylistButton setIconColor:kSpotifyGrey];
    [self.addToPlaylistButton applyIcon];
  }
%end

%hook SPTNowPlayingBarViewController
%property (retain, nonatomic) SPTNowPlayingButton *addToPlaylistButton;
  -(void)viewDidLoad {
    %orig;

    barController = self;
    feedback = (!feedback) ? [[UISelectionFeedbackGenerator alloc] init] : feedback;

    if(!self.addToPlaylistButton) {
      self.addToPlaylistButton = [[%c(SPTNowPlayingButton) alloc] initWithFrame:CGRectZero];
      self.addToPlaylistButton.icon = 49;
      self.addToPlaylistButton.iconSize = CGSizeMake(20, 20);
      self.addToPlaylistButton.opaque = YES;
      self.addToPlaylistButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.addToPlaylistButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      [self updateButtonColor];

      [self.view addSubview:self.addToPlaylistButton];

      [NSLayoutConstraint activateConstraints:@[
        [self.addToPlaylistButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.addToPlaylistButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-50],
        [self.addToPlaylistButton.widthAnchor constraintEqualToConstant:40],
        [self.addToPlaylistButton.heightAnchor constraintEqualToConstant:54],
      ]];
    }
  }

  -(void)trackMetadataDidFinishUpdating {
    %orig;

    [self updateButtonColor];
  }

%new
  -(void)handleButtonPressed {
    [feedback selectionChanged];

    NSURL *trackURI = [statefulPlayer currentTrack].URI;
    NSURL *playlistURI = [NSURL URLWithString:savedPlaylist];

    [playlistModel playlistContainsTrackURLs:@[trackURI] playlistURL:playlistURI completion:^(NSSet *set) {
      addSongToPlaylist(trackURI, playlistURI, [set containsObject:trackURI]);
      [self performSelector:@selector(updateButtonColor) withObject:nil afterDelay:0.1];
    }];
  }

%new
  -(void)updateButtonColor {
    if(statefulPlayer && playlistModel) {
      NSURL *trackURI = [statefulPlayer currentTrack].URI;
      NSURL *playlistURI = [NSURL URLWithString:savedPlaylist];

      if([trackURI.absoluteString length] > 0) {
        [playlistModel playlistContainsTrackURLs:@[trackURI] playlistURL:playlistURI completion:^(NSSet *set) {
          if([set containsObject:trackURI]) {
            [self.addToPlaylistButton setIconColor:kSpotifyGreen];
          } else {
            [self.addToPlaylistButton setIconColor:[UIColor whiteColor]];
          }

          [self.addToPlaylistButton applyIcon];
        }];

        return;
      }
    }

    [self.addToPlaylistButton setIconColor:kSpotifyGrey];
    [self.addToPlaylistButton applyIcon];
  }
%end

%hook SPTFreeTierPlaylistViewController
%property (retain, nonatomic) GLUEButton *favoritePlaylistButton;
  -(void)setupHeaderViewController {
    %orig;

    if(!self.favoritePlaylistButton && self.headerViewController.playlistHeaderController.contentView && ![self.headerViewController.playlistHeaderController.contentView isKindOfClass:[%c(VISREFFullBleedContentView) class]]) {
      self.headerViewController.playlistHeaderController.contentView.imageView.userInteractionEnabled = YES;

      UIImageSymbolConfiguration *symbolConfiguration = [%c(UIImageSymbolConfiguration) configurationWithScale:UIImageSymbolScaleLarge];

      self.favoritePlaylistButton = [[%c(GLUEButton) alloc] initWithFrame:CGRectZero];
      self.favoritePlaylistButton.tintColor = [UIColor whiteColor];
      self.favoritePlaylistButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.favoritePlaylistButton addTarget:self action:@selector(setFavoritePlaylist) forControlEvents:UIControlEventTouchUpInside];
      [self.favoritePlaylistButton setImage:[UIImage systemImageNamed:@"heart.slash.circle" withConfiguration:symbolConfiguration] forState:UIControlStateNormal];
      [self.favoritePlaylistButton setImage:[UIImage systemImageNamed:@"heart.circle.fill" withConfiguration:symbolConfiguration] forState:UIControlStateSelected];
      [self.headerViewController.playlistHeaderController.contentView.imageView addSubview:self.favoritePlaylistButton];

      [NSLayoutConstraint activateConstraints:@[
        [self.favoritePlaylistButton.bottomAnchor constraintEqualToAnchor:self.headerViewController.playlistHeaderController.contentView.imageView.bottomAnchor],
        [self.favoritePlaylistButton.rightAnchor constraintEqualToAnchor:self.headerViewController.playlistHeaderController.contentView.imageView.rightAnchor],
        [self.favoritePlaylistButton.widthAnchor constraintEqualToConstant:44],
        [self.favoritePlaylistButton.heightAnchor constraintEqualToConstant:44],
      ]];

      self.favoritePlaylistButton.imageView.backgroundColor = [UIColor blackColor];
      self.favoritePlaylistButton.imageView.layer.masksToBounds = YES;
      self.favoritePlaylistButton.imageView.layer.cornerRadius = self.favoritePlaylistButton.imageView.frame.size.width / 2;

      if([[self spt_pageURI].absoluteString isEqualToString:savedPlaylist]) {
        [self.favoritePlaylistButton setSelected:YES];
        self.favoritePlaylistButton.tintColor = kSpotifyGreen;
      }
    }
  }

%new
  -(void)setFavoritePlaylist {
    HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.spotifyaddtofavoritesprefs"];

    if(self.favoritePlaylistButton.selected) {
      [self.favoritePlaylistButton setSelected:NO];
      self.favoritePlaylistButton.tintColor = [UIColor whiteColor];

      [preferences setObject:@"" forKey:@"savedPlaylist"];

    } else {
      [self.favoritePlaylistButton setSelected:YES];
      self.favoritePlaylistButton.tintColor = kSpotifyGreen;

      [preferences setObject:[self spt_pageURI].absoluteString forKey:@"savedPlaylist"];
    }
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.spotifyaddtofavoritesprefs"];
  [preferences registerObject:&savedPlaylist default:@"" forKey:@"savedPlaylist"];
}
