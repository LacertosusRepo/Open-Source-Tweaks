#import "RHPHeaderView.h"
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

@implementation RHPHeaderView {
	UIImageView *_iconView;
	UILabel *_title;
	UILabel *_subtitle;
	UIStackView *_stackView;
}


	-(id)init {
		self = [super init];

		if(self) {
				//Add icon over labels (225x225)
			_iconView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/recentshueprefs.bundle/iconlarge.png"]];
			_iconView.alpha = 0;
			_iconView.center = CGPointMake(self.bounds.size.width/2, 0);

				//Main label
			_title = [[UILabel alloc] initWithFrame:CGRectZero];
			_title.alpha = 0;
			[_title setNumberOfLines:1];
			[_title setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightSemibold]];
			[_title setText:@"RecentsHue"];
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
				[blurView.centerXAnchor constraintEqualToAnchor:_stackView.centerXAnchor],
				[blurView.centerYAnchor constraintEqualToAnchor:_stackView.centerYAnchor],
				[blurView.widthAnchor constraintEqualToAnchor:_stackView.widthAnchor constant:50],
				[blurView.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor constant:20],

				[wallpaperView.centerXAnchor constraintEqualToAnchor:blurView.centerXAnchor],
				[wallpaperView.centerYAnchor constraintEqualToAnchor:blurView.centerYAnchor],
				[wallpaperView.widthAnchor constraintEqualToAnchor:blurView.widthAnchor],
				[wallpaperView.heightAnchor constraintEqualToAnchor:blurView.heightAnchor],
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
		return @[@"Color coded based on call type"];
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
