/*
 * Tweak.xm
 * Improvify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/21/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "SpotifyClasses.h"
#import "ColorFlowAPI.h"
#import "libcolorpicker.h"
#define LD_DEBUG NO
#define kSpotifyGrey [UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]
#define kSpotifyGreen [UIColor colorWithRed:0.12 green:0.73 blue:0.32 alpha:1.0]

    //Global variables
  SPTPlaylistCosmosModel *playlistModel;
  SPTStatefulPlayer *statefulPlayer;
  SPTNowPlayingFooterUnitViewController *footerViewController;

    //Preference variables
  static BOOL useAddToPlaylistButton;
  static BOOL addToPlaylistCustomColor;
  static NSString *addToPlayistSelectedColor;
  static NSInteger addToPlayistButtonOffset;
  static BOOL useQuickDeleteGesture;
  static NSInteger pressDuration;
  static BOOL songHistorySwitch;
  static NSInteger minimumSongDuration;

  static NSString *playlistFavorite;
  static NSString *playlistAlternateOneTitle;
  static NSString *playlistAlternateOne;
  static NSString *playlistAlternateTwoTitle;
  static NSString *playlistAlternateTwo;
  static NSString *playlistAlternateThreeTitle;
  static NSString *playlistAlternateThree;

  static BOOL suppressRateAlert;
  static BOOL disableSongVideos;
  static BOOL disableGenius;

  static NSString *improvifyPreviousVersion;

  /*
   * Get instances needed later
   */
%hook SPTPlaylistCosmosModel
  -(id)initWithDictionaryDataLoader:(id)arg1 dataLoader:(id)arg2 timeGetter:(id)arg3 {
    return playlistModel = %orig;
  }
%end

%hook SPTStatefulPlayer
  -(id)initWithPlayer:(id)arg1 {
    return statefulPlayer = %orig;
  }

  -(void)playerQueue:(id)arg1 didMoveToRelativeTrack:(id)arg2 {
    %orig;

    [footerViewController updatePlaylistButtonColor];
  }
%end

  /*
   * Functions to add/remove song in a playlist, then update the button color
   */
static void addSongToPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel addTrackURLs:songs toPlaylistURL:playlist completion:^{
    [footerViewController updatePlaylistButtonColor];

    [%c(SPTProgressView) showGaiaContextMenuProgressViewWithTitle:@"Added to Saved Playlist."];
  }];
}

static void removeSongFromPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel removeTrackURLs:songs fromPlaylistURL:playlist completion:^{
    [footerViewController updatePlaylistButtonColor];
  }];
}

  /*
   * Saves the song as being "played" if its listened to for more than 60s
   * Calls a method to update the button's color based on if its already in the playlist or not)
   * Thanks to Andreas Henriksson and his SpotifyHistory <3 - https://github.com/Nosskirneh/SpotifyHistory
   */
