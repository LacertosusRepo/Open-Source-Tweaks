#import "DIPIndicatorPreviewCell.h"

@implementation DIPIndicatorPreviewCell {
  HBPreferences *_preferences;
  UIView *_indicator;
  NSLayoutConstraint *_height;
  NSLayoutConstraint *_width;
}

  -(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _preferences = [HBPreferences preferencesForIdentifier:[specifier propertyForKey:@"defaults"]];
      [_preferences registerPreferenceChangeBlock:^{
        [self updateIndicatorPreview];
      }];

      _indicator = [[UIView alloc] initWithFrame:CGRectZero];
      _indicator.backgroundColor = [UIColor PF_colorWithHex:[_preferences objectForKey:@"indicatorColor"]];
      _indicator.layer.cornerRadius = [_preferences floatForKey:@"indicatorCornerRadius"];
      _indicator.layer.shadowColor = [UIColor PF_colorWithHex:[_preferences objectForKey:@"indicatorColor"]].CGColor;
      _indicator.layer.shadowOffset = CGSizeZero;
      _indicator.layer.shadowOpacity = 0;
      _indicator.layer.shadowRadius = 3;
      _indicator.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_indicator];

      [NSLayoutConstraint activateConstraints:@[
        [_indicator.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [_indicator.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        _width = [_indicator.widthAnchor constraintEqualToConstant:[_preferences integerForKey:@"indicatorWidth"]],
        _height = [_indicator.heightAnchor constraintEqualToConstant:[_preferences integerForKey:@"indicatorHeight"]],
      ]];

      UITapGestureRecognizer *animationPreviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewAnimation)];
      animationPreviewTap.numberOfTapsRequired = 1;
      [self.contentView addGestureRecognizer:animationPreviewTap];
    }

    return self;
  }

  -(void)previewAnimation {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2;
    animationGroup.repeatCount = 3;

    switch ([_preferences integerForKey:@"indicatorAnimationType"]) {
      case DIPNotificationAnimationTypeBounce:
      {
        CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        bounce.additive = YES;
        bounce.calculationMode = kCAAnimationCubic;
        bounce.duration = 1.5;
        bounce.removedOnCompletion = NO;
        bounce.values = @[@0, @-3, @0, @-1.6, @0, @-0.9, @0, @-0.5, @0];
        animationGroup.animations = @[bounce];
        break;
      }

      case DIPNotificationAnimationTypeShakeX:
      {
        CAKeyframeAnimation *shakeX = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        shakeX.additive = YES;
        shakeX.calculationMode = kCAAnimationLinear;
        shakeX.duration = 1.5;
        shakeX.removedOnCompletion = NO;
        shakeX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        shakeX.values = @[@0, @3, @-3, @3, @-1.5, @1.5, @-1.5, @0];
        animationGroup.animations = @[shakeX];
        break;
      }

      case DIPNotificationAnimationTypeShakeY:
      {
        CAKeyframeAnimation *shakeY = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        shakeY.additive = YES;
        shakeY.calculationMode = kCAAnimationLinear;
        shakeY.duration = 1.5;
        shakeY.removedOnCompletion = NO;
        shakeY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        shakeY.values = @[@0, @-3, @3, @-3, @1.5, @-1.5, @1.5, @0];
        animationGroup.animations = @[shakeY];
        break;
      }

      case DIPNotificationAnimationTypeGlow:
      {
        CAKeyframeAnimation *glow = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
        glow.calculationMode = kCAAnimationLinear;
        glow.duration = 2;
        glow.removedOnCompletion = NO;
        glow.values = @[@0, @1, @0];
        animationGroup.animations = @[glow];
        break;
      }

      default:
      break;
    };

    [_indicator.layer addAnimation:animationGroup forKey:@"indicatorAnimation"];
  }

  -(void)updateIndicatorPreview {
    _width.constant = [_preferences integerForKey:@"indicatorWidth"];
    _height.constant = [_preferences integerForKey:@"indicatorHeight"];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      _indicator.backgroundColor = [UIColor PF_colorWithHex:[_preferences objectForKey:@"indicatorColor"]];
      _indicator.layer.cornerRadius = [_preferences floatForKey:@"indicatorCornerRadius"];

      [_indicator.superview layoutIfNeeded];
    } completion:nil];
  }
@end
