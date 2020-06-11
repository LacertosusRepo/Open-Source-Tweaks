#import "LBMStyleCheckView.h"

@implementation LBMStyleCheckView {
  UIImageView *_circleImageView;
  UIImageView *_checkmarkImageView;
}

  -(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if(self) {
      UIImage *unchecked = [[UIImage kitImageNamed:@"UIRemoveControlMultiNotCheckedImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      _circleImageView = [[UIImageView alloc] initWithImage:unchecked];
      _circleImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [_circleImageView sizeToFit];
      [self addSubview:_circleImageView];

      UIImage *checked = [[UIImage kitImageNamed:@"UITintedCircularButtonCheckmark.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      _checkmarkImageView = [[UIImageView alloc] initWithImage:checked];
      _checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [_checkmarkImageView sizeToFit];
      [self addSubview:_checkmarkImageView];
    }

    return self;
  }

  -(void)updateSelectedState {
    if(_selected) {
      [UIView animateWithDuration:0.1 animations:^{
        _checkmarkImageView.alpha = 1;
      }];
    } else {
      [UIView animateWithDuration:0.1 animations:^{
        _checkmarkImageView.alpha = 0;
      }];
    }
  }

  -(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self updateSelectedState];
  }
@end
