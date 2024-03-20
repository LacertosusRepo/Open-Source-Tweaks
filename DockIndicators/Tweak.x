/*
 * Tweak.x
 * DockIndicators
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 10/9/2020.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <os/log.h>
@import Alderis;
#import "AlderisColorPicker.h"
#import "DockIndicators.h"
#import <objc/runtime.h>

  NSString *const domainString = @"com.lacertosusrepo.dockindicatorsprefs";
    //Global Variables
  static NSUserDefaults *preferences;

    //Preference Variables
  static NSInteger indicatorOffset;
  static NSInteger indicatorWidth;
  static NSInteger indicatorHeight;
  static CGFloat indicatorCornerRadius;
  static BOOL indicatorUseAppColor;
  static NSString *indicatorColor;
  static NSInteger indicatorAnimationType;

#pragma mark - Functions

  //Function to create notification animation
CAAnimationGroup* animationForType(DIPNotificationAnimationType type) {
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.duration = 2;
  animationGroup.repeatCount = INT_MAX;

  switch (type) {
    case DIPNotificationAnimationTypeBounce:
    {
      CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
      bounce.additive = YES;
      bounce.calculationMode = kCAAnimationCubic;
      bounce.duration = 1.5;
      bounce.removedOnCompletion = NO;
      bounce.values = @[@0, @-3, @0, @-1.6, @0, @-0.9, @0, @-0.5, @0];
      animationGroup.animations = @[bounce];
      break;
    }

    case DIPNotificationAnimationTypeShakeX:
    {
      CAKeyframeAnimation *shakeX = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
      shakeX.additive = YES;
      shakeX.calculationMode = kCAAnimationLinear;
      shakeX.duration = 1.5;
      shakeX.removedOnCompletion = NO;
      shakeX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      shakeX.values = @[@0, @3, @-3, @3, @-1.5, @1.5, @-1.5, @0];
      animationGroup.animations = @[shakeX];
      break;
    }

    case DIPNotificationAnimationTypeShakeY:
    {
      CAKeyframeAnimation *shakeY = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
      shakeY.additive = YES;
      shakeY.calculationMode = kCAAnimationLinear;
      shakeY.duration = 1.5;
      shakeY.removedOnCompletion = NO;
      shakeY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      shakeY.values = @[@0, @-3, @3, @-3, @1.5, @-1.5, @1.5, @0];
      animationGroup.animations = @[shakeY];
      break;
    }

    case DIPNotificationAnimationTypeGlow:
    {
      CAKeyframeAnimation *glow = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
      glow.calculationMode = kCAAnimationLinear;
      glow.duration = 2;
      glow.removedOnCompletion = NO;
      glow.values = @[@0, @1, @0];
      animationGroup.animations = @[glow];
      break;
    }

    case DIPNotificationAnimationTypePulse:
    {
      CAKeyframeAnimation *pulse = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
      pulse.calculationMode = kCAAnimationLinear;
      pulse.duration = 2;
      pulse.removedOnCompletion = NO;
      pulse.values = @[@1, @0.1, @1];
      animationGroup.animations = @[pulse];
      break;
    }

    default:
    break;
  };

  return animationGroup;
}

  //https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
  //Function to obtain the average color from the icon
UIColor* averageColorFromImage(UIImage *image, NSString *identifier) {
  if(!image || !identifier) {
    return nil;
  }

  NSMutableDictionary *mutableCache = ([[preferences objectForKey:@"appColorCache"] mutableCopy]) ?: [[NSMutableDictionary alloc] init];
  if([mutableCache objectForKey:identifier]) {
    return [UIColor PF_colorWithHex:[mutableCache objectForKey:identifier]];
  }

  CIImage *input = [[CIImage alloc] initWithImage:image];
  CIVector *extentVector = [CIVector vectorWithX:input.extent.origin.x Y:input.extent.origin.y Z:input.extent.size.width W:input.extent.size.height];
  CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage" withInputParameters:@{@"inputImage" : input, @"inputExtent" : extentVector}];
  CIImage *output = filter.outputImage;

  uint8_t bitmap[4] = {0, 0, 0, 0};
  CIContext *context = [CIContext contextWithOptions:@{@"kCIContextWorkingColorSpace" : [NSNull null]}];
  [context render:output toBitmap:&bitmap rowBytes:4 bounds:CGRectMake(0, 0, 1, 1) format:kCIFormatRGBA8 colorSpace:nil];

  UIColor *averageColor = [UIColor colorWithRed:(CGFloat)bitmap[0]/255 green:(CGFloat)bitmap[1]/255 blue:(CGFloat)bitmap[2]/255 alpha:1];
  [mutableCache setObject:[UIColor PF_hexFromColor:averageColor] forKey:identifier];
  [preferences setObject:mutableCache forKey:@"appColorCache"];

  return averageColor;
}

#pragma mark - Hooks

%hook SBIconView
%property (nonatomic, retain) UIView *runningIndicator;

- (instancetype)initWithFrame:(CGRect)arg1 {
	if ((self = %orig)) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRunningIndicators:) name:@"SBApplicationProcessStateDidChange" object:nil];
	}
	return self;
}

  -(void)_updateLabelAccessoryView {
    %orig;

    if(self.runningIndicator) {
      if(self.icon.badgeValue > 0 && ![self.runningIndicator.layer animationForKey:@"indicatorAnimation"] && indicatorAnimationType != DIPNotificationAnimationTypeNone) {
        [self.runningIndicator.layer addAnimation:animationForType(indicatorAnimationType) forKey:@"indicatorAnimation"];

      } else if(self.icon.badgeValue == 0 && [self.runningIndicator.layer animationForKey:@"indicatorAnimation"]) {
        [self.runningIndicator.layer removeAnimationForKey:@"indicatorAnimation"];
      }
    }
  }
%end

%hook SBDockIconListView

- (id)initWithModel:(id)arg0 layoutProvider:(id)arg1 iconLocation:(id)arg2 orientation:(NSInteger)arg3 iconViewProvider:(id)arg4 {
    %orig;
    self = %orig(arg0, arg1, arg2, arg3, arg4);

    if (self) {
        //NSLog(@"DockIndicators initWithModel");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRunningIndicators:) name:@"SBApplicationProcessStateDidChange" object:nil];

    }
    return self;
}

%new
-(void)updateRunningIndicators:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subview in self.subviews) {
            if (![subview isKindOfClass:%c(SBIconView)] || [subview isKindOfClass:%c(SBFolderIcon)] || ![(SBIconView *)subview icon] || ![[(SBIconView *)subview icon] isKindOfClass:%c(SBApplicationIcon)]) {

                continue;
            }
            SBIconView *iconView = (SBIconView *)subview;
            // Lazy initialization of the runningIndicator view
            if (!iconView.runningIndicator) {
                UIView *runningIndicator = [[UIView alloc] init];
                runningIndicator.alpha = 0;
                runningIndicator.layer.shadowOffset = CGSizeZero;
                runningIndicator.layer.shadowOpacity = 0;
                runningIndicator.layer.shadowRadius = 3;
                runningIndicator.translatesAutoresizingMaskIntoConstraints = NO;
                [iconView addSubview:runningIndicator];
                iconView.runningIndicator = runningIndicator;

                [NSLayoutConstraint activateConstraints:@[
                    [runningIndicator.centerXAnchor constraintEqualToAnchor:iconView.centerXAnchor],
                    [runningIndicator.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:indicatorOffset],
                    [runningIndicator.widthAnchor constraintEqualToConstant:indicatorWidth],
                    [runningIndicator.heightAnchor constraintEqualToConstant:indicatorHeight],
                ]];
            }

            // Set properties outside animation block
            UIColor *averageAppColor;
            if(indicatorUseAppColor && iconView.iconImageSnapshot) {
              averageAppColor = averageColorFromImage(iconView.iconImageSnapshot, iconView.applicationBundleIdentifierForShortcuts);
            }

            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              iconView.runningIndicator.backgroundColor = (averageAppColor) ?: [UIColor PF_colorWithHex:indicatorColor];
              iconView.runningIndicator.layer.cornerRadius = indicatorCornerRadius;
              iconView.runningIndicator.layer.shadowColor = (averageAppColor.CGColor) ?: [UIColor PF_colorWithHex:indicatorColor].CGColor;
            } completion:nil];

            SBApplication *application = [(SBApplicationIcon *)iconView.icon application];
            [UIView transitionWithView:iconView.runningIndicator duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                iconView.runningIndicator.alpha = application.processState.running ? 1 : 0;
            } completion:nil];

            // Handle the animation based on the badge value and animation type
            if (iconView.icon.badgeValue > 0 && ![iconView.runningIndicator.layer animationForKey:@"indicatorAnimation"] && indicatorAnimationType != DIPNotificationAnimationTypeNone) {
                [iconView.runningIndicator.layer addAnimation:animationForType(indicatorAnimationType) forKey:@"indicatorAnimation"];
            } else if (iconView.icon.badgeValue == 0 && [iconView.runningIndicator.layer animationForKey:@"indicatorAnimation"]) {
                [iconView.runningIndicator.layer removeAnimationForKey:@"indicatorAnimation"];
            }
        }
    });
}


%end

static BOOL tweakShouldLoad() {
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            NSLog(@"DockIndicators Processname : %@", processName);
            return [processName isEqualToString:@"SpringBoard"];
        }
    }

    return NO;
}



void loadPrefs() {
    NSUserDefaults *dockindicator = [[NSUserDefaults alloc] initWithSuiteName:domainString];

    // Register default values for the preferences
    NSDictionary *defaultPrefs = @{
        @"indicatorOffset": @(5),
        @"indicatorWidth": @(18),
        @"indicatorHeight": @(5),
        @"indicatorCornerRadius": @(2.5),
        @"indicatorUseAppColor": @(NO),
        @"indicatorAnimationType": @(DIPNotificationAnimationTypeBounce),
        @"indicatorColor": @"#FFFFFF"
    };
    [dockindicator registerDefaults:defaultPrefs];

    // Now load the preferences
    indicatorOffset = [dockindicator integerForKey:@"indicatorOffset"];
    indicatorWidth = [dockindicator integerForKey:@"indicatorWidth"];
    indicatorHeight = [dockindicator integerForKey:@"indicatorHeight"];
    indicatorCornerRadius = [dockindicator floatForKey:@"indicatorCornerRadius"];
    indicatorUseAppColor = [dockindicator boolForKey:@"indicatorUseAppColor"];
    indicatorAnimationType = [dockindicator integerForKey:@"indicatorAnimationType"];
    indicatorColor = [dockindicator stringForKey:@"indicatorColor"];

    // Initialize the appColorCache
    NSMutableDictionary *appColorCache = [[dockindicator objectForKey:@"appColorCache"] mutableCopy];
    if (!appColorCache) {
        appColorCache = [[NSMutableDictionary alloc] init];
    }
    // Assuming 'preferences' is a global variable that's been properly initialized
    [preferences setObject:appColorCache forKey:@"appColorCache"];
}


%ctor {

  if (!tweakShouldLoad()) {
    NSLog(@"DockIndicators shouldn't run in this process");
    return;
  }

  loadPrefs();
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		(CFNotificationCallback)loadPrefs,
		CFSTR("com.lacertosusrepo.dockindicatorsprefs/ReloadPrefs"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
	);
}
