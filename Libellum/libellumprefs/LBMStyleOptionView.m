#import "LBMStyleOptionView.h"

@implementation LBMStyleOptionView {
  UIStackView *_stackView;
  LBMStyleCheckView *_checkView;
  UILongPressGestureRecognizer *_pressGesture;
}

  -(id)initWithFrame:(CGRect)frame appearanceOption:(id)option {
    self = [super initWithFrame:frame];

    if(self) {
      _appearanceOption = option;

      _previewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
      _previewImageView.clipsToBounds = YES;
      _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
      _previewImageView.layer.cornerRadius = 5;
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

      _pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
      _pressGesture.allowableMovement = 0;
      _pressGesture.minimumPressDuration = 0.025;
      [self addGestureRecognizer:_pressGesture];
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
      [UIView animateWithDuration:0.1 animations:^{
        _previewImageView.alpha = 0.5;
      }];
    } else {
      [UIView animateWithDuration:0.1 animations:^{
        _previewImageView.alpha = 1.0;
      }];
    }
  }

  -(void)updateViewForStyle:(NSString *)style {
    self.enabled = [style isEqualToString:_appearanceOption];
  }

  -(void)handlePress:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
      self.highlighted = YES;

    } else if(gesture.state == UIGestureRecognizerStateRecognized) {
      self.highlighted = NO;
      if(!_checkView.selected) {
        [self.delegate selectedOption:self];
      }
    }
  }

  -(BOOL)gestureRecognizer:(id)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)otherGesture {
    return YES;
  }
@end
