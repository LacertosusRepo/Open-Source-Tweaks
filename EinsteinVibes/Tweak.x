/*
 * Tweak.x
 * EinsteinVibes
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 8/17/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

  UISelectionFeedbackGenerator *feedback;
  NSTimeInterval tapTimestamp;

%hook CalculatorKeypadButton
  -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    %orig;

    tapTimestamp = ((UITouch *)[touches anyObject]).timestamp;

    feedback = (feedback) ?: [[UISelectionFeedbackGenerator alloc] init];
    [feedback selectionChanged];
  }

  -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    %orig;

    if(((UITouch *)[touches anyObject]).timestamp - tapTimestamp > 0.2) {
      feedback = (feedback) ?: [[UISelectionFeedbackGenerator alloc] init];
      [feedback selectionChanged];
    }
  }
%end

%ctor {
  %init(CalculatorKeypadButton = NSClassFromString(@"Calculator.CalculatorKeypadButton"));
}
