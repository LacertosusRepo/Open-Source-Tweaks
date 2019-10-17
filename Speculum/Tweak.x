/*
 * Tweak.x
 * Speculum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/5/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import "libcolorpicker.h"
#import "ColorFlowAPI.h"
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "SpeculumClasses.h"
#define LD_DEBUG NO
extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

    /*
     * Preference Variables
     */
  static NSInteger speculumAlignment;
  static NSInteger speculumOffset;
  static BOOL speculumChargingInformation;
  static BOOL speculumUseColorFlowColors;

    //Time
  static BOOL speculumTimeLabelSwitch;
  static BOOL speculumTimeLabelLowercase;
  static NSString *speculumTimeLabelColor;
  static NSInteger speculumTimeLabelSize;
  static CGFloat speculumTimeLabelWeight;
  static NSString *speculumTimeLabelFormat;

    //Date
  static BOOL speculumDateLabelSwitch;
  static BOOL speculumDateLabelLowercase;
  static NSString *speculumDateLabelColor;
  static NSInteger speculumDateLabelSize;
  static CGFloat speculumDateLabelWeight;
  static NSString *speculumDateLabelFormat;
  static NSString *speculumDateLabelCalendar;

    //Weather
  static BOOL speculumWeatherLabelSwitch;
  static BOOL speculumWeatherLabelLowercase;
  static NSString *speculumWeatherLabelColor;
  static NSInteger speculumWeatherLabelSize;
  static CGFloat speculumWeatherLabelWeight;
  static BOOL speculumWeatherUseConditionImages;
  static BOOL speculumWeatherUseConditionDescriptions;
  static NSInteger speculumWeatherConditionImageAlignment;
  static NSInteger speculumTempUnit;
  static NSInteger speculumWeatherUpdateTime;

    //Language
  static NSInteger speculumPreferredLanguage;

    /*
     * Variables
     */
  static SBFLockScreenDateView *lockScreeenDateView;
  static UIColor *primaryColor;
  static UIColor *secondaryColor;

%hook SBDashBoardViewController
  -(void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 {
    %orig(NO, NO, NO);
  }

  -(BOOL)_isWakeAnimationInProgress {
    if(YES && (int)speculumWeatherUpdateTime == 0) {
      [lockScreeenDateView updateWeatherForCity];
    }
    return %orig;
  }
%end

%hook SBPagedScrollView
  -(void)layoutSubviews {
    %orig;

    if((self._keyboardOrientation == 3 || self._keyboardOrientation == 4)) {
      if(self.currentPageIndex == 0) {
        [lockScreeenDateView fadeOutSpeculumWithDuration:0.3 withDelay:0];
      } else {
        [lockScreeenDateView fadeInSpeculumWithDuration:0.3 withDelay:0];
        [lockScreeenDateView setAlignment:0];
      }

    } else {
      [lockScreeenDateView fadeInSpeculumWithDuration:0.3 withDelay:0];
      [lockScreeenDateView setAlignment:(int)speculumAlignment];
    }
  }
%end

%hook SBFLockScreenDateView
  -(id)initWithFrame:(CGRect)arg1 {
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateWeatherLabel) userInfo:nil repeats:NO];

    if(speculumWeatherUpdateTime > 0) {
      [NSTimer scheduledTimerWithTimeInterval:(speculumWeatherUpdateTime * 60) target:self selector:@selector(updateWeatherForCity) userInfo:nil repeats:YES];
    }

    if(speculumChargingInformation) {
      [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    }

    if(speculumUseColorFlowColors) {
      [[%c(CFWSBMediaController) sharedInstance] addColorDelegate:self];
    }

    return lockScreeenDateView = %orig;
  }

  -(void)didMoveToSuperview {
    SBUILegibilityLabel *_timeLabel = [self _timeLabel];
    _timeLabel.hidden = YES;
    UIView *_dateView = [self valueForKey:@"_dateSubtitleView"];
    _dateView.hidden = YES;
    %orig;

    [self setupSpeculum];
  }

  -(void)_updateLabels {
    %orig;
    [self updateClockAndDateLabel];
  }

  -(void)setCustomSubtitleView:(SBFLockScreenDateSubtitleView *)arg1 {
    %orig(nil);
  }

    /*
     * ColorFlow4 Support
     * Fade out Speculum for fullscreen ColorFlow4
     */
  -(void)cfw_doColorize:(CFWColorInfo *)arg1 {
    %orig;

    [self fadeOutSpeculumWithDuration:0.3 withDelay:0];
  }

  -(void)cfw_doRevert {
    %orig;

    [self fadeInSpeculumWithDuration:0.3 withDelay:0];
  }

