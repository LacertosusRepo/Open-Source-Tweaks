/*
 * LibellumView.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 7/15/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "LibellumView.h"

  static NSString *filePath = @"/User/Library/Preferences/LibellumNotes.txt";

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
    self = [super initWithFrame:frame];

    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.cornerRadius;
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.blurStyle]];
    self.blurView.frame = self.bounds;
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;

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
    self.noteView.textColor = self.customTextColor;
    self.noteView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.noteView.translatesAutoresizingMaskIntoConstraints = NO;

    if(self.blurStyle == 3) {
      self.blurView.alpha = 0;
      self.noteView.backgroundColor = self.customBackgroundColor;
    }

    [self addSubview:self.blurView];
    [self addSubview:self.noteView];

    [NSLayoutConstraint activateConstraints:@[
      [self.blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.blurView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

      [self.noteView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.noteView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.noteView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.noteView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
    ]];

    [self setNumberOfLines];
    [self loadNotes];

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
        self.noteView.textColor = self.customTextColor;
      } else {
        self.noteView.userInteractionEnabled = NO;
        self.noteView.textColor = [UIColor clearColor];
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

#pragma mark - +/Done Button

  -(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pointButton)],
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)],
    ];

    self.noteView.inputAccessoryView = toolBar;

    return YES;
  }

  -(void)textViewDidBeginEditing:(UITextView *)textView {
    _editing = YES;
  }

  -(void)textViewDidEndEditing:(UITextView *)textView {
    _editing = NO;
  }

  -(void)pointButton {
    [self.noteView replaceRange:self.noteView.selectedTextRange withText:@"\u2022 "];
  }

  -(void)doneButton {
    [self.noteView resignFirstResponder];
  }

#pragma mark - Loading/Saving Notes

  -(void)textViewDidChange:(UITextView *)textView {
    [self saveNotes];
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

#pragma mark - Show/Hide

  -(void)toggleLibellum {
    if(self.hideGesture && !_editing) {

      if(self.feedback) {
        AudioServicesPlaySystemSound(self.feedbackStyle);
      }

      if(self.hidden) {
        [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.alpha = 1;
          self.hidden = NO;
        } completion:nil];
        return;

      } if(!self.hidden) {
        [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.alpha = 0;
        } completion:^(BOOL finished){
          self.hidden = YES;
        }];
        return;
      }
    }
  }

#pragma mark - Preferences Changed

  -(void)preferencesChanged {
    self.layer.cornerRadius = self.cornerRadius;
    self.blurView.effect = [UIBlurEffect effectWithStyle:self.blurStyle];
    self.noteView.textColor = self.customTextColor;

    if(self.blurStyle == 3) {
      self.blurView.alpha = 0;
      self.noteView.backgroundColor = self.customBackgroundColor;
    } else {
      self.blurView.alpha = 1;
      self.noteView.backgroundColor = [UIColor clearColor];
    }
  }

#pragma mark - Misc

  -(void)setSizeToMimic:(CGSize)size {
    NSLog(@"Libellum || I caught a crash! (w - %f, h - %f)", size.width, size.height);
  }

  -(CGSize)sizeToMimic {
    return self.frame.size;
  }
@end
