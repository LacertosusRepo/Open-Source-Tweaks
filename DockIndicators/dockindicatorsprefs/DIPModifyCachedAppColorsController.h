#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>
#import "PreferencesColorDefinitions.h"
#import "DIPAppColorCell.h"

@interface DIPModifyCachedAppColorsController : HBRootListController <DIPAppColorCellDelegate>
@property (nonatomic, retain) NSMutableDictionary *cachedAppColors;
@end
