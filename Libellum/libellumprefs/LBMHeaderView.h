#import <UIKit/UIKit.h>
#import "PreferencesColorDefinitions.h"
#import "../MTMaterialView.h"

#define LOGS(format, ...) NSLog(@"Libellum: " format, ## __VA_ARGS__)

@interface LBMHeaderView : UIView
-(instancetype)initWithTitle:(NSString *)title subtitles:(NSArray *)subtitles bundle:(NSBundle *)bundle;
@end
