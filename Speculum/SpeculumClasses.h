@interface SBUILegibilityLabel : UIView
@end

@interface SBFLockScreenDateSubtitleView : UIView
@end

@interface SBFLockScreenDateView : UIView <CFWColorDelegate>
@property (assign,getter=isSubtitleHidden,nonatomic) BOOL subtitleHidden;
@property (nonatomic,readonly) long long _keyboardOrientation;
@property (nonatomic,retain) NSDate *date;
-(void)setCustomSubtitleView:(SBFLockScreenDateSubtitleView *)arg1;
-(id)_timeLabel;

  //ColorFlow4
-(void)songAnalysisComplete:(MPModelSong *)song artwork:(UIImage *)artwork colorInfo:(CFWColorInfo *)colorInfo;
-(void)songHadNoArtwork:(MPModelSong *)song;

  //Speculum
@property (retain) UIStackView *speculumStackView;
@property (retain) UIStackView *weatherStackView;
@property (retain) UIImageView *weatherConditionImage;
@property (retain) UIView *fillerView;
@property (retain) UILabel *timeLabel;
@property (retain) UILabel *dateLabel;
@property (retain) UILabel *weatherLabel;
-(void)setupSpeculum;
-(void)updateClockAndDateLabel;
-(void)updateWeatherLabel;
-(void)updateWeatherForCity;
-(NSString *)conditionNameWithCode:(int)condition;
-(NSString *)conditionDescriptionWithCode:(int)condition;
-(void)batteryStateChanged:(NSNotification *)notification;
-(void)setAlignment:(int)alignment;
-(void)switchViewPositions:(UITapGestureRecognizer *)gesture;
-(void)fadeOutSpeculumWithDuration:(float)duration withDelay:(float)delay;
-(void)fadeInSpeculumWithDuration:(float)duration withDelay:(float)delay;
-(void)preferencesChanged;
@end

@interface SBPagedScrollView : UIScrollView
@property (assign,nonatomic) unsigned long long currentPageIndex;
@property (nonatomic,readonly) long long _keyboardOrientation;
@end

@interface WFTemperature : NSObject
-(double)celsius;
-(double)fahrenheit;
-(double)kelvin;
@end

@interface CLLocation : NSObject
@end

@interface City : NSObject
@property (nonatomic,copy) NSString *updateTimeString;
@property (assign,nonatomic) long long conditionCode;
@property (copy) CLLocation *location;
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

@interface TWCLocationUpdater : NSObject
+(id)sharedLocationUpdater;
-(void)_updateWeatherForLocation:(id)arg1 city:(id)arg2 completionHandler:(/*^block*/id)arg3;
@end

  //Force allow content hugging priority
@interface UILabel (Speculum)
-(void)setContentHuggingPriority:(float)arg1 forAxis:(NSInteger)arg2;
@end

@interface UIImageView (Speculum)
-(void)setContentHuggingPriority:(float)arg1 forAxis:(NSInteger)arg2;
@end
