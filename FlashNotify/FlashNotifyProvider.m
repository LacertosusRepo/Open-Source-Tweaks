/*
 * FlashNotifyProvider.m
 * FlashNotify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/30/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import <os/log.h>
#import <Cephei/HBPreferences.h>
#import "FlashNotifyProvider.h"

  extern dispatch_queue_t __BBServerQueue;
  extern void BBDataProviderAddBulletin(id<BBDataProvider> dataProvider, BBBulletinRequest *bulletinRequest);

@implementation FlashNotifyProvider {
  HBPreferences *_preferences;
}

  +(instancetype)sharedInstance {
    static FlashNotifyProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[FlashNotifyProvider alloc] init];
    });

    return sharedInstance;
  }

  -(instancetype)init {
    if(self = [super init]) {
      _preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.flashnotifyprefs"];

      BBDataProviderIdentity *identity = [BBDataProviderIdentity identityForDataProvider:self];
      identity.sectionIdentifier = kFlashNotifyBulletinID;
      identity.sectionDisplayName = @"FlashNotify";
      identity.sortKey = @"date";
      identity.defaultSectionInfo = [self sectionInfo];
      identity.defaultSectionInfo.pushSettings = BBSectionInfoPushSettingsAlerts;
      self.identity = identity;

      [self updatePreferences];
      [self createMotionManager];
    }

    return self;
  }

#pragma mark - BBDataProvider
//https://github.com/Itaybre/Chusma/blob/f4a64bf2e32e53a538e9251932ab0a1178c57b99/ChusmaBulletinProvider.x

  -(BBSectionInfo *)sectionInfo {
    BBSectionInfo *sectionInfo = [BBSectionInfo defaultSectionInfoForType:0];
    sectionInfo.notificationCenterLimit = 1;
    sectionInfo.sectionID = kFlashNotifyBulletinID;
    sectionInfo.appName = @"FlashNotify";
    sectionInfo.allowsNotifications = YES;
    sectionInfo.alertType = 1;
    sectionInfo.pushSettings = BBSectionInfoPushSettingsAlerts;
    sectionInfo.enabled = YES;
    sectionInfo.icon = [self sectionIcon];
    [sectionInfo setShowsInLockScreen:YES];
    [sectionInfo setShowsInNotificationCenter:YES];

    return sectionInfo;
  }

  -(BBSectionIcon *)sectionIcon {
    /*SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBIcon *icon = [iconController.model expectedIconForDisplayIdentifier:kFlashNotifyBulletinID];

    struct SBIconImageInfo iconInfo;
    iconInfo.size = CGSizeMake(60, 60);
    iconInfo.scale = [UIScreen mainScreen].scale;
    iconInfo.continuousCornerRadius = 0;*/

    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/flashnotifyprefs.bundle/%@.png", _notificationIconStyle]];
    BBSectionIcon *sectionIcon = [[BBSectionIcon alloc] init];
    BBSectionIconVariant *iconVariant = [BBSectionIconVariant variantWithFormat:0 imageData:UIImagePNGRepresentation(image)];
    [sectionIcon addVariant:iconVariant];

    return sectionIcon;
  }

  -(NSArray *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
  }

  -(NSArray *)bulletinsFilteredBy:(NSUInteger)by count:(NSUInteger)count lastCleared:(id)cleared {
    return nil;
  }

  -(void)addDataProviderIfNeccessary {
    dispatch_async(__BBServerQueue, ^{
      if(![_bulletinServer dataProviderForSectionID:kFlashNotifyBulletinID]) {
        [_dataProviderConnection addDataProvider:self];
      }
    });
  }

