/*
 * STLTimePickerCell.h
 * Stellae
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/11/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

	//Left here on purpose, example of custom cell with date picker

#import "Preferences/PSTableCell.h"

@interface STLTimePickerCell : PSTableCell {
	UIDatePicker *timePicker;
}
@end


@implementation STLTimePickerCell
	NSString *preferencesFile = @"/User/Library/Preferences/com.lacertosusrepo.stellaesaveddata.plist";

	-(void)layoutSubviews {
			timePicker = [[UIDatePicker alloc] init];
			timePicker.datePickerMode = UIDatePickerModeTime;
			timePicker.backgroundColor = [UIColor whiteColor];
			timePicker.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
      timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			timePicker.translatesAutoresizingMaskIntoConstraints = YES;

			NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:preferencesFile];
			NSDate *fireTime = [preferences objectForKey:@"fireTime"];
			if(fireTime == nil) {
				NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
				NSDate *defaultTime = [[NSCalendar currentCalendar] dateFromComponents:components];
				timePicker.date = defaultTime;
			} else {
				timePicker.date = fireTime;
			}

      [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
      [self addSubview:timePicker];
	}

  -(void)timeChanged:(UIDatePicker *)sender {
		NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:preferencesFile];
		NSDate *timePickerDate = sender.date;
		NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:timePickerDate];
		NSDate *dateToSave = [[NSCalendar currentCalendar] dateFromComponents:components];

		[preferences setObject:dateToSave forKey:@"fireTime"];
		[preferences writeToFile:preferencesFile atomically:YES];
  }
@end
