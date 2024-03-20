#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>

#import "PreferencesColorDefinitions.h"
#import "DIPAppColorCell.h"

@interface DIPModifyCachedAppColorsController : PSListController <DIPAppColorCellDelegate>
@property (nonatomic, retain) NSMutableDictionary *cachedAppColors;
@end