%new
  -(void)songAnalysisComplete:(MPModelSong *)song artwork:(UIImage *)artwork colorInfo:(CFWColorInfo *)colorInfo {
    if(speculumUseColorFlowColors) {
      primaryColor = colorInfo.primaryColor;
      secondaryColor = colorInfo.secondaryColor;
      [self preferencesChanged];
    }
  }

%new
  -(void)songHadNoArtwork:(MPModelSong *)song {
    if(speculumUseColorFlowColors) {
      primaryColor = nil;
      secondaryColor = nil;
      [self preferencesChanged];
    }
  }

%property (retain) UIStackView *speculumStackView;
%property (retain) UIStackView *weatherStackView;
%property (retain) UIImageView *weatherConditionImage;
%property (retain) UIView *fillerView;
%property (retain) UILabel *timeLabel;
%property (retain) UILabel *dateLabel;
%property (retain) UILabel *weatherLabel;
%new
  -(void)setupSpeculum {
    if(!self.timeLabel) {
      self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.timeLabel setFont:[UIFont systemFontOfSize:speculumTimeLabelSize weight:speculumTimeLabelWeight]];
      [self.timeLabel setNumberOfLines:1];
      [self.timeLabel setText:@""];
      [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

      self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.dateLabel setFont:[UIFont systemFontOfSize:speculumDateLabelSize weight:speculumDateLabelWeight]];
      [self.dateLabel setNumberOfLines:1];
      [self.dateLabel setText:@""];
      [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

      self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.weatherLabel setFont:[UIFont systemFontOfSize:speculumWeatherLabelSize weight:speculumWeatherLabelWeight]];
      [self.weatherLabel setNumberOfLines:1];
      [self.weatherLabel setText:@""];
      [self.weatherLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
      [self.weatherLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

      self.weatherConditionImage = [[UIImageView alloc] initWithFrame:CGRectZero];
      self.weatherConditionImage.contentMode = UIViewContentModeScaleAspectFit;
      self.weatherConditionImage.translatesAutoresizingMaskIntoConstraints = NO;
      [self.weatherConditionImage setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

      self.weatherStackView = [[UIStackView alloc] init];
      self.weatherStackView.axis = UILayoutConstraintAxisHorizontal;
      self.weatherStackView.alignment = UIStackViewAlignmentCenter;
      self.weatherStackView.distribution = UIStackViewDistributionFill;
      self.weatherStackView.spacing = 0;
      self.weatherStackView.translatesAutoresizingMaskIntoConstraints = NO;

      self.fillerView = [[UIView alloc] initWithFrame:CGRectZero];
      self.fillerView.tag = 2007;
      self.fillerView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.fillerView setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];

      [self.weatherStackView addArrangedSubview:self.fillerView];
      [self.weatherStackView addArrangedSubview:self.weatherLabel];
      [self.weatherStackView addArrangedSubview:self.weatherConditionImage];

      self.speculumStackView = [[UIStackView alloc] init];
      self.speculumStackView.axis = UILayoutConstraintAxisVertical;
      self.speculumStackView.distribution = UIStackViewDistributionEqualSpacing;
      self.speculumStackView.spacing = 0;
      self.speculumStackView.translatesAutoresizingMaskIntoConstraints = NO;

      [self.speculumStackView addArrangedSubview:self.timeLabel];
      [self.speculumStackView addArrangedSubview:self.dateLabel];
      [self.speculumStackView addArrangedSubview:self.weatherStackView];
      [self addSubview:self.speculumStackView];

      [self preferencesChanged];
    }
  }

%new
  -(void)updateClockAndDateLabel {
    if(self.timeLabel) {
      NSString *localeID;
      if([[NSLocale preferredLanguages] count] > (int)speculumPreferredLanguage) {
        localeID = [[NSLocale preferredLanguages] objectAtIndex:(int)speculumPreferredLanguage];
      } else {
        localeID = [[NSLocale currentLocale] localeIdentifier];
      }

      if(speculumTimeLabelSwitch) {
        if(speculumTimeLabelFormat.length < 1) {
          speculumTimeLabelFormat = @"h:mm";
        }
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:speculumTimeLabelFormat];
        [timeFormatter setLocale:[NSLocale localeWithLocaleIdentifier:localeID]];
        [timeFormatter setCalendar:[NSCalendar calendarWithIdentifier:speculumDateLabelCalendar]];
        self.timeLabel.text = [timeFormatter stringFromDate:self.date];

        if(speculumTimeLabelLowercase) {
          self.timeLabel.text = [self.timeLabel.text lowercaseString];
        }
      }

      if(speculumDateLabelSwitch) {
        if(speculumDateLabelFormat.length < 1) {
          speculumDateLabelFormat = @"EEEE, MMMM d";
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:speculumDateLabelFormat];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:localeID]];
        [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:speculumDateLabelCalendar]];
        self.dateLabel.text = [dateFormatter stringFromDate:self.date];

        if(speculumDateLabelLowercase) {
          self.dateLabel.text = [self.dateLabel.text lowercaseString];
        }
      }
    }
  }

