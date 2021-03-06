#import <UIKit/UIKit.h>

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
-(instancetype)initWithSystemImageName:(NSString *)arg1;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, assign) NSInteger activationMode;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@property (nonatomic, copy) NSDictionary *userInfo;
@end

@interface SBIcon : NSObject
@property (nonatomic, readonly, getter=isUninstallSupported) BOOL uninstallSupported;
@end

@interface SBIconView : UIView
@property (nonatomic, strong, readwrite) SBIcon *icon;
@property (nonatomic, copy) NSString *applicationBundleIdentifierForShortcuts;
@end

@interface SearchUIAppIcon : SBIcon
@end

@interface SearchUIHomeScreenAppIconView : SBIconView
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
-(void)requestUninstallApplicationWithBundleIdentifier:(NSString *)arg1 options:(NSUInteger)arg2 withCompletion:(id)arg3 ;
@end
