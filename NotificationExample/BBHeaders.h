@interface BBAction : NSObject
+ (id)action;
+ (id)actionWithLaunchURL:(id)url;
+ (id)sharedInstance;
@end

@interface BBBulletin
@property(copy, nonatomic) NSString *sectionID;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *subtitle;
@property(copy, nonatomic) NSString *message;
@property(copy, nonatomic) BBAction *defaultAction;
@property(retain, nonatomic) NSDate *date;
@property(retain, nonatomic) NSDate *publicationDate;
@property(retain, nonatomic) NSDate *lastInterruptDate;
@property(copy, nonatomic) NSString *bulletinID;
@property(assign, nonatomic) BOOL clearable;
@property(assign, nonatomic) BOOL showsMessagePreview;
@end

@interface BBBulletinRequest : BBBulletin
@end

@interface BBServer : NSObject
- (id)_sectionInfoForSectionID:(NSString *)sectionID effective:(BOOL)effective;
- (void)publishBulletin:(BBBulletin *)bulletin destinations:(NSUInteger)dests alwaysToLockScreen:(BOOL)lock;
@end

@interface NSObject ()
@property (assign,nonatomic) UIEdgeInsets clippingInsets;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *sectionID;
@property (copy, nonatomic) id defaultAction;
@property (copy) NSString *secondaryText;
@property(retain, nonatomic) id topAlert; // @synthesize topAlert=_topAlert;

+ (id)action;
+ (id)sharedInstance;

- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSInteger)arg3;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3 playLightsAndSirens:(_Bool)arg4 withReply:(id)arg5;

- (void)tb_createLabelsIfNecessary;
- (NSAttributedString *)tb_addFont:(NSString *)font toString:(NSAttributedString *)string bounds:(CGRect)bounds;
- (UIFont *)scaledFont:(UIFont *)font fromSize:(CGSize)size toRect:(CGRect)bounds;

- (void)_cancelBannerDismissTimers;
- (void)_setUpBannerDismissTimers;

- (BOOL)_isItalicizedAttributedString:(NSAttributedString *)arg1;
- (NSAttributedString *)_newAttributedStringForSecondaryText:(NSString *)arg1 italicized:(BOOL)arg2;
- (NSAttributedString *)_attributedStringForSecondaryText:(NSString *)arg1 italicized:(BOOL)arg2;

- (BOOL)isPulledDown;
- (BOOL)showsKeyboard;
- (void)_dismissOverdueOrDequeueIfPossible;
- (void)_dismissBannerWithAnimation:(_Bool)arg1 reason:(NSInteger)arg2 forceEvenIfBusy:(_Bool)arg3 completion:(id)arg4;
- (void)_tryToDismissWithAnimation:(_Bool)arg1 reason:(NSInteger)arg2 forceEvenIfBusy:(_Bool)arg3 completion:(id)arg4;
- (id)_bannerContext;
- (id)_bannerItem;
- (id)seedBulletin;
@end