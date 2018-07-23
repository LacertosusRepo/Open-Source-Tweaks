  //--Prefs--//
static NSString * domainString = @"com.lacertosusrepo.imperiumprefs";
static NSString * notificationString = @"com.lacertosusrepo.imperiumprefs/preferences.changed";

@interface MediaControlsContainerView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface MediaControlsParentContainerView : UIView
@end

@interface ImperiumGestureController : NSObject
+(void)callImpact;
+(void)selectGesture:(int)gesture;
@end

@interface NSUserDefaults (UFS_Category)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
