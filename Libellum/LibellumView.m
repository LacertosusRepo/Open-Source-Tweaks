/*
 * LibellumView.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/15/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "LibellumView.h"

@implementation LibellumView
  +(id)sharedInstance {
    static LibellumView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [LibellumView alloc];
    });

    return sharedInstance;
  }

  -(id)init {
    if(self = [super init]) {
      self.alpha = 1.0;
      self.clipsToBounds = YES;
      self.hidden = NO;
      self.layer.cornerRadius = _cornerRadius;
      self.layer.borderColor = _borderColor.CGColor;
      self.layer.borderWidth = _borderWidth;
      self.translatesAutoresizingMaskIntoConstraints = NO;
      self.userInteractionEnabled = YES;

        //Create blur
      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:[self getRecipeForBlurStyle:_blurStyle] inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
        if([_blurStyle isEqualToString:@"adaptive"]) {
          materialView.recipe = 1;
          materialView.recipeDynamic = YES;
        }
        _blurView = materialView;

      } else {
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:[self getBlurEffectForBlurStyle:_blurStyle]]];
      }
      _blurView.translatesAutoresizingMaskIntoConstraints = NO;

        //Create text view
      _noteView = [[UITextView alloc] initWithFrame:self.bounds];
      _noteView.allowsEditingTextAttributes = YES;
      _noteView.backgroundColor = [UIColor clearColor];
      _noteView.clipsToBounds = YES;
      _noteView.contentInset = UIEdgeInsetsZero;
      _noteView.delegate = self;
      _noteView.editable = YES;
      _noteView.font = [UIFont systemFontOfSize:14];
      _noteView.keyboardAppearance = UIKeyboardAppearanceDark;
      _noteView.scrollEnabled = YES;
      _noteView.textAlignment = NSTextAlignmentLeft;
      _noteView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
      _noteView.tintColor = [self getTintColor];
      _noteView.translatesAutoresizingMaskIntoConstraints = NO;
      [self setNumberOfLines];
      [self loadNotes];

        //Add lock icon if on iOS13
      _lockIcon = [[UIImageView alloc] init];
      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        [_lockIcon setImage:[UIImage systemImageNamed:@"lock.fill"]];
        _lockIcon.hidden = !_requireAuthentication;
        _lockIcon.tintColor = _lockColor;
        _lockIcon.translatesAutoresizingMaskIntoConstraints = NO;
      }

      if([_blurStyle isEqualToString:@"colorized"]) {
        _blurView.alpha = 0;
        _noteView.backgroundColor = _customBackgroundColor;
        _noteView.textColor = _customTextColor;
      }

      [self addSubview:_blurView];
      [self addSubview:_noteView];
      [self addSubview:_lockIcon];

        //Add constraints
      [NSLayoutConstraint activateConstraints:@[
        [_blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_blurView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [_noteView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_noteView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_noteView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_noteView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [_lockIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_lockIcon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.heightAnchor constraintEqualToConstant:_noteSize],
      ]];

      [self setupGestures];

      if(_noteBackup) {
        [self backupNotes];
      }
    }

    return self;
  }

    //Determine what platter reciper to use, if its adaptive or colorized just use the default light platter
  -(NSString *)getRecipeForBlurStyle:(NSString *)style {
    if([style isEqualToString:@"adaptive"] || [style isEqualToString:@"colorized"]) {
      style = @"platters";
    }

    return style;
  }

    //iOS 12 compatible blurs
  -(UIBlurEffectStyle)getBlurEffectForBlurStyle:(NSString *)style {
    if([style isEqualToString:@"platters"]) {
      return UIBlurEffectStyleLight;
    } if([style isEqualToString:@"plattersDark"]) {
      return UIBlurEffectStyleDark;
    }

    return UIBlurEffectStyleRegular;
  }

    //Formula for figuring out height of the noteview: (lineHeight (16.7) * maximumNumberOfLines) + padding (20)
  -(void)setNumberOfLines {
    if(_enableEndlessLines) {
      _noteView.textContainer.maximumNumberOfLines = 999;
      return;
    }

    switch (_noteSize) {
      case 71:
      _noteView.textContainer.maximumNumberOfLines = 3;
      break;

      case 121:
      _noteView.textContainer.maximumNumberOfLines = 6;
      break;

      case 171:
      _noteView.textContainer.maximumNumberOfLines = 9;
      break;

      case 221:
      _noteView.textContainer.maximumNumberOfLines = 12;
      break;

      default:
      os_log(OS_LOG_DEFAULT, "Libellum || noteSize unknown value - %lu", _noteSize);
      break;
    }
  }

#pragma mark - Authentication

  -(void)authenticationStatusFromAggregator:(id)aggregator {
    switch ([aggregator lockState]) {
      case 0:
      _authenticated = YES;
      break;

      case 1:
      _authenticated = YES;
      break;

      default:
      _authenticated = NO;
      break;
    }

    [UIView transitionWithView:_noteView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      if(_authenticated) {
        _noteView.userInteractionEnabled = YES;
        _noteView.alpha = 1;
        _lockIcon.alpha = 0;

      } else {
        _noteView.userInteractionEnabled = NO;
        _noteView.alpha = 0;
        _lockIcon.alpha = 1;
      }
    } completion:nil];
  }

#pragma mark - Limit Number of Lines

    //StackOWOflow <3
    //https://stackoverflow.com/questions/19478679/setting-maximum-number-of-lines-entry-on-uitextview
  -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *currentText = [NSMutableString stringWithString:_noteView.text];
    [currentText replaceCharactersInRange:range withString:text];

    NSUInteger numberOfLines = 0;
    for(NSUInteger i = 0; i < currentText.length; i++) {
      if([[NSCharacterSet newlineCharacterSet] characterIsMember:[currentText characterAtIndex:i]]) {
        numberOfLines++;
      }
    }

    if(numberOfLines >= _noteView.textContainer.maximumNumberOfLines) {
      return NO;
    }

    NSAttributedString *wrappingCheck = [[NSAttributedString alloc] initWithString:[NSMutableString stringWithString:currentText] attributes:@{NSFontAttributeName:_noteView.font}];

    __block NSInteger lineCount = 0;
    CGFloat maxWidth = _noteView.bounds.size.width - 10;

    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:wrappingCheck];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainerBlock, NSRange glyphRange, BOOL *stop) {
      lineCount++;
    }];

    return (lineCount <= _noteView.textContainer.maximumNumberOfLines);
  }

#pragma mark - UITextView Delegate Methods

  -(void)textViewDidBeginEditing:(UITextView *)textView {
    _editing = YES;
  }

  -(void)textViewDidEndEditing:(UITextView *)textView {
    _editing = NO;
  }

  -(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = ([self isDarkMode]) ? UIBarStyleBlack : UIBarStyleDefault;
    toolBar.tintColor = [self getTintColor];
    toolBar.items = [self toolBarButtons];
    _noteView.inputAccessoryView = toolBar;

    return YES;
  }

  -(void)textViewDidChange:(UITextView *)textView {
    [self saveNotes];

    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
  }

  -(void)textViewDidChangeSelection:(UITextView *)textView {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
  }

#pragma mark - UIToolbar

  -(NSArray *)toolBarButtons {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];

    if(_enableUndoRedo) {
      [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButton)]];
      [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(redoButton)]];
      [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    }

    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pointButton)]];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)]];

    return [buttons copy];
  }

  -(void)pointButton {
    [_noteView replaceRange:_noteView.selectedTextRange withText:@"\u2022 "];
  }

  -(void)undoButton {
    if([[_noteView undoManager] canUndo]) {
      [[_noteView undoManager] undo];
    }
  }

  -(void)redoButton {
    if([[_noteView undoManager] canRedo]) {
      [[_noteView undoManager] redo];
    }
  }

  -(void)doneButton {
    [_noteView resignFirstResponder];
  }

#pragma mark - Loading/Saving/Backup Notes/Idle Timer Reset

  -(void)saveNotes {
    NSError *error = nil;
    NSData *data = [_noteView.attributedText dataFromRange:(NSRange){0, _noteView.attributedText.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
    [data writeToFile:filePath atomically:YES];
    if(error) {
      os_log(OS_LOG_DEFAULT, "Libellum || Error saving notes - %@", error);
    }
  }

  -(void)loadNotes {
    NSError *error = nil;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
    _noteView.attributedText = content;

    if(_ignoreAdaptiveColors) {
      _noteView.textColor = _customTextColor;
    }

    if(error) {
      os_log(OS_LOG_DEFAULT, "Libellum || Error loading notes - %@", error);
    }
  }

  -(void)backupNotes {
    NSError *error = nil;
    NSData *data = [_noteView.attributedText dataFromRange:(NSRange){0, _noteView.attributedText.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
    [data writeToFile:filePathBK atomically:YES];
    if(error) {
      os_log(OS_LOG_DEFAULT, "Libellum || Error backing up notes - %@", error);
    }
  }

#pragma mark - Show/Hide Gestures

  -(void)setupGestures {
    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLibellum:)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeGesture];

    _lGesture = [[LGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLibellum:)];
    _lGesture.enabled = NO;

    /*_edgeGesture = [[NSClassFromString(@"SBScreenEdgePanGestureRecognizer") alloc] initWithTarget:self action:@selector(toggleLibellum:) type:SBSystemGestureTypeNone options:nil];
    _edgeGesture.edges = UIRectEdgeTop;
    _edgeGesture.maximumNumberOfTouches = 1;
    [[NSClassFromString(@"FBSystemGestureManager") sharedInstance] addGestureRecognizer:_edgeGesture toDisplay:[NSClassFromString(@"FBDisplayManager") mainDisplay]];
    [[NSClassFromString(@"SBMainDisplaySystemGestureManager") sharedInstance] addGestureRecognizer:_edgeGesture withType:SBSystemGestureTypeNone];*/
  }

  -(void)toggleLibellum:(UIGestureRecognizer *)gesture {
    if(_hideGesture && !_editing) {
      if([gesture isKindOfClass:[LGestureRecognizer class]] && gesture.state != UIGestureRecognizerStateRecognized) {
        return;
      }

      HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];

      if(_feedback) {
        AudioServicesPlaySystemSound(_feedbackStyle);
      }

      if(self.hidden) {
        /*self.hidden = NO;
        [self.superview.superview layoutSubviews];
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.transform = CGAffineTransformMakeScale(1, 1);
          self.alpha = 1;
        } completion:nil];*/

        self.hidden = NO;
        [self.superview.superview layoutSubviews];
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
          } completion:nil];
        });

        [preferences setBool:NO forKey:@"isHidden"];
        return;

      } if(!self.hidden) {
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.transform = CGAffineTransformMakeScale(0.5, 0.5);
          self.alpha = 0;
        } completion:^(BOOL finished) {
          self.hidden = YES;
          [self.superview.superview layoutSubviews];
        }];

        [preferences setBool:YES forKey:@"isHidden"];
        return;
      }
    }
  }

