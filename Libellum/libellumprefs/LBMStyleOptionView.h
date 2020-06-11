#import "LBMStyleCheckView.h"

@class LBMStyleOptionView;
@protocol LBMStyleOptionViewDelegate <NSObject>
-(void)selectedOption:(LBMStyleOptionView *)option;
@end

@interface LBMStyleOptionView : UIView
@property (nonatomic, weak) id<LBMStyleOptionViewDelegate> delegate;
@property (nonatomic, retain) NSString *appearanceOption;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, retain) UIImageView *previewImageView;
@property (nonatomic, retain) UIImage *previewImage;
@property (nonatomic, retain) UILabel *label;
-(id)initWithFrame:(CGRect)frame appearanceOption:(NSString *)option;
-(void)updateViewForStyle:(NSString *)style;
@end
