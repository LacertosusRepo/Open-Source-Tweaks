#import "LBMStyleCheckView.h"
#import "PreferencesColorDefinitions.h"

@class LBMStyleOptionView;
@protocol LBMStyleOptionViewDelegate <NSObject>
-(void)selectedOption:(LBMStyleOptionView *)option;
@end

@interface LBMStyleOptionView : UIView
@property (nonatomic, weak) id<LBMStyleOptionViewDelegate> delegate;
@property (nonatomic, retain) id appearanceOption;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, retain) UIImageView *previewImageView;
@property (nonatomic, retain) UIImage *previewImage;
@property (nonatomic, retain) UILabel *label;
-(id)initWithFrame:(CGRect)frame appearanceOption:(id)option;
-(void)updateViewForStyle:(NSString *)style;
@end
