@interface SBUILegibilityLabel : UIView
@end

@interface SBFLockScreenDateView : UIView
@property (assign,getter=isSubtitleHidden,nonatomic) BOOL subtitleHidden;
@property (nonatomic,readonly) long long _keyboardOrientation;
@property (nonatomic,retain) NSDate *date;
-(id)_timeLabel;

  //Speculum
@property (retain) UIStackView *speculumStackView;
@property (retain) UIStackView *weatherStackView;
@property (retain) UIImageView *weatherConditionImage;
@property (retain) UILabel *timeLabel;
@property (retain) UILabel *dateLabel;
@property (retain) UILabel *weatherLabel;
-(void)setupSpeculum;
-(void)updateClockAndDate;
-(void)updateWeather;
-(void)setAlignment:(int)alignment;
-(void)switchViewPositions:(UITapGestureRecognizer *)gesture;
-(void)batteryStateChanged:(NSNotification *)notification;
-(void)fadeStackViewWithDuration:(float)duration withFadeInDelay:(float)delay;
-(void)preferencesChanged;
@end

@interface WFTemperature : NSObject
-(double)celsius;
-(double)fahrenheit;
-(double)kelvin;
@end

@interface City : NSObject
@property (assign,nonatomic) long long conditionCode;
-(BOOL)isCelsius;
-(WFTemperature *)temperature;
@end

@interface WeatherPreferences : NSObject
+(id)sharedPreferences;
+(id)userDefaultsPersistence;
-(NSDictionary *)userDefaults;
-(City *)cityFromPreferencesDictionary:(NSDictionary *)arg1;
-(City *)localWeatherCity;
-(int)userTemperatureUnit;
@end

@interface WeatherImageLoader : NSObject
+(id)sharedImageLoader;
+(UIImage *)conditionImageNamed:(id)arg1 size:(CGSize)arg2 cloudAligned:(BOOL)arg3 stroke:(BOOL)arg4 strokeAlpha:(double)arg5 lighterColors:(BOOL)arg6;
+(UIImage *)conditionImageWithConditionIndex:(long long)arg1;
+(NSString *)conditionImageNameWithConditionIndex:(long long)arg1;
@end
