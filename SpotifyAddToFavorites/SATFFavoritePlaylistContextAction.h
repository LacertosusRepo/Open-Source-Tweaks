#import <UIKit/UIKit.h>

@protocol SPTContextMenuAction
@required
-(void)performAction;
-(NSString *)title;
@optional
-(NSString *)logEventName;
-(BOOL)shouldHaveTwoLineTitle;
-(BOOL)shouldHaveTwoLineSubtitle;
-(BOOL)logUBIInteraction;
-(NSString *)desiredOnboardingText;
-(UIImage *)iconImage;
-(id)accessoryView;
-(BOOL)isSelected;
-(NSUInteger)icon;
-(NSString *)subtitle;
-(BOOL)isDisabled;
-(UIColor *)iconColor;
-(id)imageStyle;
-(UIImage *)placeholderImage;
-(id)imageURL;
@end

@interface SATFFavoritePlaylistContextAction : NSObject <SPTContextMenuAction>
-(void)setFavoritePlaylistURL:(NSURL *)playlistURL contextMenutURL:(NSURL *)menuURL;
@end
