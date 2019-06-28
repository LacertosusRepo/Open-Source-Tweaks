/*
 * Tweak.xm
 * LuxSit
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 6/27/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "LuxSitClasses.h"
#define LD_DEBUG NO

  static BOOL useRedditShortcut;
  static BOOL useSpotifyShortcut;
  static BOOL useZebraShortcut;
  static BOOL useYoutubeShortcut;
  static NSInteger redditApp;

%hook SPUISearchHeader
  -(BOOL)textFieldShouldReturn {
    if(useRedditShortcut && [self.currentQuery hasPrefix:@"r/"] && ![self.currentQuery containsString:@" "] && [self.currentQuery length] > 2) {
      NSString *spotlightTextReddit = [self.currentQuery stringByReplacingOccurrencesOfString:@"r/" withString:@""];
      spotlightTextReddit = [NSString stringWithFormat:@"www.reddit.com/r/%@", spotlightTextReddit];

      if(redditApp == safari) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextReddit] options:@{} completionHandler:nil];
      } if(redditApp == apollo) {
        spotlightTextReddit = [NSString stringWithFormat:@"apollo://%@", spotlightTextReddit];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextReddit] options:@{} completionHandler:nil];
      } if(redditApp == reddit) {
        spotlightTextReddit = [NSString stringWithFormat:@"reddit:///%@", spotlightTextReddit];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextReddit] options:@{} completionHandler:nil];
      } if(redditApp == narwhal) {
        spotlightTextReddit = [NSString stringWithFormat:@"narwhal://open-url/%@", spotlightTextReddit];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextReddit] options:@{} completionHandler:nil];
      }
    }

    if(useSpotifyShortcut && [self.currentQuery hasPrefix:@"s/ "] && [self.currentQuery length] > 3) {
      NSString *spotlightTextSpotify = [self.currentQuery stringByReplacingOccurrencesOfString:@"s/ " withString:@""];
      spotlightTextSpotify = [NSString stringWithFormat:@"spotify://search/%@", spotlightTextSpotify];
      spotlightTextSpotify = [spotlightTextSpotify stringByReplacingOccurrencesOfString:@" " withString:@""];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextSpotify] options:@{} completionHandler:nil];
    }

    if(useZebraShortcut && [self.currentQuery hasPrefix:@"zbr/ "] && [self.currentQuery length] > 5) {
      NSString *spotlightTextZebra = [self.currentQuery stringByReplacingOccurrencesOfString:@"zbr/ " withString:@""];
      spotlightTextZebra = [NSString stringWithFormat:@"zbra://search/%@", spotlightTextZebra];
      spotlightTextZebra = [spotlightTextZebra stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextZebra] options:@{} completionHandler:nil];
    }

    if(useYoutubeShortcut && [self.currentQuery hasPrefix:@"yt/ "] && [self.currentQuery length] > 4) {
      NSString *spotlightTextYoutube = [self.currentQuery stringByReplacingOccurrencesOfString:@"yt/ " withString:@""];
      spotlightTextYoutube = [NSString stringWithFormat:@"youtube://YouTube.com/results?search_query=%@", spotlightTextYoutube];
      spotlightTextYoutube = [spotlightTextYoutube stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spotlightTextYoutube] options:@{} completionHandler:nil];
    }

    return %orig;
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.luxsitprefs"];
  [preferences registerBool:&useRedditShortcut default:YES forKey:@"useRedditShortcut"];
  [preferences registerBool:&useSpotifyShortcut default:YES forKey:@"useSpotifyShortcut"];
  [preferences registerBool:&useZebraShortcut default:YES forKey:@"useZebraShortcut"];
  [preferences registerBool:&useYoutubeShortcut default:YES forKey:@"useYoutubeShortcut"];
  [preferences registerInteger:&redditApp default:safari forKey:@"redditApp"];
}
