#import "PreferencesColorDefinitions.h"

@interface IMPHeaderCell : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *subtitleLabel;
@property (nonatomic, readonly) NSArray *randomLabels;
@end
