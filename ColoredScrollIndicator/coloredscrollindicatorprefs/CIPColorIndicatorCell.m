#import "CIPColorIndicatorCell.h"

@implementation CIPColorIndicatorCell {
	UIView *_indicatorView;
	CAShapeLayer *_indicatorShape;
}

	-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
		self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

		if(self) {
			_indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
			_indicatorView.clipsToBounds = YES;
			_indicatorView.layer.borderColor = ([UIColor respondsToSelector:@selector(labelColor)]) ? [UIColor opaqueSeparatorColor].CGColor : [UIColor systemGrayColor].CGColor;
			_indicatorView.layer.borderWidth = 3;
			_indicatorView.layer.cornerRadius = 14.5;
			_indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
			[self.contentView addSubview:_indicatorView];

			_indicatorShape = [CAShapeLayer layer];
			_indicatorShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 29, 29) cornerRadius:14.5].CGPath;
			[_indicatorView.layer addSublayer:_indicatorShape];

			[NSLayoutConstraint activateConstraints:@[
				[_indicatorView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
				[_indicatorView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
				[_indicatorView.heightAnchor constraintEqualToConstant:29],
				[_indicatorView.widthAnchor constraintEqualToConstant:29],
			]];
		}

		if([[specifier propertyForKey:@"defaults"] length] > 0) {
			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:[specifier propertyForKey:@"defaults"]];
			NSArray *colorComponents = [[preferences objectForKey:[specifier propertyForKey:@"key"]] componentsSeparatedByString:@":"];
			NSString *hex = ([colorComponents count] > 0) ? [colorComponents firstObject] : @"#FFFFFF";
			CGFloat alpha = ([colorComponents count] > 1) ? [[colorComponents lastObject] floatValue] : 1.0;

			[UIView transitionWithView:_indicatorView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				_indicatorShape.fillColor = [self colorFromHex:hex withAlpha:alpha].CGColor;
			} completion:nil];

			[preferences registerPreferenceChangeBlock:^{
	    	[self setCellEnabled:YES];
	  	}];
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

			[UIView transitionWithView:_indicatorView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				_indicatorShape.fillColor = [self colorFromHex:hex withAlpha:alpha].CGColor;
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
