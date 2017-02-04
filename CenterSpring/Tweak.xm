//iOS 10 methods for shutting down, restarting SpringBoard, and rebooting
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
-(void)shutdownAndReboot:(BOOL)arg1;
-(void)shutdownWithOptions:(unsigned long long)arg1;
@end

//Variables
static BOOL canShowAlert;
UIAlertController* alert;

%hook SBControlCenterController
	
	//If the CC is pulled past a certain point, the alert will be presented
	//once the gesture is released
	-(void)_showControlCenterGestureEndedWithGestureRecognizer:(id)arg1 {
		
		if(canShowAlert == YES) {
			
			//Initial Alert
			UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil
								    message:nil
								    preferredStyle:UIAlertControllerStyleAlert];
			
			//Respring Action
			UIAlertAction* spring = [UIAlertAction actionWithTitle:@"Respring"
							       style:UIAlertActionStyleDefault
							       handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
                          
                    }];
					
			/*UIAlertAction* safemode = [UIAlertAction actionWithTitle:@"SafeMode"
								   style:UIAlertActionStyleDefault
								   handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] perfromSelector:@selector(enterSafeMode) withObject:nil afterDelay:0.0];
                          
                    }];*/
			
			//Reboot Action
			UIAlertAction* reboot = [UIAlertAction actionWithTitle:@"Reboot"
							       style:UIAlertActionStyleDefault
							       handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
                          
                    }];
			
			//Shutdown Action
			UIAlertAction* shutdown = [UIAlertAction actionWithTitle:@"Shutdown"
								 style:UIAlertActionStyleDefault
								 handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] shutdownWithOptions:nil];
                          
                    }];
			
			//Dissmiss Alert
			UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Nevermind"
							       style:UIAlertActionStyleDefault
							       handler:^(UIAlertAction * action)
                    {
                        [alert dismissViewControllerAnimated:YES completion:nil];
						canShowAlert = NO;
                          
                    }];
			
			//Adds actions to alert
			[alert addAction:spring];
			//[alert addAction:safemode];
			[alert addAction:reboot];
			[alert addAction:shutdown];
			[alert addAction:cancel];
			[self presentViewController:alert animated:YES completion:nil];
			//HBLogInfo(@"Showing Alert");
		}
	%orig;
		
	}
	
	-(void)_revealSlidingViewToHeight:(double)arg1 {
		
		//Detects if the threshold is met for the CC height
		//HBLogInfo(@"CC is at %f",arg1);
		if(arg1 > 675 && arg1 < 725) {
			
			canShowAlert = YES;
			
		}
		%orig;
	}
	
	-(void)_endPresentation {
		
		//Just a precaution to dismiss the alert incase the CC was accidentally dismissed
		[alert dismissViewController:alert animated:YES completion:nil];
		%orig;
	}

%end