%hook SPTNowPlayingBarContainerViewController
  -(void)setCurrentTrack:(SPTPlayerTrack *)arg1 {
    if(songHistorySwitch) {
      static double songElapsedTime;

      if([self.currentTrack.URI.absoluteString length] > 1) {
        double currentTime = [[NSDate date] timeIntervalSince1970];
        if(((currentTime - songElapsedTime) > minimumSongDuration) && minimumSongDuration >= 4) {
          NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
          NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
          songHistory[self.currentTrack.URI.absoluteString] = @([songHistory[self.currentTrack.URI.absoluteString] intValue] +1);
          [improvifydata setObject:songHistory forKey:@"songHistory"];
          [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
        }
      }

      songElapsedTime = [[NSDate date] timeIntervalSince1970];
    }

    %orig;
  }
%end

  /*
   * Create a button to add current song to (or remove from) a set playlist and fix button not being colored by ColorFlow, add gesture to title label to get easy access to playlist URI
   * Possible thanks to Andreas Henriksson SpotifySwitches <3 - https://github.com/Nosskirneh/SpotifySwitches
   */
%hook SPTNowPlayingFooterUnitViewController
%property (retain, nonatomic) SPTNowPlayingButton *addToPlayistButton;
  -(id)initWithAuxiliaryActionsHandler:(id)arg1 devicesAvailableViewProvider:(id)arg2 rightButton:(id)arg3 theme:(id)arg4 {
    return footerViewController = %orig;
  }

  -(void)viewDidLoad {
    %orig;

    if(useAddToPlaylistButton) {
      self.addToPlayistButton = [[%c(SPTNowPlayingButton) alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) - 28, addToPlayistButtonOffset, 56, 56)];
      self.addToPlayistButton.translatesAutoresizingMaskIntoConstraints = YES;
      self.addToPlayistButton.icon = 49;
      self.addToPlayistButton.iconSize = CGSizeMake(20, 20);
      self.addToPlayistButton.opaque = YES;
      [self setAddToPlaylistButtonColor:kSpotifyGrey];

      UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddToPlaylist:)];
      tapGesture.numberOfTapsRequired = 1;
      UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlaylistSelect:)];
      pressGesture.minimumPressDuration = 0.9;
      [tapGesture requireGestureRecognizerToFail:pressGesture];

      [self.addToPlayistButton addGestureRecognizer:tapGesture];
      [self.addToPlayistButton addGestureRecognizer:pressGesture];
      [self.view addSubview:self.addToPlayistButton];

      [self updatePlaylistButtonColor];
    }
  }

%new
  -(void)handleAddToPlaylist:(NSString *)contextString {
    if(![contextString isKindOfClass:[NSString class]]) {
      contextString = playlistFavorite;
    }

    NSURL *contextURL = [NSURL URLWithString:contextString];
    NSURL *playlistURL = [NSURL URLWithString:playlistFavorite];

    if(playlistURL.absoluteString.length < 23 || ![playlistURL.absoluteString containsString:@"playlist"]) { //There is a guarenteed 23 characters in a playlist URI link, including "spotify:user::playlist:"
      SPTPopupDialog *playlistURIErrorPopup = [%c(SPTPopupDialog) popupWithTitle:@"Invalid Playlist URI" message:@"No playlist URI is saved or is invalid. \n\nYou can get a playlist's URI by double tapping the name, then enter it into Improvify's preferences." dismissButtonTitle:@"Ok"];
      [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:playlistURIErrorPopup];
      [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];

      return;
    }

    SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
    NSArray *currentTrack = [[NSArray alloc] initWithObjects:playerTrack.URI, nil];

    NSRange searchFromRange = [playlistURL.absoluteString rangeOfString:@":user:"];
    NSRange searchToRange = [playlistURL.absoluteString rangeOfString:@":playlist:"];
    NSString *spotifyUsername = [playlistURL.absoluteString substringWithRange:NSMakeRange(searchFromRange.location + searchFromRange.length, searchToRange.location - searchFromRange.location - searchFromRange.length)];
    if([playerTrack.contextSource.absoluteString containsString:[NSString stringWithFormat:@":%@:playlist:", spotifyUsername]] && ![playerTrack.contextSource.absoluteString containsString:@":station:"]) {
      contextURL = playerTrack.contextSource;
    }

    [playlistModel playlistContainsTrackURLs:currentTrack playlistURL:contextURL completion:^(NSSet *set) {
      if(![set containsObject:[currentTrack firstObject]]) {
        addSongToPlaylist(currentTrack, contextURL);

      } else {
        SPTPopupButton *removeFromPlaylistAction = [%c(SPTPopupButton) buttonWithTitle:@"Remove From Playlist" actionHandler:^{
          removeSongFromPlaylist(currentTrack, contextURL);
        }];
        SPTPopupButton *cancelAction = [%c(SPTPopupButton) buttonWithTitle:@"Cancel"];
        NSArray *buttons = [[NSArray alloc] initWithObjects:removeFromPlaylistAction, cancelAction, nil];

        SPTPopupDialog *copyURIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Song Already In Playlist" message:[NSString stringWithFormat:@"\'%@\' is already in your favorite playlist.", playerTrack.advertiserTitle] buttons:buttons];

        [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:copyURIPopup];
        [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
      }
    }];
  }

%new
  -(void)handlePlaylistSelect:(UIGestureRecognizer *)gesture {
    UIAlertController *playlistSelectSheet = [UIAlertController alertControllerWithTitle:@"Select Playlist" message:@"Which playlist do you want to save this song to?" preferredStyle:UIAlertControllerStyleActionSheet];

    if(playlistAlternateOne.length > 23 && [playlistAlternateOne containsString:@"playlist"]) {
      UIAlertAction *playlistAlternateOneAction = [UIAlertAction actionWithTitle:playlistAlternateOneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self handleAddToPlaylist:playlistAlternateOne];
      }];

      [playlistSelectSheet addAction:playlistAlternateOneAction];
    }

    if(playlistAlternateTwo.length > 23 && [playlistAlternateTwo containsString:@"playlist"]) {
      UIAlertAction *playlistAlternateTwoAction = [UIAlertAction actionWithTitle:playlistAlternateTwoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self handleAddToPlaylist:playlistAlternateTwo];
      }];

      [playlistSelectSheet addAction:playlistAlternateTwoAction];
    }

    if(playlistAlternateThree.length > 23 && [playlistAlternateThree containsString:@"playlist"]) {
      UIAlertAction *playlistAlternateThreeAction = [UIAlertAction actionWithTitle:playlistAlternateThreeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self handleAddToPlaylist:playlistAlternateThree];
      }];

      [playlistSelectSheet addAction:playlistAlternateThreeAction];
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [playlistSelectSheet addAction:cancelAction];

    [self presentViewController:playlistSelectSheet animated:YES completion:nil];
  }

