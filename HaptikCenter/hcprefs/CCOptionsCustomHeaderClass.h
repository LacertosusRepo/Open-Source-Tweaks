@implementation CCOptionsCustomHeaderCell
@synthesize ccHeaderLabel,ccHeaderLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
       
            self.ccHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.ccHeaderLabel setNumberOfLines:1];
            [self.ccHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
            [self.ccHeaderLabel setText:@"Customize Haptic Feedback In The Control Center"];
            [self.ccHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.ccHeaderLabel setTextColor:[UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:0.7]];
            [self.ccHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.ccHeaderLabel];
            [self.ccHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ccHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ccHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ccHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.ncSubHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.ccSubHeaderLabel setNumberOfLines:1];
            [self.ccSubHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [self.ccSubHeaderLabel setText:@"Customize Haptic Feedback In The Control Center"];
            [self.ccSubHeaderLabel setBackgroundColor:[UIColor grayColor]];
            [self.ccSubHeaderLabel setTextColor:[UIColor clearColor]];
            [self.ccSubHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.ccSubHeaderLabel];
            [self.ccSubHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncSubHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ccHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncSubHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}
@end