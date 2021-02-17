#import <UIKit/UIKit.h>
#import "PreferencesColorDefinitions.h"

@interface PTCHeaderView : UIView
@property (nonatomic, readonly) NSArray *randomLabels;
-(instancetype)initWithBundle:(NSBundle *)bundle;
@end
