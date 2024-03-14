#import <os/log.h>
#import <UIKit/UIKit.h>
#import "MTMaterialView.h"
#import "LibellumManager.h"

@interface UIImage (Private)
+(instancetype)kitImageNamed:(NSString *)arg1;
@end

@interface UIUserInterfaceStyleArbiter : NSObject
+(instancetype)sharedInstance;
-(long long)currentStyle;
@end

@interface CSCoverSheetViewControllerBase : UIViewController
@end

@interface LibellumViewController : CSCoverSheetViewControllerBase <UITextViewDelegate>
@property (nonatomic, retain) NSUserDefaults *preferences;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSAttributedString *text;
@property (nonatomic, retain) MTMaterialView *blurView;
@property (nonatomic, retain) UITextView *noteTextView;
@property (nonatomic, retain) UIImageView *lockImageView;
@property (nonatomic, assign) BOOL isDarkMode;

  //Preferences
@property (nonatomic, assign) NSInteger noteSize;
@property (nonatomic, copy) NSString *blurStyle;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL requireAuthentication;
@property (nonatomic, assign) BOOL useKalmTintColor;
@property (nonatomic, assign) BOOL ignoreAdaptiveColors;
@property (nonatomic, copy) UIColor *customBackgroundColor;
@property (nonatomic, copy) UIColor *customTextColor;
@property (nonatomic, copy) UIColor *lockColor;
@property (nonatomic, copy) UIColor *customTintColor;
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSInteger textAlignment;
@property (nonatomic, assign) BOOL enableEndlessLines;
-(void)setNumberOfLines;
-(void)authenticationStatus:(BOOL)unlocked;
-(void)updatePreferences;
-(void)updateViews;
-(void)interfaceStyleDidChange:(BOOL)darkMode;
-(UIColor *)getTintColor;
-(BOOL)isDarkMode;
@end
