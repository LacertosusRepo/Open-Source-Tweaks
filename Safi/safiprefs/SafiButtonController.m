//Thanks to Sticktron and his tweak "Ah! Ah! Ah!"
#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>

#define Switch_Color [UIColor colorWithRed:0.42 green:0.36 blue:0.91 alpha:1.0]

@interface SafiButtonCell : PSTableCell
@end

@implementation SafiButtonCell

	- (void)layoutSubviews {
		
		//Sets UIButton Color
		[super layoutSubviews];
		[self.textLabel setTextColor:Switch_Color];

	}
	
@end