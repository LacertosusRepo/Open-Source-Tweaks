#import "LGestureRecognizer.h"

@implementation LGestureRecognizer

  -(instancetype)initWithTarget:(id)target action:(SEL)action {
    if(self = [super initWithTarget:target action:action]) {

    }

    return self;
  }

  -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.strokePrecision = 10;

    if(touches.count > 1) {
      self.state = UIGestureRecognizerStateFailed;
      return;
    }

    self.state = UIGestureRecognizerStateBegan;
    self.firstTap = [touches.anyObject locationInView:self.view.superview];
  }

  -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if(self.state == UIGestureRecognizerStateFailed || self.state == UIGestureRecognizerStateRecognized) {
      return;
    }

    UIView *superview = [self.view superview];
    CGPoint currentPoint = [touches.anyObject locationInView:superview];
    CGPoint previousPoint = [touches.anyObject previousLocationInView:superview];
    if(self.strokePart == 0 && (currentPoint.y - self.firstTap.y) > 30 && currentPoint.y > previousPoint.y && (currentPoint.y - self.firstTap.y) <= self.strokePrecision) {
      os_log(OS_LOG_DEFAULT, "part 1 done");
      self.strokePart = 1;
    } else if(self.strokePart == 1 && currentPoint.x > previousPoint.x && (currentPoint.x - previousPoint.x) <= self.strokePrecision) {
      os_log(OS_LOG_DEFAULT, "part 2 done");
      self.strokePart = 2;
      self.state = UIGestureRecognizerStateRecognized;
    }

    //os_log(OS_LOG_DEFAULT, "part - %lu || 2 - %d || 3 - %d || 4 - %d", self.strokePart, (currentPoint.y - self.firstTap.y) > 30, (currentPoint.y > previousPoint.y), (currentPoint.y - self.firstTap.y) <= self.strokePrecision);
    os_log(OS_LOG_DEFAULT, "y - %f || first - %f || = %d", currentPoint.y, self.firstTap.y, ((currentPoint.y - self.firstTap.y) > 30));
  }

  -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self reset];
  }

  -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
    [self reset];
  }

  -(void)reset {
    [super reset];
    self.strokePart = 0;
  }
@end
