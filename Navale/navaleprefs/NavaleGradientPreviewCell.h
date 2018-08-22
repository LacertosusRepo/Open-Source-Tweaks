#import "libcolorpicker.h"
#import "Preferences/PSTableCell.h"

@interface NavaleGradientPreviewCell : PSTableCell
@end

@implementation NavaleGradientPreviewCell
	CAGradientLayer * gradientLayer;
	static int gradientDirection;
	//static int gradientPosition;
	UIColor * colorOne;
	UIColor * colorTwo;

-(void)layoutSubviews {
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist"];
	gradientDirection = [[preferences objectForKey:@"gradientDirection"] intValue];
	//gradientPosition = [[preferences objectForKey:@"gradientPosition"] floatValue];

	NSMutableDictionary * colors = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
	colorOne = LCPParseColorString([colors objectForKey:@"colorOne"], @"#FFFFFF");
  colorTwo = LCPParseColorString([colors objectForKey:@"colorTwo"], @"#FFFFFF");

  gradientLayer = [CAGradientLayer layer];
	if(gradientDirection == 0) {
		gradientLayer.startPoint = CGPointMake(0.5, 0.0);
		gradientLayer.endPoint = CGPointMake(0.5, 1.0);
	} if(gradientDirection == 1) {
		gradientLayer.startPoint = CGPointMake(0.0, 0.5);
		gradientLayer.endPoint = CGPointMake(1.0, 0.5);
	}
  gradientLayer.frame = self.contentView.frame;
	gradientLayer.bounds = self.contentView.bounds;
  gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];

  [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
	[self.contentView.layer setMasksToBounds:YES];
	[self.contentView.layer setCornerRadius:5.0f];
	[self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.contentView.layer setBorderWidth:1.0f];

	[preferences release];
	[colors release];
}

+(void)reloadCell {
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navaleprefs.plist"];
	gradientDirection = [[preferences objectForKey:@"gradientDirection"] intValue];
	//gradientPosition = [[preferences objectForKey:@"gradientPosition"] floatValue];

	NSMutableDictionary * colors = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.navalecolors.plist"];
 	colorOne = LCPParseColorString([colors objectForKey:@"colorOne"], @"#FFFFFF");
 	colorTwo = LCPParseColorString([colors objectForKey:@"colorTwo"], @"#FFFFFF");
	if(gradientDirection == 0) {
		gradientLayer.startPoint = CGPointMake(0.5, 0.0);
		gradientLayer.endPoint = CGPointMake(0.5, 1.0);
	} if(gradientDirection == 1) {
		gradientLayer.startPoint = CGPointMake(0.0, 0.5);
		gradientLayer.endPoint = CGPointMake(1.0, 0.5);
	}
	gradientLayer.colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];

	[preferences release];
	[colors release];
}
@end
