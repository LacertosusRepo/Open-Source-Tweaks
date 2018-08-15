@interface CalculatorKeypadView
@property (nonatomic, assign, readwrite) BOOL isHighlighted;
@end

%hook CalculatorKeypadView
  -(void)layoutSubviews {
    %orig;
    CalculatorKeypadView *swiftclass = self;
    if(swiftclass.isHighlighted == YES) {
      UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:0];
      [generator prepare];
      [generator impactOccurred];
    }
  }
%end

%ctor {
  %init(_ungrouped, CalculatorKeypadView = NSClassFromString(@"Calculator.CalculatorKeypadButton"));
}
