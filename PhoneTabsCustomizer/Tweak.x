/*
 * Tweak.x
 * PhoneTabsCustomizer
 */
#import <UIKit/UIKit.h>
#import <os/log.h>
#import <Cephei/HBPreferences.h>

@interface PhoneTabBarController : UITabBarController
-(id)viewControllerForTabViewType:(int)arg1;
-(void)_updateBottomTabs;
@end

    //Global
  static PhoneTabBarController *phoneTabBarController;

    //Preferences
  static BOOL showFavorites;
  static BOOL showRecents;
  static BOOL showContacts;
  static BOOL showKeypad;
  static BOOL showVoicemail;

%hook PhoneTabBarController
  -(void)showFavoritesTab:(BOOL)arg1 recentsTab:(BOOL)arg2 contactsTab:(BOOL)arg3 keypadTab:(BOOL)arg4 voicemailTab:(BOOL)arg5 {
    phoneTabBarController = (phoneTabBarController) ?: self;

    %orig(showFavorites, showRecents, showContacts, showKeypad, showVoicemail);
  }

  -(void)switchToTab:(int)arg1 {
    if(![self viewControllerForTabViewType:arg1]) {
      for(int i = 1; i <=5; i++) {
        if([self viewControllerForTabViewType:i]) {
          arg1 = i;
          break;
        }
      }
    }

    %orig;
  }
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.phonetabscustomizerprefs"];
  [preferences registerBool:&showFavorites default:YES forKey:@"showFavorites"];
  [preferences registerBool:&showRecents default:YES forKey:@"showRecents"];
  [preferences registerBool:&showContacts default:YES forKey:@"showContacts"];
  [preferences registerBool:&showKeypad default:YES forKey:@"showKeypad"];
  [preferences registerBool:&showVoicemail default:YES forKey:@"showVoicemail"];
  [preferences registerPreferenceChangeBlock:^{
    if(phoneTabBarController) {
      if(![phoneTabBarController respondsToSelector:@selector(_updateBottomTabs)]) {
        [phoneTabBarController _updateBottomTabs];
      } else {
        exit(0);
      }
    }
  }];
}
