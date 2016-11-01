//Thanks to CPDigitalDarkoom & his tweak "SafariWallSetter"
@implementation HaptikCenterCustomHeaderCell
@synthesize headerLabel,subHeaderLabel,subHeaderLabel2,randomLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
	
            self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.headerLabel setNumberOfLines:1];
            [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:36]];
            [self.headerLabel setText:@"HaptikCenter"];
            [self.headerLabel setBackgroundColor:[UIColor clearColor]];
            [self.headerLabel setTextColor:[UIColor colorWithRed:52/255.0f green:73/255.0f blue:95/255.0f alpha:1.0f]];
            [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.headerLabel];
            [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
            self.subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.subHeaderLabel setNumberOfLines:1];
            [self.subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
            [self.subHeaderLabel setText:@"Haptic Feedback For Your"];
            [self.subHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.subHeaderLabel setTextColor:[UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:0.7]];
            [self.subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.subHeaderLabel];
            [self.subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.subHeaderLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.subHeaderLabel2 setNumberOfLines:1];
            [self.subHeaderLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
            [self.subHeaderLabel2 setText:@"Control Center & Notification Center"];
            [self.subHeaderLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.subHeaderLabel2 setTextColor:[UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:0.7]];
            [self.subHeaderLabel2 setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.subHeaderLabel2];
            [self.subHeaderLabel2 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.subHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.randomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.randomLabel setNumberOfLines:1];
            [self.randomLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [self.randomLabel setText:self.randomTexts[arc4random_uniform(self.randomTexts.count)]];
            [self.randomLabel setBackgroundColor:[UIColor clearColor]];
            [self.randomLabel setTextColor:[UIColor grayColor]];
            [self.randomLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.randomLabel];
            [self.randomLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.randomLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.subHeaderLabel2 attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.randomLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}

-(NSArray *)randomTexts {
    return @[@"Thank You For Installing",@"Report Any Bugs",@"Open Source On Github",@"Contact Me With Any Suggetions",
            @"by LacertosusDeus",@"We Have So Much Room For Activities"];
}

@end