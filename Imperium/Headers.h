  //--Prefs--//
static NSString * domainString = @"com.lacertosusrepo.imperiumprefs";
static NSString * notificationString = @"com.lacertosusrepo.imperiumprefs/preferences.changed";

@interface MediaControlsTransportStackView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsTimeControl
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsParentContainerView : UIView
@end

@interface SBApplication : NSObject
@end

@interface SBMediaController : NSObject
@property (copy) SBApplication *nowPlayingApplication;
+(id)sharedInstance;
@end

@interface SBUIController : NSObject
+(id)sharedInstance;
-(void)_activateApplicationFromAccessibility:(id)arg1;
@end

@interface ImperiumGestureController : NSObject
+(void)callImpact;
+(void)selectGesture:(int)command;
@end

@interface NSUserDefaults (UFS_Category)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
