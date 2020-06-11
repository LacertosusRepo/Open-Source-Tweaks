#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>

@import Alderis;
#import "AlderisColorPicker.h"
#import "LBMHeaderView.h"
#import "LBMBackupViewController.h"
#import "PreferencesColorDefinitions.h"

@interface PSListController (iOS12Methods)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface LBMRootListController : HBRootListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
@end
