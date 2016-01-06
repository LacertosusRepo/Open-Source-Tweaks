@interface PSListController : NSObject {
    id _specifiers;
}

- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface customreachpreferencesListController: PSListController
@end

@implementation customreachpreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"customreachpreferences" target:self] retain];
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

-(void)respring
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    system("killall -9 SpringBoard");
#pragma clang diagnostic pop
}
@end
