#import "LBMStyleOptionView.h"

@implementation LBMStyleOptionView {
  UIStackView *_stackView;
  LBMStyleCheckView *_checkView;
  UITapGestureRecognizer *_tapGesture;
}

  -(id)initWithFrame:(CGRect)frame appearanceOption:(id)option {
    self = [super initWithFrame:frame];

    if(self) {
      _appearanceOption = option;

      _previewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
      _previewImageView.clipsToBounds = YES;
      _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
      _previewImageView.layer.cornerRadius = 8;
      _previewImageView.layer.borderColor = Pri_Color.CGColor;
      _previewImageView.translatesAutoresizingMaskIntoConstraints = NO;

      _label = [[UILabel alloc] initWithFrame:CGRectZero];
      _label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
      _label.textAlignment = NSTextAlignmentCenter;
      _label.translatesAutoresizingMaskIntoConstraints = NO;

      _checkView = [[LBMStyleCheckView alloc] initWithFrame:CGRectZero];
      _checkView.translatesAutoresizingMaskIntoConstraints = NO;

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_previewImageView, _label, _checkView]];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisVertical;
      _stackView.distribution = UIStackViewDistributionEqualSpacing;
      _stackView.spacing = 5;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self addSubview:_stackView];

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [_checkView.heightAnchor constraintEqualToConstant:22],
        [_checkView.widthAnchor constraintEqualToConstant:22],
      ]];

      _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
      [self addGestureRecognizer:_tapGesture];
    }

    return self;
  }

  -(void)setPreviewImage:(UIImage *)image {
    _previewImage = image;
    _previewImageView.image = _previewImage;
  }

  -(void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    _checkView.selected = _enabled;
  }

  -(void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;

    if(_highlighted) {
      CABasicAnimation *showBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
      showBorder.duration = 0.1;
      showBorder.fromValue = @0;
      showBorder.toValue = @3;

      _previewImageView.layer.borderWidth = 3;
      [_previewImageView.layer addAnimation:showBorder forKey:@"Show Border"];
    }

    if(!_highlighted && _previewImageView.layer.borderWidth == 3) {
      CABasicAnimation *hideBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
      hideBorder.duration = 0.1;
      hideBorder.fromValue = @3;
      hideBorder.toValue = @0;

      _previewImageView.layer.borderWidth = 0;
      [_previewImageView.layer addAnimation:hideBorder forKey:@"Hide Border"];
    }
  }

  -(void)updateViewForStyle:(NSString *)style {
    self.enabled = [style isEqualToString:_appearanceOption];
    self.highlighted = [style isEqualToString:_appearanceOption];
  }

  -(void)handleTap:(UIGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateRecognized && !_checkView.selected) {
      [self.delegate selectedOption:self];
    }
  }

  -(BOOL)gestureRecognizer:(id)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)otherGesture {
    return YES;
  }
@end
