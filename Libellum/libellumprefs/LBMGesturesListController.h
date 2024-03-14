#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>
#include <spawn.h>

#import "PreferencesColorDefinitions.h"

@interface PSListController (iOS12Methods)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface LBMGesturesListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
- (void)minimizeSettings;
- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay;
- (void)respring;
@end
