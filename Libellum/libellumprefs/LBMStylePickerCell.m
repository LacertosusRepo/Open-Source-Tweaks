  /*
   * Based off of Boo-dev's libstylepicker
   * https://github.com/boo-dev/libstylepicker
   */
#import "LBMStylePickerCell.h"

@implementation LBMStylePickerCell {
  UIStackView *_stackView;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];

    if(self) {
      NSMutableArray *optionViewArray = [[NSMutableArray alloc] init];
      NSBundle *bundle = [specifier.target bundle];
      NSArray *options = [specifier propertyForKey:@"options"];

      for(NSDictionary *stylesWithProperties in options) {
        LBMStyleOptionView *optionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[stylesWithProperties objectForKey:@"appearanceOption"]];
        optionView.delegate = self;
        optionView.label.text = [stylesWithProperties objectForKey:@"label"];
        optionView.previewImage = [UIImage imageNamed:[stylesWithProperties objectForKey:@"image"] inBundle:bundle compatibleWithTraitCollection:nil];
        optionView.translatesAutoresizingMaskIntoConstraints = NO;

        [optionViewArray addObject:optionView];
      }

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:optionViewArray];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisHorizontal;
      _stackView.distribution = UIStackViewDistributionFillEqually;
      _stackView.spacing = 0;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_stackView];

      for(LBMStyleOptionView *view in _stackView.arrangedSubviews) {
        view.enabled = [view.appearanceOption isEqual:[specifier performGetter]];
        view.highlighted = [view.appearanceOption isEqual:[specifier performGetter]];
      }

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
      ]];
    }

    return self;
  }

  -(void)selectedOption:(LBMStyleOptionView *)option {
    [self.specifier performSetterWithValue:option.appearanceOption];

    for(LBMStyleOptionView *view in _stackView.arrangedSubviews) {
      [view updateViewForStyle:option.appearanceOption];
    }
  }
@end
