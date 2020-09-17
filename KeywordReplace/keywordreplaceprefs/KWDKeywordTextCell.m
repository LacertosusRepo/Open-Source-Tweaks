/*
 * KWDKeywordTextCell.m
 * KeywordReplace
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 9/15/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "KWDKeywordTextCell.h"

@implementation KWDKeywordTextCell {
  UIStackView *_stackView;
  UITextField *_keywordField;
  UIView *_divider;
  UITextField *_replacementField;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _keywordField = [[UITextField alloc] initWithFrame:CGRectZero];
      _keywordField.adjustsFontSizeToFitWidth = YES;
      _keywordField.delegate = self;
      _keywordField.placeholder = @"Keyword";
      _keywordField.tag = 69;
      _keywordField.text = ([[specifier propertyForKey:@"keyword"] isEqualToString:@""]) ? nil : [specifier propertyForKey:@"keyword"];
      _keywordField.textAlignment = NSTextAlignmentCenter;
      _keywordField.translatesAutoresizingMaskIntoConstraints = NO;

      _divider = [[UIView alloc] init];
      _divider.backgroundColor = [UIColor opaqueSeparatorColor];
      _divider.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_divider];

      _replacementField = [[UITextField alloc] initWithFrame:CGRectZero];
      _replacementField.adjustsFontSizeToFitWidth = YES;
      _replacementField.delegate = self;
      _replacementField.placeholder = @"Replacement";
      _replacementField.tag = 420;
      _replacementField.text = ([[specifier propertyForKey:@"replacement"] isEqualToString:@""]) ? nil : [specifier propertyForKey:@"replacement"];
      _replacementField.textAlignment = NSTextAlignmentCenter;
      _replacementField.translatesAutoresizingMaskIntoConstraints = NO;

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_keywordField, _replacementField]];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisHorizontal;
      _stackView.distribution = UIStackViewDistributionFillEqually;
      _stackView.spacing = 7;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_stackView];

      [NSLayoutConstraint activateConstraints:@[
        [_divider.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:.6],
        [_divider.widthAnchor constraintEqualToConstant:1],
        [_divider.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_divider.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      ]];
    }

    return self;
  }

  -(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.returnKeyType = UIReturnKeyDone;
  }

  -(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.tag == 69) {
      [self.specifier setProperty:textField.text forKey:@"keyword"];
    }

    if(textField.tag == 420) {
      [self.specifier setProperty:textField.text forKey:@"replacement"];
    }
  }

  -(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return NO;
  }
@end
