  //import HBPreferences header
#import <Cephei/HBPreferences.h>

  //Create preference variables
    BOOL exampleSwitch;

  //Example hook of all status bar strings
%hook _UIStatusBarStringView
  -(void)setText:(NSString *)text {
      //if our exampleSwitch is YES, change the text argument to our custom string. Otherwise nothing will be changed.
    if(exampleSwitch) {
      text = @"🅱️ 🅱️ 🅱️ 🅱️";
    }

    //continue with %orig
    %orig;
  }
%end

%ctor {
    //Create HBPreferences instance with your identifier, usually i just add prefs to the end of my package identifier
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.examplecepheiprojectprefs"];

    //register preference variables, naming the preference key and variable the same thing reduces confusion for me.
  [preferences registerBool:&exampleSwitch default:YES forKey:@"exampleSwitch"];
}
