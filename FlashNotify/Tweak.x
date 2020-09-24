/*
 * Tweak.x
 * FlashNotify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/29/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "FlashNotifyProvider.h"

  static BOOL initDelay;

%hook SBUIFlashlightController
  -(void)turnFlashlightOnForReason:(id)arg1 {
    %orig;

    [[FlashNotifyProvider sharedInstance] startOverrideTimer];
    [[FlashNotifyProvider sharedInstance] startNotificationTimer];
    [[FlashNotifyProvider sharedInstance] startMonitoringAccelerometer];
  }

  -(void)turnFlashlightOffForReason:(id)arg1 {
    %orig;

    [[FlashNotifyProvider sharedInstance] stopOverrideTimer];
    [[FlashNotifyProvider sharedInstance] stopNotificationTimer];
    [[FlashNotifyProvider sharedInstance] stopMonitoringAccelerometer];
  }

  -(void)_postLevelChangeNotification:(unsigned long long)arg1 {
    %orig;

    if(arg1 > 0) {
      [[FlashNotifyProvider sharedInstance] startOverrideTimer];
      [[FlashNotifyProvider sharedInstance] startNotificationTimer];
      [[FlashNotifyProvider sharedInstance] startMonitoringAccelerometer];
    } else {
      [[FlashNotifyProvider sharedInstance] stopOverrideTimer];
      [[FlashNotifyProvider sharedInstance] stopNotificationTimer];
      [[FlashNotifyProvider sharedInstance] stopMonitoringAccelerometer];
    }
  }
%end

%hook BBServer
  -(instancetype)initWithQueue:(id)arg1 {
    return [FlashNotifyProvider sharedInstance].bulletinServer = %orig;
  }
%end

%hook BBBulletin
  -(instancetype)responseForAction:(BBAction *)arg1 {
    if([arg1.identifier isEqualToString:kFlashNotifyBulletinAction]) {
      [[FlashNotifyProvider sharedInstance] disableFlashlight];

      return nil;
    }

    return %orig;
  }
%end

%hook BBDataProviderConnection
  -(instancetype)initWithServiceName:(id)arg1 onQueue:(id)arg2 {
    initDelay = YES;

    return [FlashNotifyProvider sharedInstance].dataProviderConnection = %orig;
  }
%end

static void sendTestNotification() {
  [[FlashNotifyProvider sharedInstance] sendFlashlightNotification];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)sendTestNotification, CFSTR("com.lacertosusrepo.flashnotifyprefs-sendTestNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.flashnotifyprefs"];
  [preferences registerDefaults:@{
    @"hasAccelerometer" : @YES,
    @"unpluggedNotificationDelay" : @120,
    @"notifyWhileCharging" : @YES,
    @"chargingNotificationDelay" : @180,
    @"useAccelerometerType" : [NSNumber numberWithInt:FNMAccelerometerModeDisabled],
    @"faceUpDelay" : @20,
    @"faceDownDelay" : @20,
    @"autoDisableFlashlight" : @YES,
    @"maxFlashlightDuration" : @600,
    @"notificationIconStyle" : @"icon~dark",
  }];

  [preferences registerPreferenceChangeBlock:^{
    if(initDelay) {
      [[FlashNotifyProvider sharedInstance] updatePreferences];
    }
  }];
}
