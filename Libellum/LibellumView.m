/*
 * LibellumView.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/15/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "LibellumView.h"

  static NSString *filePath = @"/User/Library/Preferences/LibellumNotes.txt";
  static NSString *filePathBK = @"/User/Library/Preferences/LibellumNotes.bk";

@implementation LibellumView
  +(id)sharedInstance {
    static LibellumView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [LibellumView alloc];
    });

    return sharedInstance;
  }

  -(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
      self.alpha = 1.0;
      self.clipsToBounds = YES;
      self.hidden = NO;
      self.layer.cornerRadius = self.cornerRadius;
      self.layer.borderColor = self.borderColor.CGColor;
      self.layer.borderWidth = self.borderWidth;
      self.translatesAutoresizingMaskIntoConstraints = NO;
      self.userInteractionEnabled = YES;

        //Create blur
      self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.blurStyle]];
      self.blurView.translatesAutoresizingMaskIntoConstraints = NO;

        //Create gradient
/*    self.gradient = [CAGradientLayer layer];
      self.gradient.frame = self.bounds;
      self.gradient.startPoint = CGPointMake(0.5, 0.0);
      self.gradient.endPoint = CGPointMake(0.5, 1.0);
      self.gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor purpleColor].CGColor];
      [self.blurView.layer addSublayer:self.gradient];    */

        //Create text view
      self.noteView = [[UITextView alloc] initWithFrame:self.bounds];
      self.noteView.backgroundColor = [UIColor clearColor];
      self.noteView.clipsToBounds = YES;
      self.noteView.contentInset = UIEdgeInsetsZero;
      self.noteView.delegate = self;
      self.noteView.editable = YES;
      self.noteView.font = [UIFont systemFontOfSize:14];
      self.noteView.keyboardAppearance = UIKeyboardAppearanceDark;
      self.noteView.scrollEnabled = YES;
      self.noteView.textAlignment = NSTextAlignmentLeft;
      self.noteView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
      self.noteView.tintColor = self.customTintColor;
      self.noteView.translatesAutoresizingMaskIntoConstraints = NO;

        //Add lock icon if on iOS13
      self.lockIcon = [[UIImageView alloc] init];
      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        [self.lockIcon setImage:[UIImage systemImageNamed:@"lock.fill"]];
        self.lockIcon.hidden = !self.requireAuthentication;
        self.lockIcon.tintColor = self.lockColor;
        self.lockIcon.translatesAutoresizingMaskIntoConstraints = NO;
      }

      if(self.blurStyle == 3) {
        self.blurView.alpha = 0;
        self.noteView.backgroundColor = self.customBackgroundColor;
        self.noteView.textColor = self.customTextColor;
      }

      [self addSubview:self.blurView];
      [self addSubview:self.noteView];
      [self addSubview:self.lockIcon];

        //Add constraints
      [NSLayoutConstraint activateConstraints:@[
        [self.blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.blurView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.noteView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.noteView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.noteView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.noteView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.lockIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.lockIcon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.heightAnchor constraintEqualToConstant:self.noteSize],
      ]];

      [self setNumberOfLines];
      [self setupGestures];
      [self loadNotes];

      if(self.noteBackup) {
        [self backupNotes];
      }
    }

    return self;
  }

    //Formula for figuring out height of the noteview: (lineHeight (16.7) * maximumNumberOfLines) + padding (20)
  -(void)setNumberOfLines {
    switch (self.noteSize) {
      case 71:
      self.noteView.textContainer.maximumNumberOfLines = 3;
      break;

      case 121:
      self.noteView.textContainer.maximumNumberOfLines = 6;
      break;

      case 171:
      self.noteView.textContainer.maximumNumberOfLines = 9;
      break;

      case 221:
      self.noteView.textContainer.maximumNumberOfLines = 12;
      break;

      default:
      NSLog(@"Libellum || noteSize unknown value - %lu", self.noteSize);
      break;
    }

    if(self.enableEndlessLines) {
      self.noteView.textContainer.maximumNumberOfLines = 999;
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

    [UIView transitionWithView:self.noteView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      if(_authenticated) {
        self.noteView.userInteractionEnabled = YES;
        self.lockIcon.alpha = 0;

        if(self.blurStyle == 7 && !self.ignoreAdaptiveColors) {
          self.noteView.textColor = ([self isDarkMode]) ? [UIColor whiteColor] : [UIColor blackColor];
        } else {
          self.noteView.textColor = self.customTextColor;
        }

      } else {
        self.noteView.userInteractionEnabled = NO;
        self.noteView.textColor = [UIColor clearColor];
        self.lockIcon.alpha = 1;
      }
    } completion:nil];
  }

#pragma mark - Limit Number of Lines

    //StackOWOflow <3
    //https://stackoverflow.com/questions/19478679/setting-maximum-number-of-lines-entry-on-uitextview
  -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *currentText = [NSMutableString stringWithString:self.noteView.text];
    [currentText replaceCharactersInRange:range withString:text];

    NSUInteger numberOfLines = 0;
    for(NSUInteger i = 0; i < currentText.length; i++) {
      if([[NSCharacterSet newlineCharacterSet] characterIsMember:[currentText characterAtIndex:i]]) {
        numberOfLines++;
      }
    }

    if(numberOfLines >= self.noteView.textContainer.maximumNumberOfLines) {
      return NO;
    }

    NSAttributedString *wrappingCheck = [[NSAttributedString alloc] initWithString:[NSMutableString stringWithString:currentText] attributes:@{NSFontAttributeName:self.noteView.font}];

    __block NSInteger lineCount = 0;
    CGFloat maxWidth = self.noteView.bounds.size.width - 10;

    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:wrappingCheck];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainerBlock, NSRange glyphRange, BOOL *stop) {
      lineCount++;
    }];

    return (lineCount <= self.noteView.textContainer.maximumNumberOfLines);
  }

