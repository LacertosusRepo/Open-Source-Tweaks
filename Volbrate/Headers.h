		//---Vibration Implementation---//
FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);

@interface FeedbackCall : NSObject
+(void)vibrateDevice;
+(void)vibrateDeviceForTimeLengthIntensity:(CGFloat)timeLength vibrationIntensity:(CGFloat)vibeIntensity;
@end

		//Thanks Qusic TapTapFolder
		//https://github.com/Qusic/TapTapFolder
@interface _UITapticEngine : NSObject
-(void)actuateFeedback:(long long)arg1;
@end

@interface UIDevice (Private)
-(id)_tapticEngine;
@end