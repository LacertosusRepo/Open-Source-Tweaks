#import "LBMHeaderCell.h"
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

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
      [self.titleLabel setTextAlignment:NSTextAlignmentCenter];

			UILabel *tweakSubtitle = [[UILabel alloc] initWithFrame:CGRectZero];
      self.subtitleLabel = tweakSubtitle;
			self.subtitleLabel.alpha = 0;
      [self.subtitleLabel setNumberOfLines:1];
      [self.subtitleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
      [self.subtitleLabel setText:self.randomLabels[arc4random_uniform(self.randomLabels.count)]];
      [self.subtitleLabel setBackgroundColor:[UIColor clearColor]];
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

			if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
				NSData *wallpaperData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
				CFArrayRef wallpaperArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)wallpaperData, NULL, 1, NULL);
				NSArray *wallpaperArray = (__bridge NSArray *)wallpaperArrayRef;
				UIImage *wallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(wallpaperArray[0])];
				CFRelease(wallpaperArrayRef);

				UIImageView *wallpaperView = [[UIImageView alloc] initWithImage:wallpaper];
				wallpaperView.clipsToBounds = YES;
				wallpaperView.contentMode = UIViewContentModeScaleAspectFill;
				wallpaperView.layer.cornerRadius = 10;
				wallpaperView.translatesAutoresizingMaskIntoConstraints = NO;
				[wallpaperView setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisHorizontal];
				[wallpaperView setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisVertical];
				[self addSubview:wallpaperView];

				MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:@"plattersDark" inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
				materialView.layer.cornerRadius = 10;
				materialView.recipe = 1;
      	materialView.recipeDynamic = YES;
				materialView.translatesAutoresizingMaskIntoConstraints = NO;
				[self addSubview:materialView];

				[self sendSubviewToBack:materialView];
				[self sendSubviewToBack:wallpaperView];

				[NSLayoutConstraint activateConstraints:@[
					[materialView.centerXAnchor constraintEqualToAnchor:headerStackView.centerXAnchor],
					[materialView.centerYAnchor constraintEqualToAnchor:headerStackView.centerYAnchor],
					[materialView.widthAnchor constraintEqualToAnchor:headerStackView.widthAnchor constant:50],
					[materialView.heightAnchor constraintEqualToAnchor:headerStackView.heightAnchor constant:20],

					[wallpaperView.centerXAnchor constraintEqualToAnchor:materialView.centerXAnchor],
					[wallpaperView.centerYAnchor constraintEqualToAnchor:materialView.centerYAnchor],
					[wallpaperView.widthAnchor constraintEqualToAnchor:materialView.widthAnchor],
					[wallpaperView.heightAnchor constraintEqualToAnchor:materialView.heightAnchor],
				]];
			}
		}

		return self;
	}

	-(NSArray *)randomLabels {
		return @[@"Open source on github!", @"Customizable notepad on your lockscreen", @"Customizable notepad in your notification center", @"Save the trees"];
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
