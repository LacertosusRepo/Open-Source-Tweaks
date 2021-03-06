/*
 * Tweak.x
 * SpotlightAppDelete
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/5/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "SpotlightAppDelete.h"

  NSUserDefaults *spotlightDefaults;

%group Spotlight
%hook SearchUIHomeScreenAppIconView
  -(NSArray *)applicationShortcutItems {
   NSMutableArray *shortcuts = [%orig mutableCopy];

   if(self.icon.uninstallSupported) {
    SBSApplicationShortcutItem *item = [[%c(SBSApplicationShortcutItem) alloc] init];
    item.localizedTitle = @"Remove App";
    item.type = @"com.apple.springboardhome.application-shortcut-item.remove-app";
    item.activationMode = 0;
    item.icon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"minus.circle"];
    [shortcuts addObject:item];
   }

    return [shortcuts copy];
  }

  +(void)activateShortcut:(SBSApplicationShortcutItem *)arg1 withBundleIdentifier:(NSString *)arg2 forIconView:(id)arg3 {
    if([arg1.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.remove-app"] && arg2) {
      [[NSUserDefaults standardUserDefaults] setObject:arg2 forKey:@"applicationToBeDeleted"];
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.spotlightappdelete"), NULL, NULL, YES);
      return;
    }

    %orig;
  }
%end
%end

static void uninstallApplication() {
  SBApplicationController *applicationController = [%c(SBApplicationController) sharedInstanceIfExists];
  spotlightDefaults = (spotlightDefaults) ?: [applicationController applicationWithBundleIdentifier:@"com.apple.Spotlight"].info.userDefaults;

  NSString *bundleID = [spotlightDefaults objectForKey:@"applicationToBeDeleted"];
  if(bundleID.length > 0) {
    [applicationController requestUninstallApplicationWithBundleIdentifier:bundleID options:0 withCompletion:^{
      [spotlightDefaults removeObjectForKey:@"applicationToBeDeleted"];
    }];
  }
}

%ctor {
  if([[NSProcessInfo processInfo].processName isEqualToString:@"SpringBoard"]) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, uninstallApplication, CFSTR("com.lacertosusrepo.spotlightappdelete"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  } else {
    %init(Spotlight);
  }
}
