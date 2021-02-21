/*
 * Tweak.x
 * SkipBTForgetConfirmation
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 2/21/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Preferences/PSSpecifier.h>
#import "HBLog.h"

%hook PSTableCell
  -(instancetype)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(NSString *)arg2 specifier:(PSSpecifier *)arg3 {
    if([arg3.identifier isEqualToString:@"FORGET_BUTTON"]) {
      object_setClass(arg3, [NSClassFromString(@"PSSpecifier") class]);
    }

    return %orig;
  }
%end
