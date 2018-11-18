#import "ColorFlowAPI.h"

@interface NavaleController : UIViewController<CFWColorDelegate>
@property (nonatomic, retain) UIColor *_Nonnull colorOne;
@property (nonatomic, retain) UIColor *_Nonnull colorTwo;
@end

@implementation NavaleController
+(nonnull id)sharedInstance {
  static NavaleController *sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(nonnull id)init {
  if(self = [super init]) {
    [[NSClassFromString(@"CFWSBMediaController") sharedInstance] addColorDelegateAndNotify:self];
  }
  return self;
}

-(void)songAnalysisComplete:(nonnull MPModelSong *)song artwork:(nonnull UIImage *)artwork colorInfo:(nonnull CFWColorInfo *)colorInfo {
  _colorOne = colorInfo.primaryColor;
  _colorTwo = colorInfo.backgroundColor;
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs-updateDock"), nil, nil, true);
}

-(void)songHadNoArtwork:(nullable MPModelSong *)song {
  _colorOne = nil;
  _colorTwo = nil;
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.navaleprefs-updateDock"), nil, nil, true);
}

-(nonnull UIColor *)primaryColor {
  return _colorOne;
}

-(nonnull UIColor *)secondaryColor {
  return _colorTwo;
}
@end
