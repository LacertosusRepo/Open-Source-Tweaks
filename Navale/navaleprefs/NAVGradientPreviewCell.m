#import "NAVGradientPreviewCell.h"

@implementation NAVGradientPreviewCell
	CAGradientLayer *gradientLayer;
	UIColor *colorOne;
	UIColor *colorTwo;

	static NSInteger gradientDirection;
	static NSString *colorOneString;
	static NSString *colorTwoString;

	+(void)updateColors {

		if(gradientDirection == 0) {
			gradientLayer.startPoint = CGPointMake(0.5, 0.0);
			gradientLayer.endPoint = CGPointMake(0.5, 1.0);
		} if(gradientDirection == 1) {
			gradientLayer.startPoint = CGPointMake(0.0, 0.5);
			gradientLayer.endPoint = CGPointMake(1.0, 0.5);
		}

		colorOne = LCPParseColorString(colorOneString, @"#FFFFFF");
		colorTwo = LCPParseColorString(colorTwoString, @"#FFFFFF");
		gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
	}

	-(id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
		self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.navaleprefs"];
		[preferences registerInteger:&gradientDirection default:1 forKey:@"gradientDirection"];
		[preferences registerObject:&colorOneString default:@"#3A7BD5" forKey:@"colorOneString"];
  	[preferences registerObject:&colorTwoString default:@"#3A6073" forKey:@"colorTwoString"];
		[preferences registerPreferenceChangeBlock:^{
			[[self class] updateColors];
		}];


		if(!gradientLayer) {
			gradientLayer = [CAGradientLayer layer];
		}

		if(gradientDirection == 0) {
			gradientLayer.startPoint = CGPointMake(0.5, 0.0);
			gradientLayer.endPoint = CGPointMake(0.5, 1.0);
		} if(gradientDirection == 1) {
			gradientLayer.startPoint = CGPointMake(0.0, 0.5);
			gradientLayer.endPoint = CGPointMake(1.0, 0.5);
		}

		colorOne = LCPParseColorString(colorOneString, @"#FFFFFF");
		colorTwo = LCPParseColorString(colorTwoString, @"#FFFFFF");
  	gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];

  	[self.contentView.layer insertSublayer:gradientLayer atIndex:0];
		[self.contentView.layer setMasksToBounds:YES];

		return self;
	}

	-(void)layoutSubviews {
		gradientLayer.frame = self.contentView.frame;
		gradientLayer.bounds = CGRectInset(self.contentView.frame, 2, 2);
		gradientLayer.cornerRadius = 5;
	}
@end