%new
  -(void)updatePlaylistButtonColor {
    NSURL *playlistURL = [NSURL URLWithString:playlistFavorite];

    if(playlistURL.absoluteString.length < 23 || ![playlistURL.absoluteString containsString:@"playlist"]) { //There is a guarenteed 23 characters in a playlist URI link, including "spotify:user::playlist:"
      return;
    }

    SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
    NSArray *currentTrack = [[NSArray alloc] initWithObjects:playerTrack.URI, nil];
    NSURL *contextURL = playlistURL;

    NSRange searchFromRange = [playlistURL.absoluteString rangeOfString:@":user:"];
    NSRange searchToRange = [playlistURL.absoluteString rangeOfString:@":playlist:"];
    NSString *spotifyUsername = [playlistURL.absoluteString substringWithRange:NSMakeRange(searchFromRange.location + searchFromRange.length, searchToRange.location - searchFromRange.location - searchFromRange.length)];
    if([playerTrack.contextSource.absoluteString containsString:[NSString stringWithFormat:@":%@:playlist:", spotifyUsername]] && ![playerTrack.contextSource.absoluteString containsString:@":station:"]) {
      contextURL = playerTrack.contextSource;
    }

    [playlistModel playlistContainsTrackURLs:currentTrack playlistURL:contextURL completion:^(NSSet *set) {
      if([set containsObject:[currentTrack firstObject]]) {
        if(addToPlaylistCustomColor) {
          [self setAddToPlaylistButtonColor:LCPParseColorString(addToPlayistSelectedColor, @"#1DB954")];
        } else {
          [self setAddToPlaylistButtonColor:kSpotifyGreen];
        }

      } else {
        [self setAddToPlaylistButtonColor:kSpotifyGrey];
      }
    }];
  }

%new
  -(void)setAddToPlaylistButtonColor:(UIColor *)color {
    [self.addToPlayistButton setIconColor:color];
    [self.addToPlayistButton applyIcon];
  }
