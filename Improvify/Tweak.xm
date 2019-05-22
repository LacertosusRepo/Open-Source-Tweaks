/*
 * Tweak.xm
 * Improvify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 5/21/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "SpotifyClasses.h"
#import "ColorFlowAPI.h"
#define LD_DEBUG NO

    //Vars
  SPTPlaylistCosmosModel *playlistModel;
  SPTStatefulPlayer *statefulPlayer;

    //Prefs
  NSURL *playlistURI;
  float pressDuration;

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
   * Functions to remove/add/check song in a playlist
   */
static void addSongToPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel addTrackURLs:songs toPlaylistURL:playlist completion:nil];
}

static void removeSongFromPlaylist(NSArray *songs, NSURL *playlist) {
  [playlistModel removeTrackURLs:songs fromPlaylistURL:playlist completion:nil];
}

static BOOL songExistsInPlaylist(NSArray *songs, NSURL *playlist, NSURL *songURI) {
  [playlistModel playlistContainsTrackURLs:songs playlistURL:playlist completion:^(NSSet *set) {
    if([set containsObject:songURI]) {
      return YES;
    } else {
      return NO;
    }
  }];

  return NO;
}

  /*
   * Create a button to add current song to (or remove from) a set playlist and fix button not being colored by ColorFlow
   * Possible thanks to Andreas Henriksson SpotifySwitches <3 - https://github.com/Nosskirneh/SpotifySwitches
   */
%hook SPTNowPlayingFooterUnitViewController
%property (retain, nonatomic) SPTNowPlayingButton *addToPlayistButton;
  -(void)setupShareButton {
    %orig;

    self.addToPlayistButton = [[%c(SPTNowPlayingButton) alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) - 28, -6, 56, 56)];
    self.addToPlayistButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.addToPlayistButton.icon = 49;
    self.addToPlayistButton.iconColor = [UIColor whiteColor];
    self.addToPlayistButton.iconSize = CGSizeMake(20, 20);
    self.addToPlayistButton.opaque = YES;

    [self.addToPlayistButton addTarget:self action:@selector(handleAddToPlaylist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addToPlayistButton];
    [self.addToPlayistButton applyIcon];
  }

  -(void)cfw_colorizeNotification:(NSNotification *)arg1 {
    %orig;

    NSDictionary *userInfo = [arg1 userInfo];
    CFWColorInfo *colorInfo = userInfo[@"CFWColorInfo"];
    self.addToPlayistButton.iconColor = colorInfo.primaryColor;
    [self.addToPlayistButton applyIcon];
  }

%new
  -(void)handleAddToPlaylist {
    if(playlistURI.absoluteString.length <= 23 || [playlistURI.absoluteString containsString:@"playlist"]) { //There is a guarenteed 23 characters in a playlist URI link, including "spotify:user::playlist:"
      UIAlertController *playlistURIError = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"No playlist URI link is saved or is invalid.\n\nYou can enter one in Improvify's preferences." preferredStyle:UIAlertControllerStyleAlert];
      [self presentViewController:playlistURIError animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [playlistURIError dismissViewControllerAnimated:YES completion:nil];
        });
      }];

      return;
    }

    SPTPlayerTrack *playerTrack = [statefulPlayer currentTrack];
    NSArray *currentTrack = [[NSArray alloc] initWithObjects:playerTrack.URI, nil];

    if(!(songExistsInPlaylist(currentTrack, playlistURI, playerTrack.URI))) {
      addSongToPlaylist(currentTrack, playlistURI);
    } else {
      UIAlertController *failedToAddAlert = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"Song is already in playlist." preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction *removeFromPlaylistAction = [UIAlertAction actionWithTitle:@"Remove From Playlist" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        removeSongFromPlaylist(currentTrack, playlistURI);
      }];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

      [failedToAddAlert addAction:removeFromPlaylistAction];
      [failedToAddAlert addAction:cancelAction];
      [self presentViewController:failedToAddAlert animated:YES completion:nil];
    }
  }
%end

  /*
   * Added ability to delete songs in playlist with a long longPressGesture
   */
%hook PlaylistViewController
  -(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    GLUEEntityRowTableViewCell *cell = %orig;

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemovePlaylistItem:)];
    longPressGesture.minimumPressDuration = pressDuration;
    longPressGesture.allowableMovement = 0;
    [cell addGestureRecognizer:longPressGesture];

    UILongPressGestureRecognizer *defaultPressGesture = MSHookIvar<UILongPressGestureRecognizer *>(cell, "_longPressGesture");
    [defaultPressGesture requireGestureRecognizerToFail:longPressGesture];

    return cell;
  }

%new
  -(void)handleRemovePlaylistItem:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded) {
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
      SPTPlaylistPlatformPlaylistTrackFieldsImplementation *trackInfo = self.viewModel.tracks[indexPath.row];
      NSArray *selectedTrack = [[NSArray alloc] initWithObjects:trackInfo.URL, nil];

      if([selectedTrack count] > 0 && [self spt_pageURI].absoluteString.length > 0) {
        removeSongFromPlaylist(selectedTrack, [self spt_pageURI]);
      }
    }
  }
%end

static void loadPrefs() {
  NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifyprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    playlistURI = nil;
    pressDuration = 2.0;
  } else {
    playlistURI = [preferences objectForKey:@"playlistURI"];
    pressDuration = [[preferences objectForKey:@"pressDuration"] floatValue];
  }
}

static NSString *nsNotificationString = @"com.lacertosusrepo.improvifyprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}
