#import <libactivator/libactivator.h>

@interface LAStellaeListener : NSObject<LAListener> {}
@end

@implementation LAStellaeListener
  -(NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
    return @"Stellae";
  }

  -(NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Update Wallpaer";
  }

  -(NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Updates the current wallpaper from a specifed subreddit.";
  }

  -(NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
  }

  -(NSData *)activator:(LAActivator *)activator requiresIconDataForListenerName:(NSString *)listenerName scale:(CGFloat *)scale {
    return [NSData dataWithContentsOfFile:@"/Library/PrefrenceBundles/stellaeprefs.bundle/iconactivator@2x.png"];
  }

  - (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName scale:(CGFloat *)scale {
    return [NSData dataWithContentsOfFile:@"/Library/PrefrenceBundles/stellaeprefs.bundle/iconactivator@2x.png"];
  }

  -(void)activator:(LAActivator *)activator receivedEvent:(LAEvent *)event {
    NSLog(@"Stellae Activator");
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-updateSubImage"), nil, nil, true);
    [event setHandled:YES];
  }

  +(void)load {
    if([LASharedActivator isRunningInsideSpringBoard]) {
      [LASharedActivator registerListener:[self new] forName:@"com.lacertosusrepo.stellae"];
    }
  }
@end
