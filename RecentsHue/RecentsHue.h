enum CallType : NSInteger {
  kCallTypeNormal = 1,
  kCallTypeVoicemail = 2,
  kCallTypeVOIP = 4,
  kCallTypeTelephony = 7,
  kCallTypeFaceTimeVideo = 8,
  kCallTypeFaceTimeAudio = 16,
  kCallTypeFaceTime = 24,
};

@interface CHRecentCall : NSObject
@property (nonatomic, assign, readwrite) unsigned int callType;
+(NSString *)callTypeAsString:(int)arg1;
@end

@interface MPRecentsTableViewCell : UITableViewCell
@property (strong) UILabel *subtitleLabel;

  //RecentsHue
@property (nonatomic, retain) UIView *_colorIndicator;
@end

@interface MPRecentsTableViewController : UIViewController
-(CHRecentCall *)recentCallAtTableViewIndex:(NSInteger)arg1;
@end
