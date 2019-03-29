#import "PreferencesColorDefinitions.h"

//Thanks to CPDigitalDarkoom & his tweak "SafariWallSetter"
@implementation TIDCustomHeaderCell
@synthesize iconView, headerLabel, subHeaderLabel;

	-(id)init {
		self = [super initWithFrame:CGRectZero];

		if(self) {
			//Add icon over labels (150x150)
			self.iconView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/toneitdownprefs.bundle/iconlarge.png"]];
			self.iconView.center = CGPointMake(self.bounds.size.width/2, 0);
			[self addSubview:self.iconView];
			[self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.3 constant:0]];
      [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

			self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.headerLabel setNumberOfLines:1];
      [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
      [self.headerLabel setText:@"ToneItDown"];
      [self.headerLabel setBackgroundColor:[UIColor clearColor]];
      [self.headerLabel setTextColor:Title_Color];
      [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
      [self addSubview:self.headerLabel];
      [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
      [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

      self.subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.subHeaderLabel setNumberOfLines:1];
      [self.subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
      [self.subHeaderLabel setText:self.randomLabels[arc4random_uniform(self.randomLabels.count)]];
      [self.subHeaderLabel setBackgroundColor:[UIColor clearColor]];
      [self.subHeaderLabel setTextColor:Sub_Color];
      [self.subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
      [self addSubview:self.subHeaderLabel];
      [self.subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
      [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }
		return self;
	}

	-(NSArray *)randomLabels {
		return @[@"Why are you so damn loud tones? Why?", @"It's good to shutup sometimes.", @"Take it down a notch... or five."];
	}

	-(void)didMoveToSuperview {
		[super didMoveToSuperview];
		self.iconView.alpha = 0;
		self.headerLabel.alpha = 0;
		self.subHeaderLabel.alpha = 0;
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
			self.headerLabel.alpha = 1;
		} completion:nil];
	}

	-(void)fadeInSubLabel {
		[UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.subHeaderLabel.alpha = 1;
		} completion:nil];
	}
@end
