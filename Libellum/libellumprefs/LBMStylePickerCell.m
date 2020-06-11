  /*
   * Based off of Boo-dev's libstylepicker
   * https://github.com/boo-dev/libstylepicker
   */
#import "LBMStylePickerCell.h"

@implementation LBMStylePickerCell {
  UIStackView *_stackView;
  LBMStyleOptionView *_firstOptionView;
  LBMStyleOptionView *_secondOptionView;
  LBMStyleOptionView *_thirdOptionView;
  LBMStyleOptionView *_fourthOptionView;
}

  -(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _firstOptionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[[specifier propertyForKey:@"firstOption"] objectForKey:@"style"]];
      _firstOptionView.delegate = self;
      _firstOptionView.label.text = [[specifier propertyForKey:@"firstOption"] objectForKey:@"label"];
      _firstOptionView.previewImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/firstImage.png"];
      _firstOptionView.translatesAutoresizingMaskIntoConstraints = NO;

      _secondOptionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[[specifier propertyForKey:@"secondOption"] objectForKey:@"style"]];
      _secondOptionView.delegate = self;
      _secondOptionView.label.text = [[specifier propertyForKey:@"secondOption"] objectForKey:@"label"];
      _secondOptionView.previewImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/secondImage.png"];
      _secondOptionView.translatesAutoresizingMaskIntoConstraints = NO;

      _thirdOptionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[[specifier propertyForKey:@"thirdOption"] objectForKey:@"style"]];
      _thirdOptionView.delegate = self;
      _thirdOptionView.label.text = [[specifier propertyForKey:@"thirdOption"] objectForKey:@"label"];
      _thirdOptionView.previewImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/thirdImage.png"];
      _thirdOptionView.translatesAutoresizingMaskIntoConstraints = NO;

      _fourthOptionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[[specifier propertyForKey:@"fourthOption"] objectForKey:@"style"]];
      _fourthOptionView.delegate = self;
      _fourthOptionView.label.text = [[specifier propertyForKey:@"fourthOption"] objectForKey:@"label"];
      _fourthOptionView.previewImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/fourthImage.png"];
      _fourthOptionView.translatesAutoresizingMaskIntoConstraints = NO;

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_firstOptionView, _secondOptionView, _thirdOptionView, _fourthOptionView]];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisHorizontal;
      _stackView.distribution = UIStackViewDistributionFillEqually;
      _stackView.spacing = 5;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_stackView];

      for(LBMStyleOptionView *view in _stackView.arrangedSubviews) {
        view.enabled = [view.appearanceOption isEqualToString:[specifier performGetter]];
      }

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      ]];
    }

    return self;
  }

  -(void)selectedOption:(LBMStyleOptionView *)option {
    [self.specifier performSetterWithValue:option.appearanceOption];

    [_firstOptionView updateViewForStyle:option.appearanceOption];
    [_secondOptionView updateViewForStyle:option.appearanceOption];
    [_thirdOptionView updateViewForStyle:option.appearanceOption];
    [_fourthOptionView updateViewForStyle:option.appearanceOption];
  }
@end
