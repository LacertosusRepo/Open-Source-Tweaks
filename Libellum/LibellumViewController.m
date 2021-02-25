/*
 * LibellumViewController.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 1/12/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "LibellumViewController.h"

@implementation LibellumViewController {
    BOOL _authenticated;
    BOOL _isDarkMode;
    BOOL _atLeastiOS13;
}

  -(instancetype)init {
    if(self = [super init]) {
      _isDarkMode = ([[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle] == 2) ?: NO;
      _atLeastiOS13 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}];
    }

    return self;
  }

  -(void)viewDidLoad {
    [super viewDidLoad];

    self.view.alpha = 1.0;
    self.view.clipsToBounds = YES;
    self.view.hidden = NO;
    self.view.layer.cornerRadius = self.cornerRadius;
    self.view.layer.borderColor = self.borderColor.CGColor;
    self.view.layer.borderWidth = self.borderWidth;
    self.view.userInteractionEnabled = YES;

      //Create blur
    if(_atLeastiOS13) {
      self.blurView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:[self getRecipeForBlurStyle:self.blurStyle] inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
      self.blurView.recipeDynamic = [self.blurStyle isEqualToString:@"adaptive"];
      self.blurView.recipe = 1;
    } else {
      self.blurView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:MTMaterialRecipeNotifications options:MTMaterialOptionsBlur];
      self.blurView.backgroundColor = ([self.blurStyle isEqualToString:@"platters"]) ? [UIColor colorWithWhite:1 alpha:0.7] : [UIColor colorWithWhite:0 alpha:0.7];
    }
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;

      //Create text view
    self.noteTextView = [[UITextView alloc] init];
    self.noteTextView.allowsEditingTextAttributes = YES;
    self.noteTextView.attributedText = self.text;
    self.noteTextView.backgroundColor = [UIColor clearColor];
    self.noteTextView.clipsToBounds = YES;
    self.noteTextView.contentInset = UIEdgeInsetsZero;
    self.noteTextView.delegate = [LibellumManager sharedManager];
    self.noteTextView.editable = YES;
    self.noteTextView.font = [UIFont systemFontOfSize:14];
    self.noteTextView.keyboardAppearance = (_isDarkMode) ? UIKeyboardAppearanceDark : UIKeyboardAppearanceLight;
    self.noteTextView.scrollEnabled = YES;
    self.noteTextView.textAlignment = self.textAlignment;
    self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.noteTextView.tintColor = [self getTintColor];
    self.noteTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setNumberOfLines];

      //Create lock icon
    if(_atLeastiOS13) {
      self.lockImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"lock.fill"]];
    } else {
      self.lockImageView = [[UIImageView alloc] initWithImage:[[UIImage kitImageNamed:@"UIAccessDeniedViewLock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
      self.lockImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.lockImageView.hidden = !self.requireAuthentication;
    self.lockImageView.tintColor = self.lockColor;
    self.lockImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.blurView];
    [self.view addSubview:self.noteTextView];
    [self.view addSubview:self.lockImageView];

    [NSLayoutConstraint activateConstraints:@[
      [self.blurView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
      [self.blurView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
      [self.blurView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
      [self.blurView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],

      [self.noteTextView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
      [self.noteTextView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
      [self.noteTextView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
      [self.noteTextView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],

      [self.lockImageView.widthAnchor constraintEqualToConstant:17],
      [self.lockImageView.heightAnchor constraintEqualToConstant:16.3],
      [self.lockImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
      [self.lockImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];

    [self interfaceStyleDidChange:_isDarkMode];
  }

  -(NSString *)getRecipeForBlurStyle:(NSString *)style {
    return (![style isEqualToString:@"plattersDark"]) ? @"platters" : style;
  }

    //Formula for figuring out height of the noteTextView: (lineHeight (16.7) * maximumNumberOfLines) + padding (20)
  -(void)setNumberOfLines {
    if(self.enableEndlessLines) {
      self.noteTextView.textContainer.maximumNumberOfLines = 999;
      return;
    }

    switch (self.noteSize) {
      case 71:
      self.noteTextView.textContainer.maximumNumberOfLines = 3;
      break;

      case 121:
      self.noteTextView.textContainer.maximumNumberOfLines = 6;
      break;

      case 171:
      self.noteTextView.textContainer.maximumNumberOfLines = 9;
      break;

      case 221:
      self.noteTextView.textContainer.maximumNumberOfLines = 12;
      break;

      default:
      os_log(OS_LOG_DEFAULT, "Libellum || noteSize custom value - %lu", self.noteSize);
      self.noteTextView.textContainer.maximumNumberOfLines = 999;
      break;
    }
  }

#pragma mark - Authentication

  -(void)authenticationStatus:(BOOL)unlocked {
    _authenticated = unlocked;

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      if(unlocked) {
        self.noteTextView.userInteractionEnabled = YES;
        self.noteTextView.alpha = 1;
        self.lockImageView.alpha = 0;

      } else {
        self.noteTextView.userInteractionEnabled = NO;
        self.noteTextView.alpha = 0;
        self.lockImageView.alpha = 1;
      }
    } completion:nil];
  }

#pragma mark - Preferences

-(void)updatePreferences {
    self.noteSize = [self.preferences integerForKey:@"noteSize"];
    self.blurStyle = [self.preferences objectForKey:@"blurStyle"];
    self.cornerRadius = [self.preferences integerForKey:@"cornerRadius"];

    self.requireAuthentication = [self.preferences boolForKey:@"requireAuthentication"];

    self.useKalmTintColor = [self.preferences boolForKey:@"useKalmTintColor"];
    self.ignoreAdaptiveColors = [self.preferences boolForKey:@"ignoreAdaptiveColors"];
    self.customBackgroundColor = [UIColor PF_colorWithHex:[self.preferences objectForKey:@"customBackgroundColor"]];
    self.customTextColor = [UIColor PF_colorWithHex:[self.preferences objectForKey:@"customTextColor"]];
    self.lockColor = [UIColor PF_colorWithHex:[self.preferences objectForKey:@"lockColor"]];
    self.customTintColor = [UIColor PF_colorWithHex:[self.preferences objectForKey:@"customTintColor"]];

    self.borderColor = [UIColor PF_colorWithHex:[self.preferences objectForKey:@"borderColor"]];
    self.borderWidth = [self.preferences integerForKey:@"borderWidth"];

    self.textAlignment = [self.preferences integerForKey:@"textAlignment"];
    self.enableEndlessLines = [self.preferences boolForKey:@"enableEndlessLines"];

    if(self.view.superview) {
      [self updateViews];
    }
  }

  -(void)updateViews {
    self.view.layer.cornerRadius = self.cornerRadius;
    self.view.layer.borderColor = self.borderColor.CGColor;
    self.view.layer.borderWidth = self.borderWidth;

    self.noteTextView.textAlignment = self.textAlignment;
    self.noteTextView.textColor = self.customTextColor;
    self.noteTextView.tintColor = [self getTintColor];

    self.lockImageView.alpha = (_authenticated) ? 0 : 1;
    self.lockImageView.tintColor = self.lockColor;
    self.lockImageView.hidden = !self.requireAuthentication;

      //Setup colorized background if chosen
    self.blurView.alpha = ([self.blurStyle isEqualToString:@"colorized"]) ? 0 : 1;
    self.view.backgroundColor = ([self.blurStyle isEqualToString:@"colorized"]) ? self.customBackgroundColor : [UIColor clearColor];

    [self setNumberOfLines];
    [self interfaceStyleDidChange:_isDarkMode];
  }

  -(void)interfaceStyleDidChange:(BOOL)darkMode {
    _isDarkMode = darkMode;

    if([self.blurStyle isEqualToString:@"adaptive"] && !self.ignoreAdaptiveColors) {
        //Light Mode
      if(!_isDarkMode) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.noteTextView.textColor = [UIColor blackColor];
          self.lockImageView.tintColor = [UIColor blackColor];
        } completion:nil];

        //Dark Mode
      } if(_isDarkMode) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.noteTextView.textColor = [UIColor whiteColor];
          self.lockImageView.tintColor = [UIColor whiteColor];
        } completion:nil];
      }
    }
  }

  -(UIColor *)getTintColor {
    if(self.useKalmTintColor) {
      UIColor *kalmTint = [NSClassFromString(@"KalmAPI") getColor];

      if(kalmTint) {
        return kalmTint;
      }
    }

    return self.customTintColor;
  }

#pragma mark - Misc.

  -(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if([self.noteTextView isFirstResponder]) {
      [self.noteTextView resignFirstResponder];
    }
  }

  -(NSString *)description {
    return [NSString stringWithFormat:@"<%@; index = %ld; authenticated = %@; text = '%@'>", [self class], self.index, (_authenticated) ? @"YES" : @"NO", self.noteTextView.text];
  }

@end