%end

  /*
   * Added ability to delete songs in playlist with a long longPressGesture
   * Song play history for playlists, radios, liked songs, albums (has to be in the title as the subtitle kept getting reset)
   * Add tap gesture to playlist name to copy it's URI
   */
%hook SPTFreeTierPlaylistViewController
  -(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    GLUETrackRowTableViewCell *cell = %orig;

    if(useQuickDeleteGesture && pressDuration >= 1 && cell.gestureRecognizers.count < 1) {
      UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemovePlaylistItem:)];
      longPressGesture.minimumPressDuration = pressDuration;
      longPressGesture.allowableMovement = 0;
      [cell addGestureRecognizer:longPressGesture];

      UILongPressGestureRecognizer *defaultPressGesture = [cell valueForKey:@"_longPressGesture"];//MSHookIvar<UILongPressGestureRecognizer *>(cell, "_longPressGesture");
      [defaultPressGesture requireGestureRecognizerToFail:longPressGesture];
    }

    if(songHistorySwitch) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
      if(self.playlistViewModel.totalNumberOfTracks > arg2.row) {
        SPTPlaylistPlatformPlaylistTrackFieldsImplementation *trackInfo = self.playlistViewModel.loadedTracks[arg2.row];
        NSString *songURL = trackInfo.URL.absoluteString;
        if([songHistory[songURL] intValue] > 0 && arg2.section == 2) {
          if([cell respondsToSelector:@selector(subtitleLabel)]) {
            cell.subtitleLabel.text = [[NSString stringWithFormat:@"%@ Plays \u2022 ", [songHistory valueForKey:songURL]] stringByAppendingString:cell.subtitleLabel.text];
          }
        }
      }
    }

    return cell;
  }

  -(void)setupHeaderViewController {
    %orig;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTitleLabelTap:)];
    tapGesture.numberOfTapsRequired = 2;

    UILabel *playlistLabel = [self getPlaylistLabel];
    if(playlistLabel) {
      [playlistLabel addGestureRecognizer:tapGesture];
      playlistLabel.userInteractionEnabled = YES;
    }
  }

%new
  -(UILabel *)getPlaylistLabel {
    if([self.headerViewController respondsToSelector:@selector(configurator)]) {
      //Default spotify label
      return self.headerViewController.configurator.contentView.titleLabel;

    } if([self.headerViewController respondsToSelector:@selector(fullbleedViewModel)]){
      //Podcast spotify label
      return self.headerViewController.view.titleLabel;

    } if([self.headerViewController respondsToSelector:@selector(visrefIntegrationManager)]) {
      //If that doesnt work, it probably means Groovify is installed, so we'll add it to that label instead
      return self.entityHeaderViewController.contentViewController.headerController.contentView.titleLabel;
    }

    return nil;
  }

%new
  -(void)handleRemovePlaylistItem:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded && pressDuration >= 1.0) {
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
      SPTPlaylistPlatformPlaylistTrackFieldsImplementation *trackInfo = self.playlistViewModel.loadedTracks[indexPath.row];
      NSArray *selectedTrack = [[NSArray alloc] initWithObjects:trackInfo.URL, nil];

      if([selectedTrack count] > 0 && [self spt_pageURI].absoluteString.length > 0) {
        removeSongFromPlaylist(selectedTrack, [self spt_pageURI]);
      }
    }
  }