#pragma mark - Preferences Changed/Adaptive Mode

  -(void)preferencesChanged {
    if(((_requireAuthentication && _authenticated) || !_requireAuthentication) && self.superview) {
      self.layer.cornerRadius = _cornerRadius;
      self.layer.borderColor = _borderColor.CGColor;
      self.layer.borderWidth = _borderWidth;
      _noteView.tintColor = [self getTintColor];

      _edgeGesture.enabled = _useEdgeGesture;
      _swipeGesture.enabled = _useSwipeGesture;

      if([_blurStyle isEqualToString:@"colorized"]) {
        _blurView.alpha = 0;
        _noteView.backgroundColor = _customBackgroundColor;
      } else {
        _blurView.alpha = 1;
        _noteView.backgroundColor = [UIColor clearColor];
      }

      if([_blurStyle isEqualToString:@"adaptive"] && !_ignoreAdaptiveColors) {
        [self tintColorDidChange];
      } else {
        _noteView.textColor = _customTextColor;
        _lockIcon.tintColor = _lockColor;
      }
    }
  }

  -(void)tintColorDidChange {
    switch ((int)[[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle]) {
        //Light Mode
      case 1: {
        if([_blurStyle isEqualToString:@"adaptive"] && !_ignoreAdaptiveColors) {
          [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _noteView.textColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor blackColor].CGColor;
          } completion:nil];
        }

        _lockIcon.tintColor = [UIColor blackColor];
        break;
      }

        //Dark Mode
      case 2: {
        if([_blurStyle isEqualToString:@"adaptive"] && !_ignoreAdaptiveColors) {
          [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _noteView.textColor = [UIColor whiteColor];
            self.layer.borderColor = [UIColor whiteColor].CGColor;
          } completion:nil];
        }

        _lockIcon.tintColor = [UIColor whiteColor];
        break;
      }
    }
  }

  -(UIColor *)getTintColor {
    if(_useKalmTintColor) {
      return [NSClassFromString(@"KalmAPI") getColor];
    }

    return _customTintColor;
  }

#pragma mark - Misc.

  -(BOOL)isDarkMode {
    return ([[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle] == 2) ? YES : NO;
  }

  -(void)openPrefs {
    //Only works from the homescreen, of course
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-prefs:Libellum"] options:@{} completionHandler:nil];
  }

@end
