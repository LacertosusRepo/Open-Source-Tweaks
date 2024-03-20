#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>

#import <rootless.h>
#include <spawn.h>

#import "DIPHeaderView.h"
#import "PreferencesColorDefinitions.h"

@interface DIPRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
- (void)minimizeSettings;
- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay;
- (void)respring;
@end
