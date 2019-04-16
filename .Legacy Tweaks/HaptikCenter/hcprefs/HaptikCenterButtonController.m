//Thanks to Sticktron and his tweak "Ah! Ah! Ah!"

#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>
#import "HaptikPreferencesDefinitions.h"

@interface HaptikCenterButtonCell : PSTableCell
@end

@implementation HaptikCenterButtonCell

	- (void)layoutSubviews {
	
		[super layoutSubviews];
		[self.textLabel setTextColor:Switch_Color];

	}
	
@end