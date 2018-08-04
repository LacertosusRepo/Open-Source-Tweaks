#import "../ImperiumClasses.h"

@interface AppleMusicTransportButtons : UIView //Swift class, pain in the ass to setup
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface AppleMusicTransportControls : UIView //Swift class, pain in the ass to setup
@end

@interface MusicNowPlayingControlsViewController
@property (nonatomic, readonly) UIView * view;
@end
