/*
 * LIBNoteView.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 4/1/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#import <LocalAuthentication/LocalAuthentication.h>
#import "LIBNoteView.h"

  static NSString *filePath = @"/User/Library/Preferences/LibellumNotes.txt";

@implementation LIBNoteView
  +(id)sharedInstance {
    static LIBNoteView *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
  }

  -(id)init {
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        //UIWindow stuff
      self.windowLevel = UIWindowLevelStatusBar;
      self.userInteractionEnabled = YES;
      self.hidden = NO;

        //NoteView
      UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.8, CGRectGetWidth(self.bounds) * 0.3)];
      noteView.alpha = 1.0;
      noteView.backgroundColor = [UIColor clearColor];
      noteView.center = self.center;
      noteView.clipsToBounds = YES;
      noteView.layer.cornerRadius = 15;
      noteView.layer.zPosition = 0;
      noteView.userInteractionEnabled = YES;

        //UIBlurEffect
      UIBlurEffect *noteViewBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
      UIVisualEffectView *noteViewBlurView = [[UIVisualEffectView alloc] initWithEffect:noteViewBlur];
      noteViewBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      noteViewBlurView.frame = noteView.bounds;

        //UItextView
      UITextView *textView = [[UITextView alloc] initWithFrame:noteView.bounds];
      textView.alpha = 0; //Set to 0 until authenticated
      textView.backgroundColor = [UIColor clearColor];
      textView.clipsToBounds = YES;
      textView.contentSize = textView.bounds.size;
      textView.contentInset = UIEdgeInsetsZero;
      textView.delegate = self;
      textView.editable = YES;
      textView.font = [UIFont systemFontOfSize:12];
      textView.keyboardAppearance = UIKeyboardAppearanceDark;
      textView.scrollEnabled = NO;
      textView.textAlignment = NSTextAlignmentLeft;
      textView.textColor = [UIColor whiteColor];
      textView.textContainer.lineFragmentPadding = 0.0;
      textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
      textView.userInteractionEnabled = NO;  //Set no until authentication

        //UIGestureRecognizers
      UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
      UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
      UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];

        //Set LIBNoteView properties
      self.view = noteView;
      self.textView = textView;
      self.noteViewSavedPosition = self.view.frame;

      [self addSubview:noteView];
      [self.view addSubview:noteViewBlurView];
      [self.view addSubview:textView];
      [self.view addGestureRecognizer:panGesture];
      [self.view addGestureRecognizer:pinchGesture];
      [self.view addGestureRecognizer:tapGesture];

        //Load notes from file
      NSFileManager *fileManager = [NSFileManager defaultManager];
      if(![fileManager fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
      } else {
        [self loadNotes];
      }

      if(!CGRectIsEmpty(self.noteViewSavedPosition)) {
        noteView.frame = self.noteViewSavedPosition;
      }

        //Adjust noteView frame according to text and set last position
      if([self.textView.text length] != 0) {
        [self textViewDidChange:self.textView];
      }

        //Rotation notifications
      [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterfaceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    return self;
  }

#pragma mark - NoteView gesture/touches

  -(void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
      self.noteViewSavedPosition = self.view.frame;
    } if(gesture.state == UIGestureRecognizerStateChanged) {
      CGPoint center = self.view.center;
      CGPoint translation = [gesture translationInView:[self.view superview]];
      center = CGPointMake(center.x + translation.x,
                           center.y + translation.y);
      self.view.center = center;
      [gesture setTranslation:CGPointZero inView:self.view];
    } if(gesture.state == UIGestureRecognizerStateEnded) {
      if(!CGRectContainsPoint(self.bounds, self.view.center)) {
        [self hideNoteView];
      } else {
        self.noteViewSavedPosition = self.view.frame;
      }
    }
  }

  -(void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      if(gesture.scale < 1) {
        [self hideNoteView];
      } else {
        //spread gesture
      }
    }
  }

  -(void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    if(!_authenticated) {
      LAContext *unlockNotes = [[LAContext alloc] init];
      NSError *error = nil;
      if([unlockNotes canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [unlockNotes evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Unlock to edit your notes." reply:^(BOOL success, NSError *error) {
          if(success) {
              _authenticated = YES;
              self.textView.userInteractionEnabled = YES;
              self.textView.alpha = 1;
          } else {
            NSLog(@"Libellum || Error using biometrics - %@", error);
          }
        }];
      }
    }
  }

  -(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for(UIView *subview in self.subviews) {
      if(CGRectContainsPoint(subview.frame, point)) {
        return YES;
      }
    }
    return NO;
  }

#pragma mark - Rotation NEED TO FIX WHEN ROTATED

  -(BOOL)autorotates {
    return YES;
  }

  -(void)handleInterfaceOrientationChanged:(NSNotification *)notification {
    UIDevice *device = notification.object;
    switch(device.orientation) {
      case UIInterfaceOrientationPortrait:
      //[self rotateNoteViewWithDegrees:0];
      [self showNoteView];
      break;

      case UIInterfaceOrientationPortraitUpsideDown:
      //[self rotateNoteViewWithDegrees:180];
      [self hideNoteView];
      break;

      case UIInterfaceOrientationLandscapeLeft:
      //[self rotateNoteViewWithDegrees:-90];
      [self hideNoteView];
      break;

      case UIInterfaceOrientationLandscapeRight:
      //[self rotateNoteViewWithDegrees:90];
      [self hideNoteView];
      break;

      case UIDeviceOrientationUnknown:
      break;
      case UIDeviceOrientationFaceUp:
      break;
      case UIDeviceOrientationFaceDown:
      break;
    }
  }

  -(void)rotateNoteViewWithDegrees:(CGFloat)degrees {
    degrees = degrees * M_PI / 180;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
      self.view.transform = (CGAffineTransformMakeRotation(degrees));
      self.noteViewSavedPosition = self.view.frame;
    } completion:nil];
  }

#pragma mark - NoteTextView autoresizing and UIToolbar

  -(void)textViewDidChange:(UITextView *)textView {
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    CGSize noteTextSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)];
    CGRect noteViewFrame;

    if(noteTextSize.height > [UIScreen mainScreen].bounds.size.width) {
      noteTextSize.height = [UIScreen mainScreen].bounds.size.width;
      self.textView.scrollEnabled = YES;
    } else {
      self.textView.scrollEnabled = NO;
    }
    noteViewFrame = self.view.frame;
    noteViewFrame.size.height = noteTextSize.height;
    self.view.frame = noteViewFrame;
    self.textView.frame = self.view.bounds;

  } completion:nil];

    /*if(noteTextSize.height > CGRectGetWidth(self.bounds) * 0.3) {
      if(noteTextSize.height > CGRectGetHeight(self.bounds) * 0.5) {
        noteTextSize.height = CGRectGetHeight(self.bounds) * 0.5;
        self.textView.scrollEnabled = YES;
      }
      noteViewFrame = self.view.bounds;
      noteViewFrame.size.height = noteTextSize.height;
      self.view.frame = noteViewFrame;
      self.textView.frame = self.view.bounds;
    } if(noteTextSize.height < CGRectGetWidth(self.bounds) * 0.3) {
      noteViewFrame = self.view.bounds;
      noteViewFrame.size.height = self.bounds.size.height * 0.3;
      self.view.frame = noteViewFrame;
    }*/

    [self saveNotes];
  }

  -(void)textViewDidBeginEditing:(UITextView *)textView {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *pointButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pointButton)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.items = @[pointButton, flexibleSpace, doneButton];
    self.textView.inputAccessoryView = toolBar;
    self.isEditing = YES;
  }

  -(void)textViewDidFinishEditing:(UITextView *)textView {
    self.isEditing = NO;
  }

  -(void)pointButton {
    [self.textView replaceRange:self.textView.selectedTextRange withText:@"\u2022 "];
  }

  -(void)doneButton {
    [self.textView resignFirstResponder];
  }

#pragma mark - NoteView keyboard adjustment

  -(void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      self.view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    } completion:nil];
  }

  -(void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      self.view.frame = self.noteViewSavedPosition;
    } completion:nil];
  }

#pragma mark - NoteView showing/hiding

  -(void)showNoteView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.view.frame = self.noteViewSavedPosition;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      self.view.alpha = 1.0;
      self.userInteractionEnabled = YES;
    } completion:nil];
  }

  -(void)hideNoteView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      self.view.alpha = 0.0;
      self.userInteractionEnabled = NO;
    } completion:nil];
  }

#pragma mark - NoteView saving/loading

  -(void)saveNotes {
    NSError *error = nil;
    NSString *notes = self.textView.text;
    [notes writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
      NSLog(@"Libellum || Error saving notes - %@", error);
    }
  }

  -(void)loadNotes {
    NSError *error = nil;
    self.textView.text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(error) {
      NSLog(@"Libellum || Error loading notes - %@", error);
    }
  }
@end
