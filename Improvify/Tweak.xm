/*
 * Tweak.xm
 * Improvify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/21/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "SpotifyClasses.h"
#import "ColorFlowAPI.h"
#import "libcolorpicker.h"
#define LD_DEBUG NO

    //Global variables
  SPTPlaylistCosmosModel *playlistModel;
  SPTStatefulPlayer *statefulPlayer;
  SPTNowPlayingFooterUnitViewController *footerViewController;

    //Preference variables
  static BOOL useAddToPlaylistButton;
  static NSURL *playlistURI;
  static BOOL addToPlaylistCustomColor;
  static float addToPlayistButtonOffset;
  static BOOL useQuickDeleteGesture;
  static float pressDuration;

  static BOOL suppressRateAlert;
  static BOOL disableSongVideos;
  static BOOL disableGenius;

  /*
   * Initial popup
   */
%hook SpotifyAppDelegate
  -(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
    if(![[improvifydata objectForKey:@"improvifyInitialPopup"] boolValue]) {
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

      SPTPopupDialog *copyURIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Improvify" message:@"Thanks for installing my tweak! Make sure to copy your favorite playlist's URI and paste it into the settings. \n\nIf you would like to know more about this tweak, you can find the code on my GitHub below.\n\nIf you have a suggestion or an issue feel free to message me on Twitter.\n\nIf you would like to fund my computer building addiction you can donate to me via PayPal.\n\n(Tested on Spotify v8.5.7.)" buttons:buttons];

      [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:copyURIPopup];
      [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];

      [improvifydata setObject:[NSNumber numberWithBool:1] forKey:@"improvifyInitialPopup"];
      [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
    }

    return %orig;
  }
%end

  /*
   * Get instances needed later
   */
%hook SPTPlaylistCosmosModel
  -(id)initWithCosmosDataLoader:(id)arg1 timeGetter:(id)arg2 {
    return playlistModel = %orig;
  }
%end

%hook SPTStatefulPlayer
  -(id)initWithPlayer:(id)arg1 {
    return statefulPlayer = %orig;
  }
%end

  /*
   * Functions to add/remove song in a playlist
   */
static void addSongToPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel addTrackURLs:songs toPlaylistURL:playlist completion:nil];
}

static void removeSongFromPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel removeTrackURLs:songs fromPlaylistURL:playlist completion:nil];
}

  /*
   * Calls a method to update the button's color based on if its already in the playlist or not, also has a small check to see it it has already checked that song to stop repeat calling (doesnt work well)
   */
%hook SPTNowPlayingInformationUnitViewController
  -(void)viewModelTrackDidChange:(SPTNowPlayingInformationUnitViewModelImplementation *)arg1 {
    %orig;

    SPTNowPlayingInformationUnitViewModelImplementation *lastTrack;
    if(![lastTrack.subtitle isEqualToString:arg1.subtitle]) {
      lastTrack = arg1;
      [footerViewController checkIsNowPlayingSongInPlaylist];
    }
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
      [self setAddToPlaylistButtonColor:[UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]];

      [self.addToPlayistButton addTarget:self action:@selector(handleAddToPlaylist) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:self.addToPlayistButton];
    }
  }

  -(void)cfw_colorizeNotification:(NSNotification *)arg1 {
    %orig;

    if(useAddToPlaylistButton && !addToPlaylistCustomColor) {
      NSDictionary *userInfo = [arg1 userInfo];
      CFWColorInfo *colorInfo = userInfo[@"CFWColorInfo"];
      [self setAddToPlaylistButtonColor:colorInfo.primaryColor];
    }
  }

