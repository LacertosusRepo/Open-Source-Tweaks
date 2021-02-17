#import "PTCHeaderView.h"

@implementation PTCHeaderView {
	UILabel *_title;
	UILabel *_subtitle;
	UIStackView *_stackView;
}

	-(instancetype)initWithBundle:(NSBundle *)bundle {
		self = [super init];

		if(self) {
				//Main label
			_title = [[UILabel alloc] initWithFrame:CGRectZero];
			_title.alpha = 0;
			[_title setNumberOfLines:1];
			[_title setFont:[UIFont systemFontOfSize:30 weight:UIFontWeightSemibold]];
			[_title setText:@"PhoneTabsCustomizer"];
			[_title setBackgroundColor:[UIColor clearColor]];
			[_title setTextAlignment:NSTextAlignmentCenter];

				//Subtitle label
			_subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
			_subtitle.alpha = 0;
			[_subtitle setNumberOfLines:1];
			[_subtitle setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightLight]];
			[_subtitle setText:self.randomLabels[arc4random_uniform(self.randomLabels.count)]];
			[_subtitle setBackgroundColor:[UIColor clearColor]];
			[_subtitle setTextAlignment:NSTextAlignmentCenter];

				//Create stack view
			_stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_title, _subtitle]];
			_stackView.axis = UILayoutConstraintAxisVertical;
			_stackView.distribution = UIStackViewDistributionEqualSpacing;
			_stackView.alignment = UIStackViewAlignmentCenter;
			_stackView.translatesAutoresizingMaskIntoConstraints = NO;
			_stackView.spacing = 0;
			[self addSubview:_stackView];

				//Add constraints to labels/icon
			[NSLayoutConstraint activateConstraints:@[
				[_title.heightAnchor constraintEqualToConstant:47],
				[_subtitle.heightAnchor constraintEqualToConstant:15],
				[_stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
				[_stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
			]];

			[self addInterpolatingMotion];
		}

		return self;
	}

	-(void)addInterpolatingMotion {
		UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontal.minimumRelativeValue = @-5;
		horizontal.maximumRelativeValue = @5;

		UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		vertical.minimumRelativeValue = @-5;
		vertical.maximumRelativeValue = @5;

		UIMotionEffectGroup *effectsGroup = [[UIMotionEffectGroup alloc] init];
		effectsGroup.motionEffects = @[horizontal, vertical];

		[self addMotionEffect:effectsGroup];
	}

	-(NSArray *)randomLabels {
		return @[@"Show the tabs you actually use", @"This should definitely be free", @"Open source on GitHub!"];
	}

	-(void)didMoveToSuperview {
		[super didMoveToSuperview];

		[UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_title.alpha = 1;
		} completion:nil];

		[UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_subtitle.alpha = 1;
		} completion:nil];
	}
@end
