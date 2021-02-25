#import "LBMLabeledSliderCell.h"

@implementation LBMLabeledSliderCell {
	UIStackView *_stackView;
	UIStackView *_sliderStackView;
	UILabel *_sliderLabel;
	UILabel *_valueLabel;
	}

	-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
		self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

		if(self) {
			[specifier setProperty:@56 forKey:@"height"];

			_sliderLabel = [[UILabel alloc] init];
			_sliderLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
			_sliderLabel.text = [specifier propertyForKey:@"label"];
			_sliderLabel.translatesAutoresizingMaskIntoConstraints = NO;

			_valueLabel = [[UILabel alloc] init];
			_valueLabel.font = [UIFont monospacedDigitSystemFontOfSize:10 weight:UIFontWeightBold];
			_valueLabel.text = [NSString stringWithFormat:@"%.01f", [[specifier performGetter] floatValue]];
			_valueLabel.userInteractionEnabled = YES;
			_valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[_valueLabel sizeToFit];

			_sliderStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.control, _valueLabel]];
			_sliderStackView.alignment = UIStackViewAlignmentCenter;
			_sliderStackView.axis = UILayoutConstraintAxisHorizontal;
			_sliderStackView.distribution = UIStackViewDistributionFill;
			_sliderStackView.spacing = 5;
			_sliderStackView.translatesAutoresizingMaskIntoConstraints = NO;

			_stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_sliderLabel, _sliderStackView]];
			_stackView.alignment = UIStackViewAlignmentCenter;
			_stackView.axis = UILayoutConstraintAxisVertical;
			_stackView.distribution = UIStackViewDistributionEqualCentering;
			_stackView.spacing = 0;
			_stackView.translatesAutoresizingMaskIntoConstraints = NO;
			[self.contentView addSubview:_stackView];

			[NSLayoutConstraint activateConstraints:@[
				[_stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
				[_stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15],
				[_stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15],
				[_stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],

				[_sliderStackView.widthAnchor constraintEqualToAnchor:_stackView.widthAnchor],

				[_valueLabel.heightAnchor constraintEqualToAnchor:_sliderStackView.heightAnchor],
			]];

			[self.control addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchDragInside];
			[self.control addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchDragOutside];
			[self.control addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

			UITapGestureRecognizer *enterCustomValueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCustomSliderValue)];
			enterCustomValueTap.numberOfTapsRequired = 1;
			[_valueLabel addGestureRecognizer:enterCustomValueTap];
		}

		return self;
	}

	-(void)setCustomSliderValue {
		UISlider *slider = (UISlider *)self.control;
		NSString *currentValue = [NSString stringWithFormat:@"%.02f", slider.value];

		UIAlertController *enterValueAlert = [UIAlertController alertControllerWithTitle:@"Enter Value" message:nil preferredStyle:UIAlertControllerStyleAlert];
		[enterValueAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.keyboardType = UIKeyboardTypeDecimalPad;
			textField.text = currentValue;
			textField.textColor = self.tintColor;
		}];

		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			UITextField *textField = enterValueAlert.textFields[0];

			CGFloat newValue = [textField.text floatValue];
			if(newValue > slider.maximumValue) {
				newValue = slider.maximumValue;
			} else if (newValue < slider.minimumValue) {
				newValue = slider.minimumValue;
			}

			[self.specifier performSetterWithValue:[NSNumber numberWithFloat:newValue]];
			[slider setValue:newValue animated:YES];
			[self sliderValueChanged:slider];
		}];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

		[enterValueAlert addAction:confirmAction];
		[enterValueAlert addAction:cancelAction];

		UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
		[rootViewController presentViewController:enterValueAlert animated:YES completion:nil];
	}

	-(void)sliderValueChanged:(UISlider *)slider {
		_valueLabel.text = [NSString stringWithFormat:@"%.01f", slider.value];
	}

	-(void)tintColorDidChange {
		[super tintColorDidChange];

		_sliderLabel.textColor = self.tintColor;
		_valueLabel.textColor = self.tintColor;
	}

	-(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
		[super refreshCellContentsWithSpecifier:specifier];

		if([self respondsToSelector:@selector(tintColor)]) {
			_sliderLabel.textColor = self.tintColor;
			_valueLabel.textColor = self.tintColor;
		}
	}
@end
