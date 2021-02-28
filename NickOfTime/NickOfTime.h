#import <UIKit/UIKit.h>

@interface MTAlarm : NSObject
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, copy) NSString *displayTitle;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, readonly) NSUUID *alarmID;
@end

@interface MTAlarmCache : NSObject
@property (nonatomic, retain) NSMutableArray *orderedAlarms;
-(void)getCachedAlarmsWithCompletion:(id)arg1;
@end

@interface MTAlarmManager : NSObject
@property (nonatomic, retain) MTAlarmCache *cache;
-(MTAlarm *)alarmWithIDString:(NSString *)arg1;
-(id)updateAlarm:(MTAlarm *)arg1;
@end

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
-(instancetype)initWithSystemImageName:(NSString *)arg1;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, assign) NSInteger activationMode;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@property (nonatomic, copy) NSDictionary *userInfo;
@end

@interface MTAAlarmEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) MTAlarm *originalAlarm;
@end

@interface SBApplicationInfo : NSObject
@property (nonatomic, readonly) NSUserDefaults *userDefaults;
@end

@interface SBApplication : NSObject
@property (nonatomic, strong, readwrite) SBApplicationInfo *info;
@end

@interface SBApplicationController : NSObject
+(instancetype)sharedInstanceIfExists;
-(SBApplication *)applicationWithBundleIdentifier:(NSString *)arg1;
@end

@interface SBIconView : UIView
@property (nonatomic, copy) NSString *applicationBundleIdentifierForShortcuts;
@end
