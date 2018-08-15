@interface NCNotificationContentView : UIView
@property (nonatomic,retain) NSString * secondaryText;
@end

@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(BOOL)isUILocked;
@end

%hook NCNotificationContentView
  -(void)layoutSubviews {
    %orig;
    //Checks if notification holds "code:" and if the device is unlocked
    if([self.secondaryText localizedCaseInsensitiveContainsString:@"code:"] && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
      [self setSecondaryText:@"Open app to view message."];
    }
  }
%end
