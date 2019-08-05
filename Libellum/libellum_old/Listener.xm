/*
 * Listener.xm
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/17/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <libactivator/libactivator.h>
#import "LIBNoteView.h"

@interface LALibellumShowNotes : NSObject <LAListener>
@end

@implementation LALibellumShowNotes
  -(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    [[LIBNoteView sharedInstance] showNoteView];
    [event setHandled:YES];
  }

  +(void)load {
    [LASharedActivator registerListener:[self new] forName:@"com.libellum.shownotes"];
  }
@end

@interface LALibellumHideNotes : NSObject <LAListener>
@end

@implementation LALibellumHideNotes
  -(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    [[LIBNoteView sharedInstance] hideNoteView];
    [event setHandled:YES];
  }

  +(void)load {
    [LASharedActivator registerListener:[self new] forName:@"com.libellum.hidenotes"];
  }
@end
