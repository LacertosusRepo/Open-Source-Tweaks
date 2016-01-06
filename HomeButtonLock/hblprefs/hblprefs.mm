@interface PSListController : NSObject {
    id _specifiers;
}

- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface hblprefsListController: PSListController
@end

@implementation hblprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"hblprefs" target:self] retain];
	}
	return _specifiers;
}

-(void)twitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"]];
}

-(void)paypal
{
	 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/Lacertosus"]];
}
@end