%new
  -(void)handleTitleLabelTap:(UITapGestureRecognizer *)sender {
    NSString *pageURI = [self spt_pageURI].absoluteString;
    UILabel *playlistLabel = ([sender.view isKindOfClass:[UILabel class]]) ? (UILabel *)sender.view : nil;
    HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.improvifyprefs"];

    SPTPopupButton *setURIFavoriteAction = [%c(SPTPopupButton) buttonWithTitle:@"Set as Favorite Playlist" actionHandler:^{
      [preferences setObject:pageURI forKey:@"playlistFavorite"];
    }];

    SPTPopupButton *setURIAlternativeOneAction = [%c(SPTPopupButton) buttonWithTitle:@"Set as Alternate Playlist One" actionHandler:^{
      [preferences setObject:pageURI forKey:@"playlistAlternateOne"];
      [preferences setObject:playlistLabel.text forKey:@"playlistAlternateOneTitle"];
    }];

    SPTPopupButton *setURIAlternativeTwoAction = [%c(SPTPopupButton) buttonWithTitle:@"Set as Alternate Playlist Two" actionHandler:^{
      [preferences setObject:pageURI forKey:@"playlistAlternateTwo"];
      [preferences setObject:playlistLabel.text forKey:@"playlistAlternateTwoTitle"];
    }];

    SPTPopupButton *setURIAlternativeThreeAction = [%c(SPTPopupButton) buttonWithTitle:@"Set as Alternate Playlist Three" actionHandler:^{
      [preferences setObject:pageURI forKey:@"playlistAlternateThree"];
      [preferences setObject:playlistLabel.text forKey:@"playlistAlternateThreeTitle"];
    }];

    SPTPopupButton *copyURIAction = [%c(SPTPopupButton) buttonWithTitle:@"Copy" actionHandler:^{
      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
      pasteboard.string = pageURI;
    }];
    SPTPopupButton *cancelAction = [%c(SPTPopupButton) buttonWithTitle:@"Cancel"];
    NSArray *buttons = [[NSArray alloc] initWithObjects:setURIFavoriteAction, setURIAlternativeOneAction, setURIAlternativeTwoAction, setURIAlternativeThreeAction, copyURIAction, cancelAction, nil];

    SPTPopupDialog *URIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Playlist URI Manager" message:pageURI buttons:buttons];

    [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:URIPopup];
    [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
  }
%end

%hook SPTStationViewController
  -(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    GLUETrackRowTableViewCell *cell = %orig;

    if(songHistorySwitch) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
      if([self.viewModel.trackURIs count] > arg2.row) {
        NSURL *trackInfo = self.viewModel.trackURIs[arg2.row];
        NSString *songURL = trackInfo.absoluteString;
        if([songHistory[songURL] intValue] > 0) {
          if([cell respondsToSelector:@selector(subtitleLabel)]) {
            cell.subtitleLabel.text = [[NSString stringWithFormat:@"%@ Plays \u2022 ", [songHistory valueForKey:songURL]] stringByAppendingString:cell.subtitleLabel.text];
          }
        }
      }
    }

    return cell;
  }
%end

%hook SPTFreeTierCollectionSongsViewController
  -(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    GLUETrackRowTableViewCell *cell = %orig;

    if(songHistorySwitch) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
      NSURL *songNSURL = [self.viewModel trackURIAtIndexPath:arg2];
      NSString *songURL = songNSURL.absoluteString;
      if([songHistory[songURL] intValue] > 0) {
        if([cell respondsToSelector:@selector(subtitleLabel)]) {
          cell.subtitleLabel.text = [[NSString stringWithFormat:@"%@ Plays \u2022 ", [songHistory valueForKey:songURL]] stringByAppendingString:cell.subtitleLabel.text];
        }
      }
    }

    return cell;
  }
%end

%hook HUBCollectionView
  -(void)collectionView:(id)arg1 willDisplayCell:(HUBComponentCollectionViewCell *)arg2 forItemAtIndexPath:(NSIndexPath *)arg3 {
    %orig;

    if(songHistorySwitch) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
      if([self.superview respondsToSelector:@selector(contextMenu)]) {
        SPTAlbumTrackData *trackInfo = ((SPTFreeTierAlbumViewController *)self.superview).contextMenu.albumViewModel.albumTracks[arg3.row];
        NSString *songURL = trackInfo.trackURL.absoluteString;
        if([songHistory[songURL] intValue] > 0) {
          if([arg2.componentView.trackCell respondsToSelector:@selector(subtitleLabel)]) {
            arg2.componentView.trackCell.subtitleLabel.text = [[NSString stringWithFormat:@"%@ Plays \u2022 ", [songHistory valueForKey:songURL]] stringByAppendingString:arg2.componentView.trackCell.subtitleLabel.text];
          }
        }
      }
    }
  }