#pragma mark - ToolBar

  -(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = ([self isDarkMode]) ? UIBarStyleBlack : UIBarStyleDefault;
    toolBar.tintColor = self.customTintColor;
    toolBar.items = [self toolBarButtons];
    self.noteView.inputAccessoryView = toolBar;

    return YES;
  }

  -(NSArray *)toolBarButtons {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];

    if(self.enableUndoRedo) {
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
    [self.noteView replaceRange:self.noteView.selectedTextRange withText:@"\u2022 "];
  }

  -(void)undoButton {
    if([[self.noteView undoManager] canUndo]) {
      [[self.noteView undoManager] undo];
    }
  }

  -(void)redoButton {
    if([[self.noteView undoManager] canRedo]) {
      [[self.noteView undoManager] redo];
    }
  }

  -(void)doneButton {
    [self.noteView resignFirstResponder];
  }

  -(void)textViewDidBeginEditing:(UITextView *)textView {
    _editing = YES;

    CGRect caretPosition = [self.noteView caretRectForPosition:textView.selectedTextRange.start];
    [textView scrollRectToVisible:caretPosition animated:YES];
  }

  -(void)textViewDidEndEditing:(UITextView *)textView {
    _editing = NO;
  }

#pragma mark - Loading/Saving/Backup Notes/Idle Timer Reset

  -(void)textViewDidChange:(UITextView *)textView {
    [self saveNotes];

    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
  }

  -(void)saveNotes {
    NSError *error = nil;
    NSString *notes = self.noteView.text;
    [notes writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
      NSLog(@"Libellum || Error saving notes - %@", error);
    }
  }

  -(void)loadNotes {
    NSError *error = nil;
    self.noteView.text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(error) {
      NSLog(@"Libellum || Error loading notes - %@", error);
    }
  }

  -(void)backupNotes {
    NSError *error = nil;
    NSString *notes = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    [notes writeToFile:filePathBK atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
      NSLog(@"Libellum || Error backing up notes - %@", error);
    }
  }

#pragma mark - Show/Hide Gestures

  -(void)setupGestures {
    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLibellum:)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeGesture];

    /*_edgeGesture = [[NSClassFromString(@"SBScreenEdgePanGestureRecognizer") alloc] initWithTarget:self action:@selector(toggleLibellum:) type:SBSystemGestureTypeNone options:nil];
    _edgeGesture.edges = UIRectEdgeTop;
    _edgeGesture.maximumNumberOfTouches = 1;
    [[NSClassFromString(@"FBSystemGestureManager") sharedInstance] addGestureRecognizer:_edgeGesture toDisplay:[NSClassFromString(@"FBDisplayManager") mainDisplay]];
    [[NSClassFromString(@"SBMainDisplaySystemGestureManager") sharedInstance] addGestureRecognizer:_edgeGesture withType:SBSystemGestureTypeNone];*/
  }

  -(void)toggleLibellum:(UIGestureRecognizer *)gesture {
    if(self.hideGesture && !_editing) {

      HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];

      if(self.feedback) {
        AudioServicesPlaySystemSound(self.feedbackStyle);
      }

      if(self.hidden) {
        self.hidden = NO;
        [self.superview.superview layoutSubviews];
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.transform = CGAffineTransformMakeScale(1, 1);
          self.alpha = 1;
        } completion:nil];

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
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.noteView.tintColor = self.customTintColor;
    self.blurView.effect = [UIBlurEffect effectWithStyle:self.blurStyle];

    _edgeGesture.enabled = self.useEdgeGesture;
    _swipeGesture.enabled = self.useSwipeGesture;

    if(self.blurStyle == 3) {
      self.blurView.alpha = 0;
      self.noteView.backgroundColor = self.customBackgroundColor;
    } else {
      self.blurView.alpha = 1;
      self.noteView.backgroundColor = [UIColor clearColor];
    }

    if(self.blurStyle == 7 && !self.ignoreAdaptiveColors) {
      [self tintColorDidChange];
    } else {
      self.noteView.textColor = self.customTextColor;
      self.lockIcon.tintColor = self.lockColor;
    }
  }

  -(void)tintColorDidChange {
    switch ((int)[[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle]) {
        //Light Mode
      case 1: {
        if(self.blurStyle == 7 && !self.ignoreAdaptiveColors) {
          [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.noteView.textColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor blackColor].CGColor;
          } completion:nil];
        }

        self.lockIcon.tintColor = [UIColor blackColor];
        break;
      }

        //Dark Mode
      case 2: {
        if(self.blurStyle == 7 && !self.ignoreAdaptiveColors) {
          [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.noteView.textColor = [UIColor whiteColor];
            self.layer.borderColor = [UIColor whiteColor].CGColor;
          } completion:nil];
        }

        self.lockIcon.tintColor = [UIColor whiteColor];
      break;
      }
    }
  }

  -(BOOL)isDarkMode {
    return ([[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle] == 2) ? YES : NO;
  }

@end