%new
  -(void)handleAddToPlaylist {
    if(playlistURI.absoluteString.length < 23 || ![playlistURI.absoluteString containsString:@"playlist"]) { //There is a guarenteed 23 characters in a playlist URI link, including "spotify:user::playlist:"
      SPTPopupDialog *playlistURIErrorPopup = [%c(SPTPopupDialog) popupWithTitle:@"Invalid Playlist URI" message:@"No playlist URI is saved or is invalid. \n\nYou can get a playlist's URI by double tapping the name, then enter it into Improvify's preferences." dismissButtonTitle:@"Ok"];
      [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:playlistURIErrorPopup];
      [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];

      return;
    }

    SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
    NSArray *currentTrack = [[NSArray alloc] initWithObjects:playerTrack.URI, nil];
    NSURL *finalPlaylistURI = playlistURI;

    NSRange searchFromRange = [playlistURI.absoluteString rangeOfString:@":user:"];
    NSRange searchToRange = [playlistURI.absoluteString rangeOfString:@":playlist:"];
    NSString *spotifyUsername = [playlistURI.absoluteString substringWithRange:NSMakeRange(searchFromRange.location + searchFromRange.length, searchToRange.location - searchFromRange.location - searchFromRange.length)];
    if([playerTrack.contextSource.absoluteString containsString:[NSString stringWithFormat:@":%@:playlist:", spotifyUsername]] && ![playerTrack.contextSource.absoluteString containsString:@":station:"]) {
      finalPlaylistURI = playerTrack.contextSource;
    }

    [playlistModel playlistContainsTrackURLs:currentTrack playlistURL:finalPlaylistURI completion:^(NSSet *set) {
      if(![set containsObject:playerTrack.URI]) {
        addSongToPlaylist(currentTrack, finalPlaylistURI);
        if(addToPlaylistCustomColor) {
          NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
          [self setAddToPlaylistButtonColor:LCPParseColorString([improvifydata objectForKey:@"buttonColor"], @"#1DB954")];
        } else {
          [self setAddToPlaylistButtonColor:[UIColor colorWithRed:0.12 green:0.73 blue:0.32 alpha:1.0]];
        }

      } else {
        SPTPopupButton *removeFromPlaylistAction = [%c(SPTPopupButton) buttonWithTitle:@"Remove From Playlist" actionHandler:^{
          removeSongFromPlaylist(currentTrack, finalPlaylistURI);
          [self setAddToPlaylistButtonColor:[UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]];
        }];
        SPTPopupButton *cancelAction = [%c(SPTPopupButton) buttonWithTitle:@"Cancel"];
        NSArray *buttons = [[NSArray alloc] initWithObjects:removeFromPlaylistAction, cancelAction, nil];

        SPTPopupDialog *copyURIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Song Already In Playlist" message:[NSString stringWithFormat:@"\"%@\" is already in your playlist.", playerTrack.advertiserTitle] buttons:buttons];

        [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:copyURIPopup];
        [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
      }
    }];
  }

%new
  -(void)checkIsNowPlayingSongInPlaylist {
    if(playlistURI.absoluteString.length < 23 || ![playlistURI.absoluteString containsString:@"playlist"]) { //There is a guarenteed 23 characters in a playlist URI link, including "spotify:user::playlist:"
      return;
    }

    SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
    NSArray *currentTrack = [[NSArray alloc] initWithObjects:playerTrack.URI, nil];
    NSURL *finalPlaylistURI = playlistURI;

    NSRange searchFromRange = [playlistURI.absoluteString rangeOfString:@":user:"];
    NSRange searchToRange = [playlistURI.absoluteString rangeOfString:@":playlist:"];
    NSString *spotifyUsername = [playlistURI.absoluteString substringWithRange:NSMakeRange(searchFromRange.location + searchFromRange.length, searchToRange.location - searchFromRange.location - searchFromRange.length)];
    if([playerTrack.contextSource.absoluteString containsString:[NSString stringWithFormat:@":%@:playlist:", spotifyUsername]] && ![playerTrack.contextSource.absoluteString containsString:@":station:"]) {
      finalPlaylistURI = playerTrack.contextSource;
    }

    [playlistModel playlistContainsTrackURLs:currentTrack playlistURL:finalPlaylistURI completion:^(NSSet *set) {
      if([set containsObject:playerTrack.URI]) {
        if(addToPlaylistCustomColor) {
          NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
          [self setAddToPlaylistButtonColor:LCPParseColorString([improvifydata objectForKey:@"buttonColor"], @"#1DB954")];
        } else {
          [self setAddToPlaylistButtonColor:[UIColor colorWithRed:0.12 green:0.73 blue:0.32 alpha:1.0]];
        }

      } else {
        [self setAddToPlaylistButtonColor:[UIColor colorWithRed:0.78 green:0.80 blue:0.80 alpha:1.0]];
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
   * Added ability to delete songs in playlist with a long longPressGesture, add tap gesture to playlist name to copy it's URI
   */
%hook SPTFreeTierPlaylistViewController
  -(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    GLUETrackRowTableViewCell *cell = %orig;

    if(useQuickDeleteGesture) {
      UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemovePlaylistItem:)];
      longPressGesture.minimumPressDuration = pressDuration;
      longPressGesture.allowableMovement = 0;
      [cell addGestureRecognizer:longPressGesture];

      UILongPressGestureRecognizer *defaultPressGesture = MSHookIvar<UILongPressGestureRecognizer *>(cell, "_longPressGesture");
      [defaultPressGesture requireGestureRecognizerToFail:longPressGesture];
    }

    return cell;
  }

  -(void)setupHeaderViewController {
    %orig;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTitleLabelTap:)];
    tapGesture.numberOfTapsRequired = 2;

    [self.headerViewController.configurator.contentView.titleLabel addGestureRecognizer:tapGesture];
    self.headerViewController.configurator.contentView.titleLabel.userInteractionEnabled = YES;
  }