%end

  /*
   * Song history on now playing view
   */
%hook SPTNowPlayingInformationUnitViewController
  -(void)updateLabels {
    %orig;

    if(songHistorySwitch) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      NSMutableDictionary *songHistory = [[NSMutableDictionary alloc] initWithDictionary:[improvifydata objectForKey:@"songHistory"]];
      SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
      NSString *songURL = playerTrack.URI.absoluteString;
      if([songHistory[songURL] intValue] > 0) {
        if([self respondsToSelector:@selector(subtitleLabel)]) {
          NSAttributedString *oldAttributedSubtitle = self.subtitleLabel.attributedText;
          NSDictionary *attributes = [oldAttributedSubtitle attributesAtIndex:0 effectiveRange:nil];

          NSString *oldSubtitle = [self.subtitleLabel.attributedText string];
          if(![oldSubtitle containsString:@"Plays \u2022"]) {
            NSString *newSubtitle = [[NSString stringWithFormat:@"%@ Plays \u2022 ", [songHistory valueForKey:songURL]] stringByAppendingString:oldSubtitle];
            NSAttributedString *finalSubtitle = [[NSAttributedString alloc] initWithString:newSubtitle attributes:attributes];
            [self.subtitleLabel setAttributedText:finalSubtitle marqueeingSpeed:self.subtitleLabel.marqueeingSpeed restingDuration:self.subtitleLabel.restingDuration];
          }
        }
      }
    }
  }
%end

  /*
   * MISCELLANEOUS SETTINGS
   * Get rid of that pesky rate me popup, thanks for spamming it spotify
   */
%hook SPTRateMeController
  -(void)showAlert {
    if(suppressRateAlert) {
      //Suppressing hush!
    } else {
      %orig;
    }
  }

  -(void)showLegacyAlert {
    if(suppressRateAlert) {
      //Suppressing hush!
    } else {
      %orig;
    }
  }
%end

  /*
   * Stop the video clips from playing on some songs
   */
%hook SPTCanvasTrackCheckerImplementation
  -(BOOL)isCanvasEnabledForTrack:(id)arg1 {
    if(disableSongVideos) {
      return NO;
    }

    return %orig;
  }
%end

  /*
   * Get rid of the Genius facts/lyric view
   */
%hook SPTGeniusService
  -(BOOL)isTrackGeniusEnabled:(id)arg1 {
    if(disableGenius) {
      return NO;
    }

    return %orig;
  }
%end

  /*
   * Force new now playing view so button will show up (SPTNowPlayingViewControllerV2)
   */
%hook SPTNowPlayingTestManagerImplementation
  -(BOOL)isNewNowPlayingViewEnabled {
    return YES;
  }

  -(void)setNewNowPlayingViewEnabledIPad:(BOOL)arg1 {
    %orig(YES);
  }

  -(BOOL)isNewNowPlayingViewEnabledIPad {
    return YES;
  }

  -(BOOL)isNewNowPlayingViewEnabledOnFree {
    return YES;
  }

  -(BOOL)isNewNowPlayingViewEnabledOnPremium {
    return YES;
  }
%end

  /*
   * Change color of heart icon
   */
%hook SPTNowPlayingFreeTierFeedbackButton
  -(id)selectedColor {
    if(addToPlaylistCustomColor) {
      return LCPParseColorString(addToPlayistSelectedColor, @"#1DB954");
    }

    return %orig;
  }
%end

  /*
   * Initial popup
   */
