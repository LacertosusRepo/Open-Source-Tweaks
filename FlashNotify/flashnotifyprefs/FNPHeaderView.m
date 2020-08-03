#import "FNPHeaderView.h"

@implementation FNPHeaderView {
	UIImageView *_iconView;
	UILabel *_title;
	UILabel *_subtitle;
	UIStackView *_stackView;
}


	-(id)init {
		self = [super init];

		if(self) {
				//Add icon over labels (225x225)
			_iconView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/flashnotifyprefs.bundle/iconlarge.png"]];
			_iconView.alpha = 0;
			_iconView.center = CGPointMake(self.bounds.size.width/2, 0);

				//Main label
			_title = [[UILabel alloc] initWithFrame:CGRectZero];
			_title.alpha = 0;
			[_title setNumberOfLines:1];
			[_title setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightSemibold]];
			[_title setText:@"FlashNotify"];
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
			_stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_iconView, _title, _subtitle]];
			_stackView.axis = UILayoutConstraintAxisVertical;
			_stackView.distribution = UIStackViewDistributionEqualSpacing;
			_stackView.alignment = UIStackViewAlignmentCenter;
			_stackView.translatesAutoresizingMaskIntoConstraints = NO;
			_stackView.spacing = 0;
			[self addSubview:_stackView];

				//Add constraints to labels/icon
			[NSLayoutConstraint activateConstraints:@[
				[_iconView.heightAnchor constraintEqualToConstant:75],
				[_iconView.widthAnchor constraintEqualToConstant:75],
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
		return @[@"Turn that pesky light off", @"What do you call a candle in armor? A knight light", @"Created with a miniscule amount of ♡"];
	}

	-(void)didMoveToSuperview {
		[super didMoveToSuperview];
		[self fadeInIconImage];
		[self fadeInHeaderLabel];
		[self fadeInSubLabel];
	}

	-(void)fadeInIconImage {
		[UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_iconView.alpha = 1;
		} completion:nil];
	}

	-(void)fadeInHeaderLabel {
		[UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_title.alpha = 1;
		} completion:nil];
	}

	-(void)fadeInSubLabel {
		[UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_subtitle.alpha = 1;
		} completion:nil];
	}
@end
