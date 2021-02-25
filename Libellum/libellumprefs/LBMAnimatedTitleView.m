#import "LBMAnimatedTitleView.h"

@implementation LBMAnimatedTitleView {
  UILabel *_titleLabel;
  NSLayoutConstraint *_yConstraint;
  CGFloat _minimumOffsetRequired;
}

  -(instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset {
    if([super init]) {
      _titleLabel = [[UILabel alloc] init];
      _titleLabel.text = title;
			_titleLabel.textAlignment = NSTextAlignmentCenter;
			_titleLabel.textColor = Pri_Color;
			_titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
			_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
      [_titleLabel sizeToFit];

      [self addSubview:_titleLabel];

      [NSLayoutConstraint activateConstraints:@[
        [self.widthAnchor constraintEqualToAnchor:_titleLabel.widthAnchor],
        [self.heightAnchor constraintEqualToAnchor:_titleLabel.heightAnchor],

        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        _yConstraint = [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:50],
      ]];

      _minimumOffsetRequired = minimumOffset;
    }

    return self;
  }

  -(void)adjustLabelPositionToScrollOffset:(CGFloat)offset {
    CGFloat adjustment = 50 - (offset - _minimumOffsetRequired);
    if(offset >= _minimumOffsetRequired) {
      if(adjustment <= 0) {
        _yConstraint.constant = 0;

      } else {
        _yConstraint.constant = adjustment;
      }

    } else {
      _yConstraint.constant = -50;
    }
  }
@end
