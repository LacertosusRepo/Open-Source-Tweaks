#import "SATFFavoritePlaylistContextAction.h"

@implementation SATFFavoritePlaylistContextAction {
  BOOL _isFavoritePlaylist;
  NSString *_menuURLString;
}

  -(void)setFavoritePlaylistURL:(NSURL *)playlistURL contextMenutURL:(NSURL *)menuURL {
    _isFavoritePlaylist = [playlistURL.absoluteString isEqualToString:menuURL.absoluteString];
    _menuURLString = menuURL.absoluteString;
  }

  -(void)performAction {
    if(_isFavoritePlaylist) {
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedPlaylist"];
      
    } else {
      [[NSUserDefaults standardUserDefaults] setObject:_menuURLString forKey:@"savedPlaylist"];
    }
  }

  -(NSString *)title {
    return (_isFavoritePlaylist) ? @"Remove playlist as favorite " : @"Set playlist as favorite";
  }

  -(NSString *)subtitle {
    return @"Spotify AddToFavorites";
  }

  -(NSUInteger)icon {
    return (_isFavoritePlaylist) ? 142 : 141;
  }

  -(UIColor *)iconColor {
    return (_isFavoritePlaylist) ? [UIColor colorWithRed:0.12 green:0.84 blue:0.38 alpha:1.0] : nil;
  }
@end
