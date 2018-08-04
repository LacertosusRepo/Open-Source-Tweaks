//Thanks to Sticktron and his tweak "Ah! Ah! Ah!"
#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>
#import "PreferencesColorDefinitions.h"

@interface SafiButtonCell : PSTableCell
@end

@implementation SafiButtonCell

	- (void)layoutSubviews {

		//Sets UIButton Color
		[super layoutSubviews];
		[self.textLabel setTextColor:Button_Color];

	}

@end