%hook SpotifyAppDelegate
  -(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.improvifyprefs"];
    NSString *previousVersion = [preferences objectForKey:@"improvifyPreviousVersion"];

    if(![previousVersion isEqualToString:@"1.4.6"] || LD_DEBUG) {
      SPTPopupButton *cancelAction = [%c(SPTPopupButton) buttonWithTitle:@"Cool!"];
      SPTPopupButton *githubAction = [%c(SPTPopupButton) buttonWithTitle:@"Github" actionHandler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
      }];
      SPTPopupButton *twitterAction = [%c(SPTPopupButton) buttonWithTitle:@"Twitter" actionHandler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
      }];
      SPTPopupButton *paypalAction = [%c(SPTPopupButton) buttonWithTitle:@"Donate" actionHandler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/Lacertosus?locale.x=en_US"] options:@{} completionHandler:nil];
      }];
      NSArray *buttons = [[NSArray alloc] initWithObjects:cancelAction, githubAction, twitterAction, paypalAction, nil];

      SPTPopupDialog *copyURIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Improvify" message:@"Thanks for installing Improvify! For the button to work you must have a playlist's URI set in the preferences of this tweak.\n\nIf you would like to take a peek into how this tweak works, the code is availible on my Github page linked below.\n\nIf you have a suggestion or an issue with the tweak feel free to message me on Twitter!\n\nIf you would like to feed my computer building addiction you can donate to me via PayPal.\n\n(Tested on Spotify v8.5.41)" buttons:buttons];

      [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:copyURIPopup];
      [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];

      [preferences setObject:@"1.4.6" forKey:@"improvifyPreviousVersion"];
    }

    return %orig;
  }
%end

  /*
   * Preferences & Functions
   */
static void killSpotify() {
  exit(0);
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)killSpotify, CFSTR("com.lacertosusrepo.improvifyprefs-killSpotify"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.improvifyprefs"];
  [preferences registerBool:&useAddToPlaylistButton default:YES forKey:@"useAddToPlaylistButton"];
  [preferences registerBool:&addToPlaylistCustomColor default:NO forKey:@"addToPlaylistCustomColor"];
  [preferences registerObject:&addToPlayistSelectedColor default:@"#1DB954" forKey:@"addToPlayistSelectedColor"];
  [preferences registerInteger:&addToPlayistButtonOffset default:-6 forKey:@"addToPlayistButtonOffset"];
  [preferences registerBool:&useQuickDeleteGesture default:YES forKey:@"useQuickDeleteGesture"];
  [preferences registerInteger:&pressDuration default:2.0 forKey:@"pressDuration"];
  [preferences registerBool:&songHistorySwitch default:YES forKey:@"songHistorySwitch"];
  [preferences registerInteger:&minimumSongDuration default:60 forKey:@"minimumSongDuration"];

  [preferences registerObject:&playlistFavorite default:@"" forKey:@"playlistFavorite"];
  [preferences registerObject:&playlistAlternateOneTitle default:@"" forKey:@"playlistAlternateOneTitle"];
  [preferences registerObject:&playlistAlternateOne default:@"" forKey:@"playlistAlternateOne"];
  [preferences registerObject:&playlistAlternateTwoTitle default:@"" forKey:@"playlistAlternateTwoTitle"];
  [preferences registerObject:&playlistAlternateTwo default:@"" forKey:@"playlistAlternateTwo"];
  [preferences registerObject:&playlistAlternateThreeTitle default:@"" forKey:@"playlistAlternateThreeTitle"];
  [preferences registerObject:&playlistAlternateThree default:@"" forKey:@"playlistAlternateThree"];

  [preferences registerBool:&suppressRateAlert default:YES forKey:@"suppressRateAlert"];
  [preferences registerBool:&disableSongVideos default:YES forKey:@"disableSongVideos"];
  [preferences registerBool:&disableGenius default:NO forKey:@"disableGenius"];

  [preferences registerObject:&improvifyPreviousVersion default:@"" forKey:@"improvifyPreviousVersion"];

  if(![[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"]) {
    NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] init];
    [improvifydata setObject:[NSNumber numberWithBool:0] forKey:@"improvifyInitialPopup"];
    [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
  }
}
