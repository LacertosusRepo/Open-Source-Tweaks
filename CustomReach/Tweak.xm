static BOOL ReachEnabled = YES; 
static BOOL ReachintActiveEnabled = YES;
static BOOL ReachTimerEnabled = YES;
static BOOL TapforTriggerEnabled = YES;
static BOOL YOffsetEnabled = YES;
static BOOL StiffEnabled = YES;
static int ReachintActive = 10;
static int ReachTimer = 15;
static int NumberofTaps = 2;
static int YOffset = 50;
static int StiffNumber = 100;



%hook SBReachabilitySettings

-(BOOL)allowOnAllDevices {
	return ReachEnabled;
	}
	
-(double)reachabilityInteractiveKeepAlive {
	if(ReachintActiveEnabled) {
		return ReachintActive;
	} else {
	return %orig;
	}
}

-(double)reachabilityDefaultKeepAlive {
	if(ReachTimerEnabled) {
		return ReachTimer;
	} else {
		return %orig;
	}
}

-(unsigned long long)numberOfTapsForTapTrigger {
	if(TapforTriggerEnabled) {
		return NumberofTaps;
	} else {
		return 2;
		}
}

-(double)yOffsetFactor {
	if(YOffsetEnabled) {
		return YOffset;
	} else {
		return %orig;
		}
}
	
-(double)stiffness {
	if(StiffEnabled) {
		return StiffNumber;
	} else {
		return %orig;
		}
}

%end

//PREFERENCES
static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.lacertosus.customreach.plist"];
    if(prefs)
    {
        ReachEnabled = ( [prefs objectForKey:@"ReachEnabled"] ? [[prefs objectForKey:@"ReachEnabled"] boolValue] : ReachEnabled );
		ReachintActiveEnabled = ( [prefs objectForKey:@"ReachintActiveEnabled"] ? [[prefs objectForKey:@"ReachintActiveEnabled"] boolValue] : ReachintActiveEnabled );
		ReachTimerEnabled = ( [prefs objectForKey:@"ReachTimerEnabled"] ? [[prefs objectForKey:@" ReachTimerEnabled"] boolValue] : ReachTimer/ReachTimerEnabled );
		TapforTriggerEnabled = ( [prefs objectForKey:@"TapforTriggerEnabled"] ? [[prefs objectForKey:@"TapforTriggerEnabled"] boolValue] : TapforTriggerEnabled );
		YOffsetEnabled = ( [prefs objectForKey:@"YOffsetEnabled"] ? [[prefs objectForKey:@"YOffsetEnabled"] boolValue] : YOffsetEnabled );
		StiffEnabled = ( [prefs objectForKey:@"StiffEnabled"] ? [[prefs objectForKey:@"StiffEnabled"] boolValue] : StiffEnabled );
		
		ReachintActive = [prefs objectForKey:@"ReachintActive"] ? [[prefs objectForKey:@"ReachintActive"] intValue] : ReachintActive;
		ReachTimer = [prefs objectForKey:@"ReachTimer"] ? [[prefs objectForKey:@"ReachTimer"] intValue] : ReachTimer;
		NumberofTaps = [prefs objectForKey:@"NumberofTaps"] ? [[prefs objectForKey:@"NumberofTaps"] intValue] : NumberofTaps;
		YOffset = [prefs objectForKey:@"YOffset"] ? [[prefs objectForKey:@"YOffset"] intValue] : YOffset;
        StiffNumber = [prefs objectForKey:@"StiffNumber"] ? [[prefs objectForKey:@"StiffNumber"] intValue]: StiffNumber; 
    
		
	}
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.jontelang.sliderchangerprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}