#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>
#include <spawn.h>

#import "PreferencesColorDefinitions.h"

@interface LBMGeneralListController : PSListController
- (void)minimizeSettings;
- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay;
- (void)respring;
@end
