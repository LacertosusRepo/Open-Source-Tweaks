/*
 * FNPTimeIntervalPickerCell.m
 * FlashNotify
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 8/1/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "FNPTimeIntervalPickerCell.h"

@implementation FNPTimeIntervalPickerCell {
  UIAlertController *_alert;
  UIPickerView *_timePicker;
  NSInteger _hours;
  NSInteger _minutes;
  NSInteger _seconds;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      NSInteger totalSeconds = [[specifier performGetter] integerValue];
      _seconds = totalSeconds % 60;
      _minutes = (totalSeconds / 60) % 60;
      _hours = totalSeconds / 3600;

      self.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", _hours, _minutes, _seconds];
    }

    return self;
  }

  -(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected) {
      [self presentAlert];
    } else {
      [super setSelected:selected animated:animated];
    }
  }

    //Use tint color from Cephei
    //https://github.com/hbang/libcephei/blob/master/prefs/HBTintedTableCell.m
  -(void)tintColorDidChange {
    [super tintColorDidChange];

    self.textLabel.textColor = self.tintColor;
    self.textLabel.highlightedTextColor = self.tintColor;
  }

  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {
      self.textLabel.textColor = self.tintColor;
      self.textLabel.highlightedTextColor = self.tintColor;
	  }
  }

  -(void)presentAlert {
    _alert = [UIAlertController alertControllerWithTitle:@"Set Delay" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];

    _timePicker = [[UIPickerView alloc] init];
    _timePicker.dataSource = self;
    _timePicker.delegate = self;
    _timePicker.showsSelectionIndicator = YES;
    _timePicker.translatesAutoresizingMaskIntoConstraints = NO;

    [_timePicker selectRow:_hours inComponent:0 animated:YES];
    [_timePicker selectRow:_minutes inComponent:1 animated:YES];
    [_timePicker selectRow:_seconds inComponent:2 animated:YES];

    _alert.view.clipsToBounds = YES;
    [_alert.view addSubview:_timePicker];

    [NSLayoutConstraint activateConstraints:@[
      [_alert.view.widthAnchor constraintEqualToAnchor:_timePicker.widthAnchor],
      [_alert.view.heightAnchor constraintEqualToAnchor:_timePicker.heightAnchor constant:100],

      [_timePicker.centerXAnchor constraintEqualToAnchor:_alert.view.centerXAnchor],
      [_timePicker.centerYAnchor constraintEqualToAnchor:_alert.view.centerYAnchor constant:-25],
    ]];

    //Alderis
    //https://github.com/hbang/Alderis/blob/138dfd16028caf6bebb0e9c611ea44934696d878/lcpshim/HBColorPickerTableCell.m#L86-L87
    UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:_alert animated:YES completion:nil];
  }

  -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
      case 0:
      _hours = row;
      break;

      case 1:
      _minutes = row;
      break;

      case 2:
      _seconds = row;
      break;
    }

    if(_hours == 0 && _minutes == 0 && _seconds == 0) {
      [_timePicker selectRow:1 inComponent:2 animated:YES];
      [self pickerView:_timePicker didSelectRow:1 inComponent:2];
    }

    self.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", _hours, _minutes, _seconds];
    [self.specifier performSetterWithValue:[NSNumber numberWithInt:(_hours * 3600) + (_minutes * 60) + _seconds]];
  }

  -(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if(!view) {
      NSArray *componentStrings = @[@"hours", @"min", @"sec"];
      UILabel *columnLabel = [[UILabel alloc] init];
      columnLabel.text = [NSString stringWithFormat:@"%lu %@", row, componentStrings[component]];
      columnLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightRegular];
      columnLabel.textAlignment = NSTextAlignmentCenter;
      return columnLabel;
    }

    ((UILabel *)view).text = [NSString stringWithFormat:@"%lu", row];
    return view;
  }


  -(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
  }

  -(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 24 : 60;
  }

  -(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
  }
@end
