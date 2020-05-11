#import "NAVColorIndicatorCell.h"

@implementation NAVColorIndicatorCell {
	UIView *_colorIndicator;
}

	-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
		self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

		if(self) {
			_colorIndicator = [[UIView alloc] initWithFrame:CGRectZero];
			_colorIndicator.clipsToBounds = YES;
			_colorIndicator.layer.borderColor = ([UIColor respondsToSelector:@selector(labelColor)]) ? [UIColor opaqueSeparatorColor].CGColor : [UIColor systemGrayColor].CGColor;
			_colorIndicator.layer.borderWidth = 3;
			_colorIndicator.layer.cornerRadius = 15;
			_colorIndicator.translatesAutoresizingMaskIntoConstraints = NO;
			[self.contentView addSubview:_colorIndicator];

			[NSLayoutConstraint activateConstraints:@[
				[_colorIndicator.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
				[_colorIndicator.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
				[_colorIndicator.heightAnchor constraintEqualToConstant:30],
				[_colorIndicator.widthAnchor constraintEqualToConstant:30],
			]];
		}

		if([[specifier propertyForKey:@"defaults"] length] > 0) {
			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:[specifier propertyForKey:@"defaults"]];
			NSArray *colorComponents = [[preferences objectForKey:[specifier propertyForKey:@"key"]] componentsSeparatedByString:@":"];
			NSString *hex = ([colorComponents count] > 0) ? [colorComponents firstObject] : @"#FFFFFF";
			CGFloat alpha = ([colorComponents count] > 1) ? [[colorComponents lastObject] floatValue] : 1.0;

			[UIView transitionWithView:_colorIndicator duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				_colorIndicator.backgroundColor = [self colorFromHex:hex withAlpha:alpha];
			} completion:nil];
		}

		return self;
	}

	-(void)setCellEnabled:(BOOL)enabled {
		[super setCellEnabled:enabled];

		if([[self.specifier propertyForKey:@"defaults"] length] > 0) {
			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:[self.specifier propertyForKey:@"defaults"]];
			NSArray *colorComponents = [[preferences objectForKey:[self.specifier propertyForKey:@"key"]] componentsSeparatedByString:@":"];
			NSString *hex = ([colorComponents count] > 0) ? [colorComponents firstObject] : @"#FFFFFF";
			CGFloat alpha = ([colorComponents count] > 1) ? [[colorComponents lastObject] floatValue] : 1.0;

			[UIView transitionWithView:_colorIndicator duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				_colorIndicator.backgroundColor = [self colorFromHex:hex withAlpha:alpha];
			} completion:nil];
		}
	}

		//StackOverFlow
		//https://stackoverflow.com/a/12397366
	-(UIColor *)colorFromHex:(NSString *)hex withAlpha:(CGFloat)alpha {
		unsigned rgbValue = 0;
		NSScanner *scanner = [NSScanner scannerWithString:hex];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
		[scanner scanHexInt:&rgbValue];

		return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0 blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0 alpha:alpha];
	}

@end
