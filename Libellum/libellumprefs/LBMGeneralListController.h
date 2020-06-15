#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>

#import "PreferencesColorDefinitions.h"

@interface LBMGeneralListController : HBRootListController
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
@end
