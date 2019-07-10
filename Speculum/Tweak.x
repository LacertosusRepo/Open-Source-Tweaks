/*
 * Tweak.x
 * Speculum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/5/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"
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

    //Time
  static BOOL speculumTimeLabelSwitch;
  static NSString *speculumTimeLabelColor;
  static NSInteger speculumTimeLabelSize;
  static CGFloat speculumTimeLabelWeight;
  static NSString *speculumTimeLabelFormat;

    //Date
  static BOOL speculumDateLabelSwitch;
  static NSString *speculumDateLabelColor;
  static NSInteger speculumDateLabelSize;
  static CGFloat speculumDateLabelWeight;
  static NSString *speculumDateLabelFormat;
  static NSString *speculumDateLabelCalendar;

    //Weather
  static BOOL speculumWeatherLabelSwitch;
  static NSString *speculumWeatherLabelColor;
  static NSInteger speculumWeatherLabelSize;
  static CGFloat speculumWeatherLabelWeight;
  static BOOL speculumWeatherUseConditionImages;
  static NSInteger speculumWeatherConditionImageAlignment;
  static NSInteger speculumTempUnit;
  static NSInteger speculumWeatherUpdateTime;

    //Language
  static NSInteger speculumPreferredLanguage;

    /*
     * Variables
     */
  static SBFLockScreenDateView *lockScreeenDateView;

%hook SBDashBoardViewController
  -(void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 {
    %orig(NO, NO, NO);
  }

  -(BOOL)_isWakeAnimationInProgress {
    if(YES) {
      [lockScreeenDateView updateWeather];
    }
    return %orig;
  }
%end

%hook SBPagedScrollView
  -(void)layoutSubviews {
    %orig;

    if((self._keyboardOrientation == 3 || self._keyboardOrientation == 2)) {
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
    [NSTimer scheduledTimerWithTimeInterval:(speculumWeatherUpdateTime * 60) target:self selector:@selector(updateWeather) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateWeather) userInfo:nil repeats:NO];

    if(speculumChargingInformation) {
      [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
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
    [self updateClockAndDate];
  }

  -(void)setCustomSubtitleView:(SBFLockScreenDateSubtitleView *)arg1 {
    %orig(nil);
  }

%property (retain) UIStackView *speculumStackView;
%property (retain) UIStackView *weatherStackView;
%property (retain) UIImageView *weatherConditionImage;
%property (retain) UILabel *timeLabel;
%property (retain) UILabel *dateLabel;
%property (retain) UILabel *weatherLabel;
%new
  -(void)setupSpeculum {
    if(!self.timeLabel) {
      self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.timeLabel setFont:[UIFont systemFontOfSize:speculumTimeLabelSize weight:speculumTimeLabelWeight]];
      [self.timeLabel setNumberOfLines:0];
      [self.timeLabel setText:@""];
      [self.timeLabel setTextColor:LCPParseColorString(speculumTimeLabelColor, @"FFFFFF")];

      self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.dateLabel setFont:[UIFont systemFontOfSize:speculumDateLabelSize weight:speculumDateLabelWeight]];
      [self.dateLabel setNumberOfLines:0];
      [self.dateLabel setText:@""];
      [self.dateLabel setTextColor:LCPParseColorString(speculumDateLabelColor, @"FFFFFF")];

      self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.weatherLabel setFont:[UIFont systemFontOfSize:speculumWeatherLabelSize weight:speculumWeatherLabelWeight]];
      [self.weatherLabel setNumberOfLines:0];
      [self.weatherLabel setText:@""];
      [self.weatherLabel setTextColor:LCPParseColorString(speculumWeatherLabelColor, @"FFFFFF")];

      self.weatherConditionImage = [[UIImageView alloc] initWithFrame:CGRectZero];
      self.weatherConditionImage.translatesAutoresizingMaskIntoConstraints = NO;

      self.weatherStackView = [[UIStackView alloc] init];
      self.weatherStackView.axis = UILayoutConstraintAxisHorizontal;
      self.weatherStackView.alignment = UIStackViewAlignmentCenter;
      self.weatherStackView.distribution = UIStackViewDistributionEqualSpacing;
      self.weatherStackView.spacing = 0;
      self.weatherStackView.translatesAutoresizingMaskIntoConstraints = NO;

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

      [self.speculumStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;

      [self setAlignment:(int)speculumAlignment];
      [self updateWeather];
    }
  }

%new
  -(void)updateClockAndDate {
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
      }
    }
  }

