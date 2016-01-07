%hook SpringBoard

  -(void)applicationDidFinishLaunching:(id)application {
	
		%orig;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello"  //Title of your popup message
				message:@"Insert Text Here"   							  //Message of your popup message
				delegate:self
				cancelButtonTitle:@"Okay"								  //Cancel button text on your popup message
				otherButtonTitles:nil];

			
			[alert show];
			[alert release];											  //Keeps your alert from having memory leaks
} 
%end

//Message me with any questions!