#pragma mark - FlashNotify Functions

  -(void)startOverrideTimer {
    if(_autoDisableFlashlight) {
      if(_overrideTimer) {
        [_overrideTimer invalidate];
        _overrideTimer = nil;
      }

      _overrideTimer = [[NSClassFromString(@"PCSimpleTimer") alloc] initWithTimeInterval:_maxFlashlightDuration serviceIdentifier:[NSString stringWithFormat:@"%@-OverrideTimer", kFlashNotifyBulletinID] target:self selector:@selector(disableFlashlight) userInfo:nil];
      _overrideTimer.disableSystemWaking = NO;
      [_overrideTimer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
    }
  }

  -(void)stopOverrideTimer {
    if(_overrideTimer) {
      [_overrideTimer invalidate];
      _overrideTimer = nil;
    }
  }

  -(void)startNotificationTimer {
    [self addDataProviderIfNeccessary];

    if(_notificationTimer) {
      [_notificationTimer invalidate];
      _notificationTimer = nil;
    }

    NSInteger timeInterval = ([UIDevice currentDevice].batteryState == 2 && _notifyWhileCharging) ? _chargingNotificationDelay : _unpluggedNotificationDelay;
    _notificationTimer = [[NSClassFromString(@"PCSimpleTimer") alloc] initWithTimeInterval:timeInterval serviceIdentifier:[NSString stringWithFormat:@"%@-NotificationTimer", kFlashNotifyBulletinID] target:self selector:@selector(sendFlashlightNotification) userInfo:nil];
    _notificationTimer.disableSystemWaking = NO;
    [_notificationTimer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
  }

  -(void)stopNotificationTimer {
    if(_notificationTimer) {
      [_notificationTimer invalidate];
      _notificationTimer = nil;
    }

    [self removeExistingBulletin];
  }

    //Sniper_GER's post was exeptionally helpful
    //https://old.reddit.com/r/jailbreakdevelopers/comments/hl0z62/ios_13_how_to_create_an_interactive_banner/
    //Along with libbulletin
    //https://github.com/limneos/libbulletin/blob/master/libbulletin.xm
    //And TypeStatus
    //https://github.com/hbang/TypeStatus-Plus/blob/422e9c940f1b1aa595cfa8f69c93df25703cb644/springboard/HBTSPlusBulletinProvider.x
  -(void)sendFlashlightNotification {
    [self addDataProviderIfNeccessary];

    if(!_bulletinRequest) {
      _bulletinRequest = [[BBBulletinRequest alloc] init];
      _bulletinRequest.header = @"FLASHNOTIFY";
      _bulletinRequest.title = @"Did you know your flashlight is still on?";
      _bulletinRequest.message = @"Tap to turn it off!";
      _bulletinRequest.sectionID = kFlashNotifyBulletinID;
      _bulletinRequest.bulletinID = [NSUUID UUID].UUIDString;
      _bulletinRequest.recordID = [NSUUID UUID].UUIDString;
      _bulletinRequest.publisherBulletinID = [NSString stringWithFormat:@"%@-%@", kFlashNotifyBulletinID, [NSUUID UUID].UUIDString];
      _bulletinRequest.turnsOnDisplay = YES;
      _bulletinRequest.lockScreenPriority = 3;
      _bulletinRequest.preventAutomaticRemovalFromLockScreen = YES;
      _bulletinRequest.clearable = YES;
      _bulletinRequest.defaultAction = [BBAction actionWithIdentifier:kFlashNotifyBulletinAction];

      /*BBAction *disableFlashlight = [BBAction actionWithCallblock:^{
        os_log(OS_LOG_DEFAULT, "called");
      }];
      BBAppearance *appearance = [BBAppearance appearanceWithTitle:@"Disable"];
      [appearance setStyle:1];
      [disableFlashlight setAppearance:appearance];
      [_bulletinRequest addButton:[BBButton buttonWithTitle:@"Turn off" action:disableFlashlight]];*/
    }

    BBDataProviderAddBulletin(self, _bulletinRequest);
  }

  -(void)disableFlashlight {
    SBUIFlashlightController *flashlightController = [NSClassFromString(@"SBUIFlashlightController") sharedInstance];
    if(flashlightController.level > 0) {
      [flashlightController setLevel:0];
    }

    [self stopNotificationTimer];
  }

  -(void)removeExistingBulletin {
    if(_bulletinServer) {
      dispatch_async(__BBServerQueue, ^{
        [_bulletinServer withdrawBulletinRequestsWithPublisherBulletinID:_bulletinRequest.publisherBulletinID forSectionID:_bulletinRequest.sectionID];
      });
    }
  }

  -(void)createMotionManager {
    _motionManager = [[CMMotionManager alloc] init];

    [_preferences setBool:_motionManager.accelerometerAvailable forKey:@"hasAccelerometer"];
  }

  -(void)startMonitoringAccelerometer {
    if(_motionManager.accelerometerAvailable) {
      _motionManager.accelerometerUpdateInterval = 1.0;  //Once a second, thats all we really need

      __block int upCounter = 0;
      __block int downCounter = 0;
      [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        BOOL facingUp = (-0.9 >= accelerometerData.acceleration.z && accelerometerData.acceleration.z >= -1.1 && (_useAccelerometerType == FNMAccelerometerModeFaceUp || _useAccelerometerType == FNMAccelerometerModeBoth));
        BOOL facingDown = (0.9 <= accelerometerData.acceleration.z && accelerometerData.acceleration.z <= 1.1 && (_useAccelerometerType == FNMAccelerometerModeFaceDown || _useAccelerometerType == FNMAccelerometerModeBoth));

        if(facingUp) {
          upCounter++;
        }

        if(facingDown) {
          downCounter++;
        }

        if(!facingUp && !facingDown) {
          upCounter = 0;
          downCounter = 0;
        }

        if(upCounter >= _faceUpDelay || downCounter >= _faceDownDelay) {
          upCounter = 0;
          downCounter = 0;

          [self disableFlashlight];
          [self stopNotificationTimer];
          [_motionManager stopAccelerometerUpdates];
        }

        if(error) {
          [_motionManager stopAccelerometerUpdates];
        }
      }];
    }
  }

  -(void)stopMonitoringAccelerometer {
    [_motionManager stopAccelerometerUpdates];
  }

#pragma mark - Preferences

  -(void)updatePreferences {
    _unpluggedNotificationDelay = [_preferences integerForKey:@"unpluggedNotificationDelay"];
    _notifyWhileCharging = [_preferences integerForKey:@"notifyWhileCharging"];
    _chargingNotificationDelay = [_preferences integerForKey:@"chargingNotificationDelay"];

    _useAccelerometerType = [_preferences integerForKey:@"useAccelerometerType"];
    _faceUpDelay = [_preferences integerForKey:@"faceUpDelay"];
    _faceDownDelay = [_preferences integerForKey:@"faceDownDelay"];

    _autoDisableFlashlight = [_preferences boolForKey:@"autoDisableFlashlight"];
    _maxFlashlightDuration = [_preferences integerForKey:@"maxFlashlightDuration"];

    _notificationIconStyle = [_preferences objectForKey:@"notificationIconStyle"];
  }

@end
