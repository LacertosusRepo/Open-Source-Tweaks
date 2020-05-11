#import "LBMLabeledSliderCell.h"

@implementation LBMLabeledSliderCell {
	UILabel *_sliderLabel;
}

	-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
		self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

		if(self) {
			_sliderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_sliderLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
			_sliderLabel.text = [specifier propertyForKey:@"label"];
			_sliderLabel.textColor = ([UIColor respondsToSelector:@selector(labelColor)]) ? [UIColor secondaryLabelColor] : [UIColor systemGrayColor];
			_sliderLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[_sliderLabel sizeToFit];
			[self.contentView addSubview:_sliderLabel];

			[NSLayoutConstraint activateConstraints:@[
				[_sliderLabel.bottomAnchor constraintEqualToAnchor:self.control.topAnchor],
				[_sliderLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
			]];

			[self.control setFrame:CGRectOffset(self.control.frame, 0, _sliderLabel.frame.size.height)];
		}

		return self;
	}

	-(void)layoutSubviews {
		[super layoutSubviews];

		[self.control setFrame:CGRectOffset(self.control.frame, 0, ((((self.control.frame.size.height + _sliderLabel.frame.size.height) / 2) - (self.contentView.frame.size.height / 2)) + self.control.frame.origin.y))];
	}

@end
