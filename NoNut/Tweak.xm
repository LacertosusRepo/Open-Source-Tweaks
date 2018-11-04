@interface IncognitoViewController : UIViewController
//@property (nonatomic, assign, readwrite, getter=isIncognito) BOOL incognito;
-(void)noNutAlert;
@end

@interface TabModel : NSObject
-(void)closeTab:(id)arg1;
-(id)currentTab;
@end

TabModel * tabControl;

%hook TabModel
  -(id)initWithSessionWindow:(id)arg1 sessionService:(id)arg2 browserState:(id)arg3 {
    return tabControl = %orig;
  }
%end

%hook IncognitoViewController
  -(void)wasShown {
    NSLog(@"Called");
    %orig;
    [self noNutAlert];
  }

%new

-(void)noNutAlert {
  UIAlertController * pendingNutAlert = [UIAlertController alertControllerWithTitle:@"Zip those pants back up!"
                                      message:@"Stop! If you continue you shall to fail your duty!"
                                      preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction * surrenderAction = [UIAlertAction actionWithTitle:@"I will Abstain!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    [tabControl closeTab:[tabControl currentTab]];
  }];

  UIAlertAction * failAction = [UIAlertAction actionWithTitle:@"Submit to the Urge" style:UIAlertActionStyleDestructive handler:nil];

  [pendingNutAlert addAction:surrenderAction];
  [pendingNutAlert addAction:failAction];
  [self presentViewController:pendingNutAlert animated:YES completion:nil];
}
%end
