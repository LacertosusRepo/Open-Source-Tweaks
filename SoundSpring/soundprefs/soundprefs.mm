@interface PSListController : NSObject {
    id _specifiers;
}

- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface soundprefsListController: PSListController
@end

@implementation soundprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"soundprefs" target:self] retain];
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

-(void)playSound
{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.soundspring-playcurrentsound"), nil, nil, true);
}

-(void)stopSound
{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.soundspring-stopcurrentsound"), nil, nil, true);
}
@end
