#import "NAVGradientPreviewCell.h"

@implementation NAVGradientPreviewCell {
	HBPreferences *_preferences;
  CAGradientLayer *_gradient;
  UIColor *_one;
  UIColor *_two;
  UIColor *_border;
}

  -(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _gradient = [CAGradientLayer layer];
      _gradient.startPoint = CGPointMake(0.0, 0.5);
      _gradient.endPoint = CGPointMake(1.0, 0.5);
      //_gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
      _gradient.opacity = 1.0;
      _gradient.cornerRadius = 5;
      _gradient.borderColor = ([UIColor respondsToSelector:@selector(labelColor)]) ? [UIColor opaqueSeparatorColor].CGColor : [UIColor systemGrayColor].CGColor;
      _gradient.borderWidth = 3;
      [self.contentView.layer addSublayer:_gradient];
      [self.contentView.layer setMasksToBounds:YES];

      if([[specifier propertyForKey:@"defaults"] length] > 0) {
        _preferences = [HBPreferences preferencesForIdentifier:[specifier propertyForKey:@"defaults"]];
        [_preferences registerPreferenceChangeBlock:^{
          [self updatePreviewGradient];
        }];
      }
    }

    return self;
  }

  -(void)layoutSubviews {
    [super layoutSubviews];
    _gradient.frame = self.contentView.bounds;
    _gradient.bounds = CGRectInset(self.contentView.bounds, 2, 2);
  }

  -(void)updatePreviewGradient {
    if(_preferences) {
      _one = [UIColor PF_colorWithHex:[_preferences objectForKey:@"colorOneString"]];
      _two = [UIColor PF_colorWithHex:[_preferences objectForKey:@"colorTwoString"]];
      _border = [UIColor PF_colorWithHex:[_preferences objectForKey:@"borderColorString"]];
      _gradient.colors = @[(id)_one.CGColor, (id)_two.CGColor];
      _gradient.opacity = [_preferences floatForKey:@"dockAlpha"];
      _gradient.borderColor = _border.CGColor;
      _gradient.borderWidth = [_preferences floatForKey:@"borderWidth"];
    }
  }
@end
