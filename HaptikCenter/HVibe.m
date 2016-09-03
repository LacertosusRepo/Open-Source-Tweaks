#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import "CoreTelephonyHeaders.h"
#import "HVibe.h"

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);

@implementation HVibe

+(void)vibrateDeviceForTimeLength:(CGFloat)timeLength {

			NSMutableDictionary* dict = [NSMutableDictionary dictionary];
			NSMutableArray* arr = [NSMutableArray array];
    
			[arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for time length
			[arr addObject:[NSNumber numberWithInt:timeLength*1000]];
		
			[arr addObject:[NSNumber numberWithBool:NO]];
			[arr addObject:[NSNumber numberWithInt:50]];
    
			[dict setObject:arr forKey:@"VibePattern"];
			[dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    
			AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dict);

}

@end