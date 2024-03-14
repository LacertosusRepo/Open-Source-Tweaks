#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <rootless.h>
#include <spawn.h>

@import Alderis;
#import "AlderisColorPicker.h"
#import "LBMHeaderView.h"
#import "LBMBackupViewController.h"
#import "LBMAnimatedTitleView.h"
#import "PreferencesColorDefinitions.h"

#define LOGS(format, ...) NSLog(@"Libellum: " format, ## __VA_ARGS__)

@interface PSListController (iOS12Methods)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface LBMRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;

- (void)minimizeSettings;
- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay;
- (void)respring;
@end
