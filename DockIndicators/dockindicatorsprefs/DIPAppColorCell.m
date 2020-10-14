#import "DIPAppColorCell.h"

@implementation DIPAppColorCell {
  NSString *_hexColor;
  NSString *_bundleID;
  id<DIPAppColorCellDelegate> _delegate;

  UIStackView *_stackView;
  UIImageView *_iconView;
  UILabel *_hexLabel;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _hexColor = [specifier propertyForKey:@"hexColor"];
      _bundleID = [specifier propertyForKey:@"bundleID"];
      _delegate = [specifier propertyForKey:@"delegate"];

      self.contentView.backgroundColor = [UIColor PF_colorWithHex:_hexColor];

      UIImage *appIcon = [UIImage _applicationIconImageForBundleIdentifier:_bundleID format:0 scale:[UIScreen mainScreen].scale];
      _iconView = [[UIImageView alloc] initWithImage:appIcon];

      _hexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_hexLabel.font = [UIFont monospacedDigitSystemFontOfSize:17 weight:UIFontWeightBold];
			_hexLabel.text = [NSString stringWithFormat:@"%@", _hexColor];
      _hexLabel.textColor = [self appropriateColorForLabel:self.contentView.backgroundColor];
			_hexLabel.translatesAutoresizingMaskIntoConstraints = NO;

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_iconView, _hexLabel]];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisHorizontal;
      _stackView.distribution = UIStackViewDistributionEqualSpacing;
      _stackView.spacing = 0;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_stackView];

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],

        [_iconView.heightAnchor constraintEqualToConstant:30],
        [_iconView.widthAnchor constraintEqualToConstant:30],
      ]];
    }

    return self;
  }

  -(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected) {
      [self presentColorPicker];
    } else {
      [super setSelected:selected animated:animated];
    }
  }

  -(void)presentColorPicker {
    HBColorPickerConfiguration *configuration = [[HBColorPickerConfiguration alloc] initWithColor:[UIColor PF_colorWithHex:_hexColor]];
    configuration.supportsAlpha = NO;

    HBColorPickerViewController *colorPicker = [[HBColorPickerViewController alloc] init];
    colorPicker.delegate = self;
    colorPicker.configuration = configuration;

    UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:colorPicker animated:YES completion:nil];
  }

  -(void)colorPicker:(HBColorPickerViewController *)colorPicker didAcceptColor:(UIColor *)color {
    _hexColor = [UIColor PF_hexFromColor:color];
    [_delegate didSelectColorWithHex:_hexColor forBundleID:_bundleID];

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.contentView.backgroundColor = color;
      _hexLabel.textColor = [self appropriateColorForLabel:color];
      _hexLabel.text = _hexColor;
    } completion:nil];
  }

  -(UIColor *)appropriateColorForLabel:(UIColor *)color {
    CGFloat h, s, b, a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];

    if(b > 0.6) { //color is pretty bright, darken it
      return [UIColor colorWithHue:h saturation:s brightness:b * .50 alpha:1];
    }

      //color is dark, lighten it but if its too dark just use white
    return (b <= .3) ? [UIColor whiteColor] : [UIColor colorWithHue:h saturation:s brightness:MIN(b * 1.5, 1) alpha:1];
  }

  -(CGFloat)preferredHeightForWidth:(CGFloat)width {
		return 50;
	}
@end