%new
  -(void)updateWeatherLabel {
    if(self.weatherLabel && speculumWeatherLabelSwitch) {
      City *city = [[%c(WeatherPreferences) sharedPreferences] localWeatherCity];
      if(city == nil && [[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"] count] > 0) {
        city = [[%c(WeatherPreferences) sharedPreferences] cityFromPreferencesDictionary:[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"][0]];
      }

      WFTemperature *temperature = [city temperature];
      NSString *temperatureValue = @"--\u00B0";
      switch ((int)speculumTempUnit) {
        case 0:
        temperatureValue = [NSString stringWithFormat:@"%d\u00B0F", (int)[temperature fahrenheit]];
        break;

        case 1:
        temperatureValue = [NSString stringWithFormat:@"%d\u00B0C", (int)[temperature celsius]];
        break;

        case 2:
        temperatureValue = [NSString stringWithFormat:@"%d\u00B0K", (int)[temperature kelvin]];
        break;
      }

      self.weatherLabel.text = temperatureValue;

      if(speculumWeatherUseConditionDescriptions) {
        self.weatherLabel.text = [[NSString stringWithFormat:@"%@, ", [self conditionDescriptionWithCode:city.conditionCode]] stringByAppendingString:self.weatherLabel.text];

        if(speculumWeatherLabelLowercase) {
          self.weatherLabel.text = [self.weatherLabel.text lowercaseString];
        }
      }

      if(speculumWeatherUseConditionImages && [%c(WeatherImageLoader) respondsToSelector:@selector(conditionImageNamed:size:cloudAligned:stroke:strokeAlpha:lighterColors:)]) {
        NSString *weatherConditionName = [%c(WeatherImageLoader) conditionImageNameWithConditionIndex:city.conditionCode];
        self.weatherConditionImage.image = [%c(WeatherImageLoader) conditionImageNamed:weatherConditionName size:CGSizeMake(self.weatherLabel.font.lineHeight + 20, self.weatherLabel.font.lineHeight + 20) cloudAligned:NO stroke:NO strokeAlpha:0.0 lighterColors:NO];
      } else {
        if([self.weatherStackView.subviews containsObject:self.weatherConditionImage]) {
          [self.weatherStackView removeArrangedSubview:self.weatherConditionImage];
        }
      }
    }
  }

  //Packetfahrer - WeatherBanners
  //https://github.com/Packetfahrer/WeatherBanners/blob/b90ba1cb890aef0249a62e3d1d10d22037da97df/Tweak.xm#L69
%new
  -(void)updateWeatherForCity {
    City *city = [[%c(WeatherPreferences) sharedPreferences] localWeatherCity];
    if(city == nil && [[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"] count] > 0) {
      city = [[%c(WeatherPreferences) sharedPreferences] cityFromPreferencesDictionary:[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"][0]];
    }

    [[%c(TWCLocationUpdater) sharedLocationUpdater] _updateWeatherForLocation:city.location city:city completionHandler:^{
      [self updateWeatherLabel];
    }];
  }

  //SniperGER - GlobalWarmingNoMore
  //https://github.com/SniperGER/GlobalWarmingNoMore/blob/aed487b534007995bcd44597388680abf854b6c7/Editor/GWWeatherConditionParser.m
%new
  -(NSString *)conditionNameWithCode:(int)condition {
    switch (condition) {
      case 0: return @"WeatherConditionTornado";
		  case 1: return @"WeatherConditionTropicalStorm";
		  case 2: return @"WeatherConditionHurricane";
      case 3: return @"WeatherConditionSevereThunderstorm";
      case 4: return @"WeatherConditionThunderstorm";
      case 5: return @"WeatherConditionMixedRainAndSnow";
      case 6: return @"WeatherConditionMixedRainAndSleet";
      case 7: return @"WeatherConditionMixedSnowAndSleet";
      case 8: return @"WeatherConditionFreezingDrizzle";
      case 9: return @"WeatherConditionDrizzle";
      case 10: return @"WeatherConditionFreezingRain";
      case 11: return @"WeatherConditionShowers1";
      case 12: return @"WeatherConditionRain";
      case 13: return @"WeatherConditionSnowFlurries";
      case 14: return @"WeatherConditionSnowShowers";
      case 15: return @"WeatherConditionBlowingSnow";
      case 16: return @"WeatherConditionSnow";
      case 17: return @"WeatherConditionHail";
      case 18: return @"WeatherConditionSleet";
      case 19: return @"WeatherConditionDust";
      case 20: return @"WeatherConditionFog";
      case 21: return @"WeatherConditionHaze";
      case 22: return @"WeatherConditionSmoky";
      case 23: return @"WeatherConditionBreezy";
      case 24: return @"WeatherConditionWindy";
      case 25: return @"WeatherConditionFrigid";
      case 26: return @"WeatherConditionCloudy";
      case 27: return @"WeatherConditionMostlyCloudyNight";
      case 28: return @"WeatherConditionMostlyCloudyDay";
      case 29: return @"WeatherConditionPartlyCloudyNight";
      case 30: return @"WeatherConditionPartlyCloudyDay";
      case 31: return @"WeatherConditionClearNight";
      case 32: return @"WeatherConditionSunny";
      case 33: return @"WeatherConditionMostlySunnyNight";
      case 34: return @"WeatherConditionMostlySunnyDay";
      case 35: return @"WeatherConditionMixedRainFall";
      case 36: return @"WeatherConditionHot";
      case 37: return @"WeatherConditionIsolatedThunderstorms";
      case 38: return @"WeatherConditionScatteredThunderstorms";
      case 39: return @"WeatherConditionScatteredShowers";
      case 40: return @"WeatherConditionHeavyRain";
      case 41: return @"WeatherConditionScatteredSnowShowers";
      case 42: return @"WeatherConditionHeavySnow";
      case 43: return @"WeatherConditionBlizzard";
      case 44: return @"Not Available";
      case 45: return @"WeatherConditionScatteredShowers";
      case 46: return @"WeatherConditionScatteredSnowShowers";
      case 47: return @"WeatherConditionIsolatedThundershowers";
		  default: return [NSString stringWithFormat:@"Code Not Found: %d", condition];
	  }
  }

%new
  -(NSString *)conditionDescriptionWithCode:(int)condition {
    NSString *conditionName = [self conditionNameWithCode:condition];

    if(condition == 44 || condition > 47) {
      return conditionName;
    }

    return [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"] localizedStringForKey:conditionName value:nil table:@"WeatherFrameworkLocalizableStrings"];
  }

%new
  -(void)batteryStateChanged:(NSNotification *)notification {
    if(speculumChargingInformation && ![self.dateLabel.text containsString:@"Charged"]) {
      NSString *oldDateText = self.dateLabel.text;
      int batteryLevel = (int)([UIDevice currentDevice].batteryLevel * 100);
      if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging || [UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        [UIView transitionWithView:self.dateLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
          self.dateLabel.text = [NSString stringWithFormat:@"%d%% Charged", batteryLevel];
        } completion:nil];
      }

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.dateLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
          self.dateLabel.text = oldDateText;
        } completion:nil];
      });
    }
  }

%new
  -(void)setAlignment:(int)alignment {
    if(alignment == 0) {
        //Left
      self.speculumStackView.alignment = UIStackViewAlignmentLeading;
      [self.speculumStackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
      if(speculumWeatherUseConditionImages) {
        [self.weatherStackView insertArrangedSubview:self.fillerView atIndex:2];
      } else {
        [self.weatherStackView insertArrangedSubview:self.fillerView atIndex:1];
      }
    } if(alignment == 1) {
        //Center
      self.speculumStackView.alignment = UIStackViewAlignmentCenter;
      [self.speculumStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;

      [self.weatherStackView removeArrangedSubview:self.fillerView];
      self.weatherStackView.distribution = UIStackViewDistributionEqualSpacing;
    } if(alignment == 2) {
        //Right
      self.speculumStackView.alignment = UIStackViewAlignmentTrailing;
      [self.speculumStackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
      [self.weatherStackView insertArrangedSubview:self.fillerView atIndex:0];
    }

    switch ((int)speculumWeatherConditionImageAlignment) {
        //Left
      case 0:
      if([self.weatherStackView.arrangedSubviews firstObject].tag == 2007) {
        [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:1];
      } else {
        [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:0];
      }
      break;
        //Right
      case 1:
      if(speculumWeatherUseConditionImages) {
        [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:2];
      } else {
        [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:1];
      }
      break;
    }

    [self.timeLabel setTextAlignment:alignment];
    [self.dateLabel setTextAlignment:alignment];
    [self.weatherLabel setTextAlignment:alignment];

    [self.speculumStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:speculumOffset].active = YES;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      [self.speculumStackView layoutIfNeeded];
      [self.weatherStackView layoutIfNeeded];
    } completion:nil];
  }

%new
  -(void)switchViewPositions:(UITapGestureRecognizer *)gesture {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
    switch((int)speculumAlignment) {
      case 0:
      [preferences setInteger:1 forKey:@"speculumAlignment"];
      break;

      case 1:
      [preferences setInteger:2 forKey:@"speculumAlignment"];
      break;

      case 2:
      [preferences setInteger:0 forKey:@"speculumAlignment"];
      break;
    }
  }

%new
  -(void)fadeOutSpeculumWithDuration:(float)duration withDelay:(float)delay {
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.speculumStackView.alpha = 0;
    } completion:nil];
  }

%new
  -(void)fadeInSpeculumWithDuration:(float)duration withDelay:(float)delay {
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.speculumStackView.alpha = 1;
    } completion:nil];
  }

%new
  -(void)preferencesChanged {
    [self.timeLabel setFont:[UIFont systemFontOfSize:speculumTimeLabelSize weight:speculumTimeLabelWeight]];
    [self.dateLabel setFont:[UIFont systemFontOfSize:speculumDateLabelSize weight:speculumDateLabelWeight]];
    [self.weatherLabel setFont:[UIFont systemFontOfSize:speculumWeatherLabelSize weight:speculumWeatherLabelWeight]];

    if(speculumUseColorFlowColors && primaryColor != nil && secondaryColor != nil) {
      [self.timeLabel setTextColor:primaryColor];
      [self.dateLabel setTextColor:secondaryColor];
      [self.weatherLabel setTextColor:secondaryColor];
    } else {
      [self.timeLabel setTextColor:LCPParseColorString(speculumTimeLabelColor, @"#FFFFFF")];
      [self.dateLabel setTextColor:LCPParseColorString(speculumDateLabelColor, @"#FFFFFF")];
      [self.weatherLabel setTextColor:LCPParseColorString(speculumWeatherLabelColor, @"#FFFFFF")];
    }

    [self setAlignment:(int)speculumAlignment];
    [self updateClockAndDateLabel];
    [self updateWeatherLabel];
  }
%end

static void speculumUseWallpaperColors() {
  NSData *lockData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
  CFArrayRef lockArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)lockData, NULL, 1, NULL);
  NSArray *lockArray = (__bridge NSArray*)lockArrayRef;
  UIImage *lockWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(lockArray[0])];
  CFRelease(lockArrayRef);

  HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.speculumprefs"];
  [lockWallpaper getPaletteImageColorWithMode:VIBRANT_PALETTE | LIGHT_VIBRANT_PALETTE | DARK_VIBRANT_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"speculumTimeLabelColor"];
  }];
  [lockWallpaper getPaletteImageColorWithMode:MUTED_PALETTE | LIGHT_MUTED_PALETTE | DARK_MUTED_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
    [preferences setObject:recommendColor.imageColorString forKey:@"speculumDateLabelColor"];
    [preferences setObject:recommendColor.imageColorString forKey:@"speculumWeatherLabelColor"];
  }];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)speculumUseWallpaperColors, CFSTR("com.lacertosusrepo.speculumprefs-speculumUseWallpaperColors"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
  [preferences registerInteger:&speculumAlignment default:2 forKey:@"speculumAlignment"];
  [preferences registerInteger:&speculumOffset default:0 forKey:@"speculumOffset"];
  [preferences registerBool:&speculumChargingInformation default:YES forKey:@"speculumChargingInformation"];
  [preferences registerBool:&speculumUseColorFlowColors default:NO forKey:@"speculumUseColorFlowColors"];

  [preferences registerBool:&speculumTimeLabelSwitch default:YES forKey:@"speculumTimeLabelSwitch"];
  [preferences registerBool:&speculumTimeLabelLowercase default:NO forKey:@"speculumTimeLabelLowercase"];
  [preferences registerObject:&speculumTimeLabelColor default:@"#FFFFFF" forKey:@"speculumTimeLabelColor"];
  [preferences registerInteger:&speculumTimeLabelSize default:75 forKey:@"speculumTimeLabelSize"];
  [preferences registerFloat:&speculumTimeLabelWeight default:UIFontWeightMedium forKey:@"speculumTimeLabelWeight"];
  [preferences registerObject:&speculumTimeLabelFormat default:@"h:mm" forKey:@"speculumTimeLabelFormat"];

  [preferences registerBool:&speculumDateLabelSwitch default:YES forKey:@"speculumDateLabelSwitch"];
  [preferences registerBool:&speculumDateLabelLowercase default:NO forKey:@"speculumDateLabelLowercase"];
  [preferences registerObject:&speculumDateLabelColor default:@"#FFFFFF" forKey:@"speculumDateLabelColor"];
  [preferences registerInteger:&speculumDateLabelSize default:25 forKey:@"speculumDateLabelSize"];
  [preferences registerFloat:&speculumDateLabelWeight default:UIFontWeightLight forKey:@"speculumDateLabelWeight"];
  [preferences registerObject:&speculumDateLabelFormat default:@"EEEE, MMMM d" forKey:@"speculumDateLabelFormat"];
  [preferences registerObject:&speculumDateLabelCalendar default:@"gregorian" forKey:@"speculumDateLabelCalendar"];

  [preferences registerBool:&speculumWeatherLabelSwitch default:YES forKey:@"speculumWeatherLabelSwitch"];
  [preferences registerBool:&speculumWeatherLabelLowercase default:NO forKey:@"speculumWeatherLabelLowercase"];
  [preferences registerObject:&speculumWeatherLabelColor default:@"#FFFFFF" forKey:@"speculumWeatherLabelColor"];
  [preferences registerInteger:&speculumWeatherLabelSize default:20 forKey:@"speculumWeatherLabelSize"];
  [preferences registerFloat:&speculumWeatherLabelWeight default:UIFontWeightLight forKey:@"speculumWeatherLabelWeight"];
  [preferences registerBool:&speculumWeatherUseConditionImages default:YES forKey:@"speculumWeatherUseConditionImages"];
  [preferences registerBool:&speculumWeatherUseConditionDescriptions default:YES forKey:@"speculumWeatherUseConditionDescriptions"];
  [preferences registerInteger:&speculumWeatherConditionImageAlignment default:0 forKey:@"speculumWeatherConditionImageAlignment"];
  [preferences registerInteger:&speculumTempUnit default:0 forKey:@"speculumTempUnit"];
  [preferences registerInteger:&speculumWeatherUpdateTime default:30 forKey:@"speculumWeatherUpdateTime"];

  [preferences registerInteger:&speculumPreferredLanguage default:0 forKey:@"speculumPreferredLanguage"];

  [preferences registerPreferenceChangeBlock:^{
    [lockScreeenDateView preferencesChanged];
  }];
}
