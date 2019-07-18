#import "LBMHeaderCell.h"

@implementation LBMHeaderCell

	-(id)init {
		self = [super initWithFrame:CGRectZero];

		if(self) {
			//Add icon over labels (150x150)
			UIImageView *tweakIcon = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/iconlarge.png"]];
			self.iconView = tweakIcon;
			self.iconView.alpha = 0;
			self.iconView.center = CGPointMake(self.bounds.size.width/2, 0);

			UILabel *tweakTitle = [[UILabel alloc] initWithFrame:CGRectZero];
			self.titleLabel = tweakTitle;
			self.titleLabel.alpha = 0;
      [self.titleLabel setNumberOfLines:1];
      [self.titleLabel setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightSemibold]];
      [self.titleLabel setText:@"Libellum"];
      [self.titleLabel setBackgroundColor:[UIColor clearColor]];
      [self.titleLabel setTextColor:Pri_Color];
      [self.titleLabel setTextAlignment:NSTextAlignmentCenter];

			UILabel *tweakSubtitle = [[UILabel alloc] initWithFrame:CGRectZero];
      self.subtitleLabel = tweakSubtitle;
			self.subtitleLabel.alpha = 0;
      [self.subtitleLabel setNumberOfLines:1];
      [self.subtitleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
      [self.subtitleLabel setText:self.randomLabels[arc4random_uniform(self.randomLabels.count)]];
      [self.subtitleLabel setBackgroundColor:[UIColor clearColor]];
      [self.subtitleLabel setTextColor:Sec_Color];
      [self.subtitleLabel setTextAlignment:NSTextAlignmentCenter];

			[NSLayoutConstraint activateConstraints:@[
				[self.iconView.heightAnchor constraintEqualToConstant:75],
				[self.iconView.widthAnchor constraintEqualToConstant:75],
				[self.titleLabel.heightAnchor constraintEqualToConstant:47],
				[self.subtitleLabel.heightAnchor constraintEqualToConstant:15],
			]];

			UIStackView *headerStackView = [[UIStackView alloc] init];
			headerStackView.axis = UILayoutConstraintAxisVertical;
			headerStackView.distribution = UIStackViewDistributionEqualSpacing;
  		headerStackView.alignment = UIStackViewAlignmentCenter;
			headerStackView.translatesAutoresizingMaskIntoConstraints = NO;
			headerStackView.spacing = 0;

			[headerStackView addArrangedSubview:self.iconView];
			[headerStackView addArrangedSubview:self.titleLabel];
			[headerStackView addArrangedSubview:self.subtitleLabel];

			[self addSubview:headerStackView];

			[NSLayoutConstraint activateConstraints:@[
				[headerStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
				[headerStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
			]];
		}

		return self;
	}

	-(NSArray *)randomLabels {
		return @[@"Quick notes on your Lockscreen", @"Open source on github!", @"Let's see dem aliens", @"What's in your wallet?"];
	}

	-(void)didMoveToSuperview {
		[super didMoveToSuperview];
		[self fadeInIconImage];
		[self fadeInHeaderLabel];
		[self fadeInSubLabel];
	}

	-(void)fadeInIconImage {
		[UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.iconView.alpha = 1;
		} completion:nil];
	}

	-(void)fadeInHeaderLabel {
		[UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.titleLabel.alpha = 1;
		} completion:nil];
	}

	-(void)fadeInSubLabel {
		[UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.subtitleLabel.alpha = 1;
		} completion:nil];
	}
@end
