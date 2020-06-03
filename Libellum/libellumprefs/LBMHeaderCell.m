#import "LBMHeaderCell.h"
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

@implementation LBMHeaderCell
	-(id)init {
		self = [super initWithFrame:CGRectZero];

		if(self) {
				//Add icon above labels (150x150)
			UIImageView *tweakIcon = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/iconlarge.png"]];
			self.iconView = tweakIcon;
			self.iconView.alpha = 0;
			self.iconView.center = CGPointMake(self.bounds.size.width/2, 0);

				//Main label
			UILabel *tweakTitle = [[UILabel alloc] initWithFrame:CGRectZero];
			self.titleLabel = tweakTitle;
			self.titleLabel.alpha = 0;
			[self.titleLabel setNumberOfLines:1];
			[self.titleLabel setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightSemibold]];
			[self.titleLabel setText:@"Libellum"];
			[self.titleLabel setBackgroundColor:[UIColor clearColor]];
			[self.titleLabel setTextAlignment:NSTextAlignmentCenter];

				//Subtitle label
			UILabel *tweakSubtitle = [[UILabel alloc] initWithFrame:CGRectZero];
			self.subtitleLabel = tweakSubtitle;
			self.subtitleLabel.alpha = 0;
			[self.subtitleLabel setNumberOfLines:1];
			[self.subtitleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
			[self.subtitleLabel setText:self.randomLabels[arc4random_uniform(self.randomLabels.count)]];
			[self.subtitleLabel setBackgroundColor:[UIColor clearColor]];
			[self.subtitleLabel setTextAlignment:NSTextAlignmentCenter];

				//Create stack view
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

				//Add constraints to labels/icon
			[NSLayoutConstraint activateConstraints:@[
				[self.iconView.heightAnchor constraintEqualToConstant:75],
				[self.iconView.widthAnchor constraintEqualToConstant:75],
				[self.titleLabel.heightAnchor constraintEqualToConstant:47],
				[self.subtitleLabel.heightAnchor constraintEqualToConstant:15],
				[headerStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
				[headerStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
			]];

				//Get user wallpaper
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

				//Create blur
			UIView *blurView;
			if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
				MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:@"plattersDark" inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
				materialView.recipe = 1;
				materialView.recipeDynamic = YES;
				blurView = materialView;
			} else {
				blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
			}
			blurView.clipsToBounds = YES;
			blurView.layer.cornerRadius = 10;
			blurView.translatesAutoresizingMaskIntoConstraints = NO;

			[self addSubview:blurView];
			[self sendSubviewToBack:blurView];
			[self sendSubviewToBack:wallpaperView];

				//Add more constraints
			[NSLayoutConstraint activateConstraints:@[
				[blurView.centerXAnchor constraintEqualToAnchor:headerStackView.centerXAnchor],
				[blurView.centerYAnchor constraintEqualToAnchor:headerStackView.centerYAnchor],
				[blurView.widthAnchor constraintEqualToAnchor:headerStackView.widthAnchor constant:50],
				[blurView.heightAnchor constraintEqualToAnchor:headerStackView.heightAnchor constant:20],

				[wallpaperView.centerXAnchor constraintEqualToAnchor:blurView.centerXAnchor],
				[wallpaperView.centerYAnchor constraintEqualToAnchor:blurView.centerYAnchor],
				[wallpaperView.widthAnchor constraintEqualToAnchor:blurView.widthAnchor],
				[wallpaperView.heightAnchor constraintEqualToAnchor:blurView.heightAnchor],
			]];

				//Add parallax effect
			[self addInterpolatingMotion];
		}

		return self;
	}

	-(void)addInterpolatingMotion {
		UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontal.minimumRelativeValue = @-10;
		horizontal.maximumRelativeValue = @10;

		UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		vertical.minimumRelativeValue = @-10;
		vertical.maximumRelativeValue = @10;

		UIMotionEffectGroup *effectsGroup = [[UIMotionEffectGroup alloc] init];
		effectsGroup.motionEffects = @[horizontal, vertical];

		[self addMotionEffect:effectsGroup];
	}

	-(NSArray *)randomLabels {
		return @[@"Check out the source code on github!", @"Customizable notepad on your lockscreen", @"Customizable notepad in your notification center", @"Why did the bike fall over? It was too tired."];
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
