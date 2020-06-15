  /*
   * Based off of Boo-dev's libstylepicker
   * https://github.com/boo-dev/libstylepicker
   */
#import "LBMStylePickerCell.h"

@implementation LBMStylePickerCell {
  UIStackView *_stackView;
}

  -(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];

    if(self) {
      NSMutableArray *optionViewArray = [[NSMutableArray alloc] init];
      NSBundle *bundle = [specifier.target bundle];
      NSDictionary *options = [specifier propertyForKey:@"options"];

      for(NSString *key in options) {
        NSDictionary *optionProperties = [options objectForKey:key];

        LBMStyleOptionView *optionView = [[LBMStyleOptionView alloc] initWithFrame:CGRectZero appearanceOption:[optionProperties objectForKey:@"appearanceOption"]];
        optionView.delegate = self;
        optionView.label.text = [optionProperties objectForKey:@"label"];
        optionView.previewImage = [UIImage imageNamed:[optionProperties objectForKey:@"image"] inBundle:bundle compatibleWithTraitCollection:nil];
        optionView.tag = [[optionProperties objectForKey:@"position"] integerValue];
        optionView.translatesAutoresizingMaskIntoConstraints = NO;

        [optionViewArray addObject:optionView];
      }

      NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
      _stackView = [[UIStackView alloc] initWithArrangedSubviews:[optionViewArray sortedArrayUsingDescriptors:@[ascendingSort]]];
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

    for(LBMStyleOptionView *view in _stackView.arrangedSubviews) {
      [view updateViewForStyle:option.appearanceOption];
    }
  }
@end
