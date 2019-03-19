/*
 * Listener.xm
 * Stellae
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/17/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#import <libactivator/libactivator.h>

@interface LAStellaeUpdateWallpaper : NSObject <LAListener>
@end

@implementation LAStellaeUpdateWallpaper
  -(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-updateSubImage"), nil, nil, true);
    [event setHandled:YES];
  }

  +(void)load {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [LASharedActivator registerListener:[self new] forName:@"com.stellae.updatewallpaper"];
    [pool release];
  }
@end

@interface LAStellaeSaveWallpaper : NSObject <LAListener>
@end

@implementation LAStellaeSaveWallpaper
  -(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.stellaeprefs-saveImage"), nil, nil, true);
    [event setHandled:YES];
  }

  +(void)load {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [LASharedActivator registerListener:[self new] forName:@"com.stellae.savewallpaper"];
    [pool release];
  }
@end
