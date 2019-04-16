@interface PSListController : NSObject {
    id _specifiers;
}

- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface popprefsListController: PSListController
@end

@implementation popprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"popprefs" target:self] retain];
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

-(void)github
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
}
@end