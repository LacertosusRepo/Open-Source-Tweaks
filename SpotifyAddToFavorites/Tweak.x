/*
 * Tweak.x
 * SpotifyAddToFavorites
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/15/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "SATFFavoritePlaylistContextAction.h"
#import "SpotifyAddToFavorites.h"

#define kSpotifyGrey [UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]
#define kSpotifyGreen [UIColor colorWithRed:0.12 green:0.73 blue:0.32 alpha:1.0]

  SPTPlaylistCosmosModel *playlistModel;
  SPTStatefulPlayerImplementation *playerImplementation;
  UISelectionFeedbackGenerator *feedback;

static void atf_TrackExistsInPlaylist(NSURL *track, NSURL *playlist, ATFTrackExistsInPlaylistBlock completionBlock) {
  if(!playlistModel || !song || !playlist) {
    return;
  }

  [playlistModel playlistContainsTrackURLs:@[track] playlistURL:playlist completion:^(NSSet *set) {
    completionBlock(track, playlist, [set containsObject:song]);
  }];
}

static void atf_addTrackToPlaylist(NSURL *track, NSURL *playlist) {
  if(!playlistModel || !track || !playlist) {
    return;
  }
  
  ATFTrackExistsInPlaylistBlock addOrRemoveSongBlock = ^(NSURL *track, NSURL *playlist, BOOL existsInPlaylist) {
    if(!existsInPlaylist) {
      [playlistModel addTrackURLs:@[track] toPlaylistURL:playlist bySource:nil fromContext:nil completion:nil];
    } else {
      [playlistModel removeTrackURLs:@[track] toPlaylistURL:playlist bySource:nil fromContext:nil completion:nil];
    }
  };
  
  atf_TrackExistsInPlaylist(track, playlist, addOrRemoveSongBlock);
}

%hook SPTPlaylistCosmosModel
  -(instancetype)initWithDictionaryDataLoader:(id)arg1 dataLoader:(id)arg2 eventSender:(id)arg3 timeGetter:(id)arg5 {
    return playlistModel = %orig;
  }
%end

%hook SPTStatefulPlayerImplementation
  -(instancetype)initWithPlayer:(id)arg1 {
    return statefulPlayer = %orig;
  }
%end

#pragma mark - Adding button to view

%hook SPTNowPlayingFooterUnitViewController
%property (retain, nonatomic) SPTNowPlayingButton *addToPlaylistButton;
  -(void)viewDidLoad {
    %orig;

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

%new
  -(void)handleButtonPressed {
    [feedback selectionChanged];

    NSString *savedPlaylist = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];
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
      NSString *savedPlaylist = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];
      NSURL *trackURI = [statefulPlayer currentTrack].URI;
      NSURL *playlistURI = [NSURL URLWithString:savedPlaylist];

      if([trackURI.absoluteString length] > 0) {
        [playlistModel playlistContainsTrackURLs:@[trackURI] playlistURL:playlistURI completion:^(NSSet *set) {
          if([set containsObject:trackURI]) {
            [self.addToPlaylistButton setIconColor:kSpotifyGreen];

          } else {
            [self.addToPlaylistButton setIconColor:kSpotifyGrey];
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

#pragma mark - Favorite playlist context action

%hook SPTContextMenuViewController
  -(NSArray *)validContextMenuActions {
    NSString *pageString = [self spt_pageURI].absoluteString;
    if([pageString containsString:@":playlist:"] && !%c(CONPLYFavoritePlaylistContextAction)) {
      NSMutableArray *contextActions = [%orig mutableCopy];

      NSString *playlistString = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];
      NSURL *playlistURL = [NSURL URLWithString:playlistString];

      SATFFavoritePlaylistContextAction *favoritePlaylistAction = [SATFFavoritePlaylistContextAction new];
      [favoritePlaylistAction setFavoritePlaylistURL:playlistURL contextMenutURL:[self spt_pageURI]];
      [contextActions insertObject:favoritePlaylistAction atIndex:0];

      return contextActions;
    }

    return %orig;
  }
%end
