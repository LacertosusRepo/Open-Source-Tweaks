//Thanks to Sticktron and his tweak "Ah! Ah! Ah!"

#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>

#define Switch_Color [UIColor colorWithRed:0.20 green:0.29 blue:0.37 alpha:1.0]

@interface ObscuriteButtonCell : PSTableCell
@end

@implementation ObscuriteButtonCell

	- (void)layoutSubviews {
		
		//Sets UIButton Color
		[super layoutSubviews];
		[self.textLabel setTextColor:Switch_Color];

	}
	
@end