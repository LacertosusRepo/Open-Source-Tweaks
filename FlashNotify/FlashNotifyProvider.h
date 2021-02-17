#import <CoreMotion/CoreMotion.h>
#import <BulletinBoard/BBDataProvider.h>
#import <BulletinBoard/BBSectionInfoSettings.h>

static NSString *const kFlashNotifyBulletinID = @"com.lacertosusrepo.FlashNotify.app";
static NSString *const kFlashNotifyBulletinAction = @"com.lacertosusrepo.FlashNotify-Action";

enum useAccelerometerModes : NSInteger {
  FNMAccelerometerModeDisabled = 0,
  FNMAccelerometerModeFaceUp,
  FNMAccelerometerModeFaceDown,
  FNMAccelerometerModeBoth,
};

struct SBIconImageInfo {
  CGSize size;
  CGFloat scale;
  CGFloat continuousCornerRadius;
};

@interface PCSimpleTimer : NSObject
@property(assign, nonatomic) BOOL disableSystemWaking;
-(instancetype)initWithTimeInterval:(double)arg1 serviceIdentifier:(NSString *)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
-(void)scheduleInRunLoop:(id)arg1;
-(void)invalidate;
-(BOOL)isValid;
@end

//@interface SBIcon : NSObject
//-(UIImage *)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
//@end

//@interface SBIconModel : NSObject
//-(SBIcon *)expectedIconForDisplayIdentifier:(NSString *)arg1;
//@end

//@interface SBIconController : NSObject
//@property (nonatomic, retain) SBIconModel *model;
//+(instancetype)sharedInstance;
//@end

@interface SBUIFlashlightController : NSObject
@property(assign, nonatomic) unsigned long long level;
+(instancetype)sharedInstance;
-(void)setLevel:(unsigned long long)arg1;
@end

@interface BBAction : NSObject
@property(nonatomic, copy) NSString *identifier;
+(instancetype)actionWithIdentifier:(NSString *)arg1;
@end

@interface BBSectionIconVariant : NSObject
+(instancetype)variantWithFormat:(long long)arg1 imageData:(NSData *)arg2;
@end

@interface BBSectionIcon : NSObject
-(void)addVariant:(BBSectionIconVariant *)arg1;
@end

@interface BBDataProviderIdentity : NSObject
@property (nonatomic, copy) NSString * sectionDisplayName;
@property (nonatomic, copy) NSString * sortKey;
@property (nonatomic, copy) NSString * sectionIdentifier;
@property (nonatomic, copy) BBSectionInfo * defaultSectionInfo;
+(instancetype)identityForDataProvider:(id)arg1;
@end

@interface BBSectionInfo : NSObject
@property (assign,nonatomic) unsigned long long notificationCenterLimit;
@property (assign,nonatomic) BOOL enabled;
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) BBSectionIcon * icon;
@property (assign,nonatomic) unsigned long long alertType;
@property (assign,nonatomic) unsigned long long pushSettings;
@property (assign,nonatomic) BOOL allowsNotifications;
@property (assign,nonatomic) NSString *appName;
+(id)defaultSectionInfoForType:(long long)arg1 ;
-(void)setShowsInNotificationCenter:(BOOL)arg1 ;
-(void)setShowsInLockScreen:(BOOL)arg1 ;
@end

//@interface BBButton : NSObject
//+(instancetype)buttonWithTitle:(NSString *)arg1 action:(BBAction *)arg2;
//@end

//@interface BBAppearance : NSObject
//+(instancetype)appearanceWithTitle:(NSString *)arg1;
//-(void)setStyle:(long long)arg1;
//@end

@interface BBBulletin : NSObject
@end

@interface BBBulletinRequest : BBBulletin
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *sectionID;
@property (nonatomic, copy) NSString *bulletinID;
@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, copy) NSString *publisherBulletinID;
@property (assign, nonatomic) BOOL turnsOnDisplay;
@property (nonatomic, retain) BBSectionIcon *icon;
@property (assign, nonatomic) long long lockScreenPriority;
@property (assign, nonatomic) BOOL preventAutomaticRemovalFromLockScreen;
@property (nonatomic, assign) BBAction *defaultAction;
@property (nonatomic, assign) BOOL clearable;
//-(void)addButton:(BBButton *)arg1;
@end

@interface BBServer : NSObject
-(id)dataProviderForSectionID:(NSString *)arg1;
-(void)withdrawBulletinRequestsWithPublisherBulletinID:(NSString *)arg1 forSectionID:(NSString *)arg2;
@end

@interface BBDataProviderConnection : NSObject
-(id)addDataProvider:(id)arg1;
@end

@interface FlashNotifyProvider : BBDataProvider <BBDataProvider>
@property (nonatomic, retain, readonly) PCSimpleTimer *overrideTimer;
@property (nonatomic, retain, readonly) PCSimpleTimer *notificationTimer;
@property (nonatomic, retain) BBServer *bulletinServer;
@property (nonatomic, retain) BBDataProviderConnection *dataProviderConnection;
@property (nonatomic, retain, readonly) BBBulletinRequest *bulletinRequest;
@property (nonatomic, retain, readonly) CMMotionManager *motionManager;

  //Preferences
@property (nonatomic, assign) NSInteger unpluggedNotificationDelay;
@property (nonatomic, assign) BOOL notifyWhileCharging;
@property (nonatomic, assign) NSInteger chargingNotificationDelay;
@property (nonatomic, assign) NSInteger useAccelerometerType;
@property (nonatomic, assign) NSInteger faceUpDelay;
@property (nonatomic, assign) NSInteger faceDownDelay;
@property (nonatomic, assign) BOOL autoDisableFlashlight;
@property (nonatomic, assign) NSInteger maxFlashlightDuration;
@property (nonatomic, assign) NSString *notificationIconStyle;

+(instancetype)sharedInstance;
-(void)startOverrideTimer;
-(void)stopOverrideTimer;
-(void)startNotificationTimer;
-(void)stopNotificationTimer;
-(void)sendFlashlightNotification;
-(void)startMonitoringAccelerometer;
-(void)stopMonitoringAccelerometer;
-(void)disableFlashlight;
-(void)updatePreferences;
@end
