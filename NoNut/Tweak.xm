  //--Classes--//
@interface IncognitoViewController : UIViewController
-(void)noNutAlert;
@end

@interface TabModel : NSObject
-(void)closeTab:(id)arg1;
-(id)currentTab;
@end

@interface BrowserController : NSObject
@property (nonatomic, assign, readwrite, getter=isPrivateBrowsingEnabled) BOOL privateBrowsingEnabled;
-(void)togglePrivateBrowsingEnabled;
-(void)noNutAlert;
@end


  //Pref Vars
  static NSString * titleNN;
  static NSString * messageNN;
  static NSString * abstainNN;
  static NSString * failNN;
  static BOOL onlyOneAlert = YES;

  //Vars
  TabModel * tabControl;
  BrowserController * browserControl;
  static BOOL sentAlertThisSession;


  //--Chrome--//
%hook TabModel
  -(id)initWithSessionWindow:(id)arg1 sessionService:(id)arg2 browserState:(id)arg3 {
      //get TabModel instance
    return tabControl = %orig;
  }
%end

%hook TabGridViewController
  -(id)init {
      //set alert as not shown this session
    sentAlertThisSession = NO;
    return %orig;
  }
%end

%hook IncognitoViewController
  -(void)wasShown {
    %orig;
      //check if alert should be shown when a incognito tab is opened
    if(onlyOneAlert && !sentAlertThisSession) {
      [self noNutAlert];
    } else if(!onlyOneAlert) {
      [self noNutAlert];
    }
  }

%new

  -(void)noNutAlert {
      //check if any of the strings are nil, if they are replace it with default
    if([titleNN isEqualToString:@""]) {
      titleNN = @"No Nut November";
    } if([messageNN isEqualToString:@""]) {
      messageNN = @"Don't fucking move, you can still turn back.";
    } if([abstainNN isEqualToString:@""]) {
      abstainNN = @"I Will Abstain!";
    } if([failNN isEqualToString:@""]) {
      failNN = @"Submit to the Urge";
    }

      //setup alert
    UIAlertController * pendingNutAlert = [UIAlertController alertControllerWithTitle:titleNN message:messageNN preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * abstainAction = [UIAlertAction actionWithTitle:abstainNN style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //closes current tab if the user chooses to abstain
      [tabControl closeTab:[tabControl currentTab]];
    }];

    UIAlertAction * failAction = [UIAlertAction actionWithTitle:failNN style:UIAlertActionStyleDestructive handler:nil];

      //add actions to alert
    [pendingNutAlert addAction:abstainAction];
    [pendingNutAlert addAction:failAction];
    [self presentViewController:pendingNutAlert animated:YES completion:^{
      sentAlertThisSession = YES;
    }];
  }
%end

  //Safari
%hook BrowserController

  -(void)togglePrivateBrowsingEnabled {
    %orig;
      //check if alert should be shown when a private tab is opened
    if(self.privateBrowsingEnabled) {
      if(onlyOneAlert && !sentAlertThisSession) {
        [self noNutAlert];
      } else if(!onlyOneAlert) {
        [self noNutAlert];
      }
    }
  }

%new

  -(void)noNutAlert {
      //check if any of the strings are nil, if they are replace it with default
    if([titleNN isEqualToString:@""]) {
      titleNN = @"No Nut November";
    } if([messageNN isEqualToString:@""]) {
      messageNN = @"Don't fucking move, you can still turn back.";
    } if([abstainNN isEqualToString:@""]) {
      abstainNN = @"I Will Abstain!";
    } if([failNN isEqualToString:@""]) {
      failNN = @"Submit to the Urge";
    }

      //setup alert
    UIAlertController * pendingNutAlert = [UIAlertController alertControllerWithTitle:titleNN message:messageNN preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * abstainAction = [UIAlertAction actionWithTitle:abstainNN style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
      //closes current tab if the user chooses to abstain
      [self togglePrivateBrowsingEnabled];
    }];

    UIAlertAction * failAction = [UIAlertAction actionWithTitle:failNN style:UIAlertActionStyleDestructive handler:nil];

      //add actions to alert
    [pendingNutAlert addAction:abstainAction];
    [pendingNutAlert addAction:failAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pendingNutAlert animated:YES completion:^{
      sentAlertThisSession = YES;
    }];
  }
%end

static void loadPrefs() {
  NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.nonutprefs.plist"];
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    titleNN = @"No Nut November";
    messageNN = @"Don't fucking move, you can still turn back.";
    abstainNN = @"I Will Abstain!";
    failNN = @"Submit to the Urge";
    onlyOneAlert = YES;
    [preferences writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.nonutprefs.plist" atomically:YES];
  } else {
    titleNN = [preferences objectForKey:@"titleNN"];
    messageNN = [preferences objectForKey:@"messageNN"];
    abstainNN = [preferences objectForKey:@"abstainNN"];
    failNN = [preferences objectForKey:@"failNN"];
    onlyOneAlert = [[preferences objectForKey:@"onlyOneAlert"] boolValue];
  }
  [preferences release];
}

static NSString *nsNotificationString = @"com.lacertosusrepo.nonutprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPrefs();
}

%ctor {
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
  [pool release];
}