%new
  -(void)updateWeather {
    if(self.weatherLabel && speculumWeatherLabelSwitch) {
      City *city = [[%c(WeatherPreferences) sharedPreferences] localWeatherCity];
      if(city == nil && [[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"] count] > 0) {
        city = [[%c(WeatherPreferences) sharedPreferences] cityFromPreferencesDictionary:[[[%c(WeatherPreferences) userDefaultsPersistence] userDefaults] objectForKey:@"Cities"][0]];
      }

      WFTemperature *temperature = [city temperature];
      switch ((int)speculumTempUnit) {
        case 0:
        self.weatherLabel.text = [NSString stringWithFormat:@"%d\u00B0F", (int)[temperature fahrenheit]];
        break;

        case 1:
        self.weatherLabel.text = [NSString stringWithFormat:@"%d\u00B0C", (int)[temperature celsius]];
        break;

        case 2:
        self.weatherLabel.text = [NSString stringWithFormat:@"%d\u00B0K", (int)[temperature kelvin]];
        break;
      }

      if(speculumWeatherUseConditionImages && [%c(WeatherImageLoader) respondsToSelector:@selector(conditionImageNamed:size:cloudAligned:stroke:strokeAlpha:lighterColors:)]) {
        [self.weatherLabel sizeToFit];

        NSString *weatherConditionName = [%c(WeatherImageLoader) conditionImageNameWithConditionIndex:city.conditionCode];
        self.weatherConditionImage.image = [%c(WeatherImageLoader) conditionImageNamed:weatherConditionName size:CGSizeMake(self.weatherLabel.frame.size.height + 20, self.weatherLabel.frame.size.height + 20) cloudAligned:NO stroke:NO strokeAlpha:0.0 lighterColors:NO];
      } else {
        if([self.weatherStackView.subviews containsObject:self.weatherConditionImage]) {
          [self.weatherStackView removeArrangedSubview:self.weatherConditionImage];
        }
      }
    }
  }

%new
  -(void)setAlignment:(int)alignment {
    if(alignment == 0) {
        //Left
      self.speculumStackView.alignment = UIStackViewAlignmentLeading;
      [self.speculumStackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    } if(alignment == 1) {
        //Center
      self.speculumStackView.alignment = UIStackViewAlignmentCenter;
      [self.speculumStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    } if(alignment == 2) {
        //Right
      self.speculumStackView.alignment = UIStackViewAlignmentTrailing;
      [self.speculumStackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    }

    switch ((int)speculumWeatherConditionImageAlignment) {
        //Left
      case 0:
      [self.weatherStackView removeArrangedSubview:self.weatherConditionImage];
      [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:0];
      break;

        //Right
      case 1:
      [self.weatherStackView removeArrangedSubview:self.weatherConditionImage];
      [self.weatherStackView insertArrangedSubview:self.weatherConditionImage atIndex:1];
      break;
    }

    [self.timeLabel setTextAlignment:alignment];
    [self.dateLabel setTextAlignment:alignment];
    [self.weatherLabel setTextAlignment:alignment];

    CGRect frame = self.speculumStackView.frame;
    frame.origin.y += speculumOffset;
    self.speculumStackView.frame = frame;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      [self.speculumStackView layoutIfNeeded];
    } completion:nil];
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
        [UIView transitionWithView:self.dateLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
          self.dateLabel.text = oldDateText;
        } completion:nil];
      });
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
  -(void)preferencesChanged {
    [self.timeLabel setFont:[UIFont systemFontOfSize:speculumTimeLabelSize weight:speculumTimeLabelWeight]];
    [self.timeLabel setTextColor:LCPParseColorString(speculumTimeLabelColor, @"#FFFFFF")];

    [self.dateLabel setFont:[UIFont systemFontOfSize:speculumDateLabelSize weight:speculumDateLabelWeight]];
    [self.dateLabel setTextColor:LCPParseColorString(speculumDateLabelColor, @"#FFFFFF")];

    [self.weatherLabel setFont:[UIFont systemFontOfSize:speculumWeatherLabelSize weight:speculumWeatherLabelWeight]];
    [self.weatherLabel setTextColor:LCPParseColorString(speculumWeatherLabelColor, @"#FFFFFF")];

    [self setAlignment:(int)speculumAlignment];
    [self updateClockAndDate];
    [self updateWeather];
  }
%end

static void speculumUseWallpaperColors() {
    NSData *lockData = [NSData dataWithContentsOfFile:@"/User/Library/SpringBoard/OriginalLockBackground.cpbitmap"];
    CFArrayRef lockArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)lockData, NULL, 1, NULL);
    NSArray *lockArray = (__bridge NSArray*)lockArrayRef;
    UIImage *lockWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(lockArray[0])];
    CFRelease(lockArrayRef);

    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.speculumprefs"];
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

  [preferences registerBool:&speculumTimeLabelSwitch default:YES forKey:@"speculumTimeLabelSwitch"];
  [preferences registerObject:&speculumTimeLabelColor default:@"#FFFFFF" forKey:@"speculumTimeLabelColor"];
  [preferences registerInteger:&speculumTimeLabelSize default:75 forKey:@"speculumTimeLabelSize"];
  [preferences registerFloat:&speculumTimeLabelWeight default:UIFontWeightMedium forKey:@"speculumTimeLabelWeight"];
  [preferences registerObject:&speculumTimeLabelFormat default:@"h:mm" forKey:@"speculumTimeLabelFormat"];

  [preferences registerBool:&speculumDateLabelSwitch default:YES forKey:@"speculumDateLabelSwitch"];
  [preferences registerObject:&speculumDateLabelColor default:@"#FFFFFF" forKey:@"speculumDateLabelColor"];
  [preferences registerInteger:&speculumDateLabelSize default:25 forKey:@"speculumDateLabelSize"];
  [preferences registerFloat:&speculumDateLabelWeight default:UIFontWeightLight forKey:@"speculumDateLabelWeight"];
  [preferences registerObject:&speculumDateLabelFormat default:@"EEEE, MMMM d" forKey:@"speculumDateLabelFormat"];
  [preferences registerObject:&speculumDateLabelCalendar default:@"gregorian" forKey:@"speculumDateLabelCalendar"];

  [preferences registerBool:&speculumWeatherLabelSwitch default:YES forKey:@"speculumWeatherLabelSwitch"];
  [preferences registerObject:&speculumWeatherLabelColor default:@"#FFFFFF" forKey:@"speculumWeatherLabelColor"];
  [preferences registerInteger:&speculumWeatherLabelSize default:20 forKey:@"speculumWeatherLabelSize"];
  [preferences registerFloat:&speculumWeatherLabelWeight default:UIFontWeightLight forKey:@"speculumWeatherLabelWeight"];
  [preferences registerBool:&speculumWeatherUseConditionImages default:YES forKey:@"speculumWeatherUseConditionImages"];
  [preferences registerInteger:&speculumWeatherConditionImageAlignment default:0 forKey:@"speculumWeatherConditionImageAlignment"];
  [preferences registerInteger:&speculumTempUnit default:1 forKey:@"speculumTempUnit"];
  [preferences registerInteger:&speculumWeatherUpdateTime default:30 forKey:@"speculumWeatherUpdateTime"];

  [preferences registerInteger:&speculumPreferredLanguage default:0 forKey:@"speculumPreferredLanguage"];

  [preferences registerPreferenceChangeBlock:^{
    [lockScreeenDateView preferencesChanged];
  }];
}
