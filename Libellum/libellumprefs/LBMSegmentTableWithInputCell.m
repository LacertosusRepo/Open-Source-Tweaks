#import "LBMSegmentTableWithInputCell.h"

@implementation LBMSegmentTableWithInputCell {
  NSArray *_segmentValues;
  UIButton *_inputButton;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _segmentValues = [specifier propertyForKey:@"validValues"];

      _inputButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
      _inputButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
      _inputButton.layer.cornerRadius = 15;
      [_inputButton addTarget:self action:@selector(inputButtonTapped) forControlEvents:UIControlEventTouchUpInside];
      [_inputButton setImage:[[UIImage kitImageNamed:@"UIRemoveControlPlus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
      [_inputButton setImage:[[UIImage kitImageNamed:@"UITintedCircularButtonCheckmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
      self.accessoryView = _inputButton;

      [self.control addTarget:self action:@selector(valueChangedWithControl) forControlEvents:UIControlEventValueChanged];
    }

    return self;
  }

  -(void)didMoveToWindow {
    [super didMoveToWindow];

    if(![_segmentValues containsObject:[self.specifier performGetter]]) {
      ((UISegmentControl *)self.control).selectedSegmentIndex = UISegmentedControlNoSegment;
      _inputButton.selected = YES;
      [self animateInputButton:YES];
    }
  }

  -(void)inputButtonTapped {
	  UIAlertController *enterValueAlert = [UIAlertController alertControllerWithTitle:@"Set Custom Size" message:@"Setting a custom size will automatically enabled endless lines." preferredStyle:UIAlertControllerStyleAlert];
    [enterValueAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
      textField.keyboardType = UIKeyboardTypeDecimalPad;
      textField.text = [NSString stringWithFormat:@"%@", [self.specifier performGetter]];
      textField.textColor = self.tintColor;
    }];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      NSNumber *inputValue = [NSNumber numberWithInt:[enterValueAlert.textFields[0].text integerValue]];
      [self.specifier performSetterWithValue:inputValue];

      if([_segmentValues containsObject:inputValue]) {
        ((UISegmentControl *)self.control).selectedSegmentIndex = [_segmentValues indexOfObject:inputValue];
        _inputButton.selected = NO;
        [self animateInputButton:NO];

      } else {
        ((UISegmentControl *)self.control).selectedSegmentIndex = UISegmentedControlNoSegment;
        _inputButton.selected = YES;
        [self animateInputButton:YES];
      }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [enterValueAlert addAction:confirmAction];
    [enterValueAlert addAction:cancelAction];

    UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:enterValueAlert animated:YES completion:nil];
  }

  -(void)valueChangedWithControl {
    if(_inputButton.selected) {
      _inputButton.selected = NO;
      [self animateInputButton:NO];
    }
  }

  -(void)animateInputButton:(BOOL)selected {
    if(selected) {
      [UIView animateWithDuration:0.1 animations:^{
        _inputButton.backgroundColor = [self.tintColor colorWithAlphaComponent:0.3];
      }];

      CABasicAnimation *showBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
      showBorder.duration = 0.1;
      showBorder.fromValue = @0;
      showBorder.toValue = @2;

      _inputButton.layer.borderWidth = 2;
      [_inputButton.layer addAnimation:showBorder forKey:@"Show Border"];
    } else {
      
      [UIView animateWithDuration:0.1 animations:^{
        _inputButton.backgroundColor = [UIColor clearColor];
      }];

      if(_inputButton.layer.borderWidth > 0) {
        CABasicAnimation *hideBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        hideBorder.duration = 0.1;
        hideBorder.fromValue = @2;
        hideBorder.toValue = @0;

        _inputButton.layer.borderWidth = 0;
        [_inputButton.layer addAnimation:hideBorder forKey:@"Hide Border"];
      }
    }
  }

  -(void)tintColorDidChange {
    [super tintColorDidChange];

    _inputButton.layer.borderColor = self.tintColor.CGColor;
    _inputButton.tintColor = self.tintColor;
  }

  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {
      _inputButton.layer.borderColor = self.tintColor.CGColor;
      _inputButton.tintColor = self.tintColor;
	  }

    if(![_segmentValues containsObject:[self.specifier performGetter]]) {
      ((UISegmentControl *)self.control).selectedSegmentIndex = UISegmentedControlNoSegment;
      _inputButton.selected = YES;
      [self animateInputButton:YES];
    }
  }
@end