%new
  -(void)handleRemovePlaylistItem:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded && pressDuration >= 1.0) {
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
      SPTPlaylistPlatformPlaylistTrackFieldsImplementation *trackInfo = self.playlistViewModel.tracks[indexPath.row];
      NSArray *selectedTrack = [[NSArray alloc] initWithObjects:trackInfo.URL, nil];

      if([selectedTrack count] > 0 && [self spt_pageURI].absoluteString.length > 0) {
        removeSongFromPlaylist(selectedTrack, [self spt_pageURI]);
      }
    }
  }

%new
  -(void)handleTitleLabelTap:(UITapGestureRecognizer *)sender {
    NSString *pageURI = [self spt_pageURI].absoluteString;

    SPTPopupButton *copyURIAction = [%c(SPTPopupButton) buttonWithTitle:@"Copy" actionHandler:^{
      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
      pasteboard.string = pageURI;
    }];
    SPTPopupButton *cancelAction = [%c(SPTPopupButton) buttonWithTitle:@"Cancel"];
    NSArray *buttons = [[NSArray alloc] initWithObjects:copyURIAction, cancelAction, nil];

    SPTPopupDialog *copyURIPopup = [%c(SPTPopupDialog) popupWithTitle:@"Copy Playlist URI" message:pageURI buttons:buttons];

    [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:copyURIPopup];
    [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
  }
%end

/*
 * MISCELLANEOUS SETTINGS
 * Get rid of that pesky rate me popup, thanks for spamming it spotify
 */
%hook SPTRateMeController
-(void)showAlert {
  if(suppressRateAlert) {
    //Suppressing fire!
  } else {
    %orig;
  }
}

-(void)showLegacyAlert {
  if(suppressRateAlert) {
    //Suppressing fire!
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
   * Change color of heart icon
   */
%hook SPTNowPlayingFreeTierFeedbackButton
  -(id)selectedColor {
    if(addToPlaylistCustomColor) {
      NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
      return LCPParseColorString([improvifydata objectForKey:@"buttonColor"], @"#1DB954");
    }

    return %orig;
  }
%end

static void killSpotify() {
  exit(0);
}

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifyprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    useAddToPlaylistButton = YES;
    playlistURI = nil;
    addToPlaylistCustomColor = NO;
    addToPlayistButtonOffset = -6;
    useQuickDeleteGesture = YES;
    pressDuration = 2.0;

    suppressRateAlert = YES;
    disableSongVideos = YES;
    disableGenius = NO;
  } else {
    useAddToPlaylistButton = [[preferences objectForKey:@"useAddToPlaylistButton"] boolValue];
    playlistURI = [NSURL URLWithString:[preferences objectForKey:@"playlistURI"]];
    addToPlaylistCustomColor = [[preferences objectForKey:@"addToPlaylistCustomColor"] boolValue];
    addToPlayistButtonOffset = [[preferences objectForKey:@"addToPlayistButtonOffset"] floatValue];
    useQuickDeleteGesture = [[preferences objectForKey:@"useQuickDeleteGesture"] boolValue];
    pressDuration = [[preferences objectForKey:@"pressDuration"] floatValue];

    suppressRateAlert = [[preferences objectForKey:@"suppressRateAlert"] boolValue];
    disableSongVideos = [[preferences objectForKey:@"disableSongVideos"] boolValue];
    disableGenius = [[preferences objectForKey:@"disableGenius"] boolValue];
  }
}

static NSString *nsNotificationString = @"com.lacertosusrepo.improvifyprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)killSpotify, CFSTR("com.lacertosusrepo.improvifyprefs-killSpotify"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  if(![[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"]) {
    NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] init];
    [improvifydata setObject:@"#1DB954" forKey:@"buttonColor"];
    [improvifydata setObject:[NSNumber numberWithBool:0] forKey:@"improvifyInitialPopup"];
    [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
  }
}
