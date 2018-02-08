#import "BBHeaders.h"

void sendTestNotification() {
	
	id request = [[[%c(BBBulletinRequest) alloc] init] autorelease];
			[request setTitle: @"Notification"];
			[request setMessage: @"Text, Text, Texty, Text"];
			[request setSectionID: @"com.apple.Preferences"];
			[request setBulletinID: @"com.lacertosusrepo.notificationexample"];
			[request setDefaultAction: [%c(BBAction) action]];
			
	id ctrl = [%c(SBBulletinBannerController) sharedInstance];
	if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2];
	} else if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:playLightsAndSirens:withReply:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2 playLightsAndSirens:YES withReply:nil];
	}
}

%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)sendTestNotification, CFSTR("com.lacertosusrepo.notificationexample-notification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	
}