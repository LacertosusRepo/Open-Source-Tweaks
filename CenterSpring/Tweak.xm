@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
-(void)shutdownAndReboot:(BOOL)arg1;
-(void)shutdownWithOptions:(unsigned long long)arg1;
@end

static BOOL canShowAlert;
UIAlertController* alert;

%hook SBControlCenterController

	-(void)_showControlCenterGestureEndedWithGestureRecognizer:(id)arg1 {
		
		if(canShowAlert == YES) {

			UIAlertController * alert=   [UIAlertController
									alertControllerWithTitle:nil
									message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
								 
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
					
			UIAlertAction* reboot = [UIAlertAction actionWithTitle:@"Reboot"
												   style:UIAlertActionStyleDefault
							handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
                          
                    }];
					
			UIAlertAction* shutdown = [UIAlertAction actionWithTitle:@"Shutdown"
												   style:UIAlertActionStyleDefault
							handler:^(UIAlertAction * action)
                    {
                        [[%c(FBSystemService) sharedInstance] shutdownWithOptions:nil];
                          
                    }];
					
			UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Nevermind"
												   style:UIAlertActionStyleDefault
							handler:^(UIAlertAction * action)
                    {
                        [alert dismissViewControllerAnimated:YES completion:nil];
						canShowAlert = NO;
                          
                    }];

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
		
		//HBLogInfo(@"CC is at %f",arg1);
		if(arg1 > 675 && arg1 < 725) {
			
			canShowAlert = YES;
			
		}
		%orig;
	}
	
	-(void)_endPresentation {
		
		[alert dismissViewControllerAnimated:YES completion:nil];
		%orig;
	}

%end
