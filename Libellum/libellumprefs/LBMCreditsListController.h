#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>

@import Alderis;
#import "PreferencesColorDefinitions.h"

@interface LBMCreditsListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end
