#import <substrate.h>

%hook SBOrientationLockManager
-(BOOL)_effectivelyLocked {
	return YES;
}

-(void)_updateLockStateWithOrientation:(long long)arg1 forceUpdateHID:(BOOL)arg2 changes:(/*^block*/id)arg3 {
	%orig(arg1,NO,arg3);
}

-(BOOL)lockOverrideEnabled {
	return NO;
}

-(BOOL)isLocked {
	return YES;
}
%end

%hook SBUIActiveOrientationObserver
-(void)activeInterfaceOrientationWillChangeToOrientation:(long long)arg1 {
	%orig(nil);
}
%end