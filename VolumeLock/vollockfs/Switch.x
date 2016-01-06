#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

@interface VolLockFSSwitch : NSObject <FSSwitchDataSource>
@end

@implementation VolLockFSSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return FSSwitchStateOn;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
}

@end