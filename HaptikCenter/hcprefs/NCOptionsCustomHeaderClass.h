@implementation NCOptionsCustomHeaderCell
@synthesize ncHeaderLabel,ncHeaderLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
       
            self.ncHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.ncHeaderLabel setNumberOfLines:1];
            [self.ncHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
            [self.ncHeaderLabel setText:@"Haptic Feedback For Your Control Center"];
            [self.ncHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.ncHeaderLabel setTextColor:[UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:0.7]];
            [self.ncHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.ncHeaderLabel];
            [self.ncHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ncHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.ncSubHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.ncSubHeaderLabel setNumberOfLines:1];
            [self.ncSubHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [self.ncSubHeaderLabel setText:@"Customize Haptic Feedback In The Notification Center"];
            [self.ncSubHeaderLabel setBackgroundColor:[UIColor grayColor]];
            [self.ncSubHeaderLabel setTextColor:[UIColor clearColor]];
            [self.ncSubHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.ncSubHeaderLabel];
            [self.ncSubHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncSubHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ncHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ncSubHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}
@end