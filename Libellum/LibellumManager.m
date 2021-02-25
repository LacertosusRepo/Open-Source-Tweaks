/*
 * LibellumManager.m
 * Libellum
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 1/12/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "LibellumManager.h"

@implementation LibellumManager {
  BOOL _authenticated;
  BOOL _editing;
  BOOL _atLeastiOS13;
  UIBarButtonItem *_removePageButton;
}

  +(instancetype)sharedManager {
    static LibellumManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedManager = [[LibellumManager alloc] init];
    });

    return sharedManager;
  }

  -(instancetype)init {
    if(self = [super init]) {
      _preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
      [_preferences registerPreferenceChangeBlock:^{
        [self preferencesChanged];
      }];

      if(![self.preferences boolForKey:@"checkedForOldNotes"]) {
        [self convertNotesFromPreviousVersions];
      }

      if([self.preferences boolForKey:@"noteBackup"]) {
        [self backupNotes];
      }

      _isDarkMode = ([[NSClassFromString(@"UIUserInterfaceStyleArbiter") sharedInstance] currentStyle] == 2) ?: NO;
      _atLeastiOS13 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}];
    }

    return self;
  }

#pragma mark - Page Management

-(void)createPages {
  self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{@"UIPageViewControllerOptionInterPageSpacingKey" : @10}];
  self.pageController.dataSource = self;

  [NSLayoutConstraint activateConstraints:@[
    self.heightConstraint = [self.pageController.view.heightAnchor constraintEqualToConstant:[self.preferences integerForKey:@"noteSize"]],
  ]];

  _notesByIndex = ([NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSMutableDictionary class], [NSAttributedString class], nil] fromData:[self.preferences objectForKey:@"notes"] error:nil]) ?: [[NSMutableDictionary alloc] init];
  _pages = [[NSMutableArray alloc] init];

  for(NSNumber *key in self.notesByIndex) {
    LibellumViewController *viewController = [[LibellumViewController alloc] init];
    viewController.preferences = self.preferences;
    viewController.index = [key intValue];
    viewController.text = [self.notesByIndex objectForKey:key];
    [viewController updatePreferences];

    [self.pages addObject:viewController];
  }

  if(self.notesByIndex.count == 0) {
    LibellumViewController *viewController = [[LibellumViewController alloc] init];
    viewController.preferences = self.preferences;
    viewController.index = 0;
    [viewController updatePreferences];

    [self.pages addObject:viewController];
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.pageController setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
  });

  [self disablePageScroll:NO];
  [self setupGestures];
}

  -(IBAction)addPage {
    NSInteger pageIndexToInsertAt = [self indexOfCurrentViewController] + 1;

    for(LibellumViewController *viewController in self.pages) {
      if(viewController.index >= pageIndexToInsertAt) {
        viewController.index++;
      }
    }

    LibellumViewController *viewController = [[LibellumViewController alloc] init];
    viewController.preferences = self.preferences;
    viewController.index = pageIndexToInsertAt;
    [viewController updatePreferences];
    [viewController authenticationStatus:([self.preferences boolForKey:@"requireAuthentication"]) ? _authenticated : YES];

    [self.pages insertObject:viewController atIndex:pageIndexToInsertAt];

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.pageController setViewControllers:@[self.pages[pageIndexToInsertAt]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    });

    [self disablePageScroll:NO];
  }

  -(IBAction)removePage {
    if(self.pages.count == 1) {
      return;
    }

    NSInteger pageIndexToRemove = [self indexOfCurrentViewController];
    NSInteger pageIndexToMoveTo = (pageIndexToRemove == 0) ? 0 : pageIndexToRemove - 1;

    [self.pages removeObject:[self childViewControllerAtIndex:pageIndexToRemove]];

    for(LibellumViewController *viewController in self.pages) {
      if(viewController.index > pageIndexToRemove) {
        viewController.index--;
      }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.pageController setViewControllers:@[self.pages[pageIndexToMoveTo]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    });

    [self saveNotes];
    [self disablePageScroll:NO];

    _removePageButton.enabled = (self.pages.count > 1);
  }

#pragma mark - UIPageViewController Delegate Methods

  -(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];

    NSInteger index = [(LibellumViewController *)viewController index];
    if(index == 0 || index == NSNotFound) {
      index = self.pages.count;
    }
    index--;

    return [self childViewControllerAtIndex:index];
  }

  -(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];

    NSInteger index = [(LibellumViewController *)viewController index];
    index++;
    if(index == self.pages.count) {
      index = 0;
    }

    return [self childViewControllerAtIndex:index];
  }

  -(LibellumViewController *)childViewControllerAtIndex:(NSInteger)index {
    for(LibellumViewController *viewController in self.pages) {
      if(viewController.index == index) {
        return viewController;
      }
    }

    return nil;
  }

  -(NSInteger)indexOfCurrentViewController {
    return ((LibellumViewController *)self.pageController.viewControllers[0]).index;
  }

  -(void)disablePageScroll:(BOOL)pageScroll {
    if(self.pages.count == 1) {
      pageScroll = YES;
    }

    for(UIView *view in self.pageController.view.subviews) {
      if([view isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)view).scrollEnabled = !pageScroll;
      }
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

    for(LibellumViewController *libellumViewController in self.pages) {
      [libellumViewController authenticationStatus:([self.preferences boolForKey:@"requireAuthentication"]) ? _authenticated : YES];
    }
  }

#pragma mark - UITextView Delegate Methods/Prevent Idle

    //StackOWOflow <3
    //https://stackoverflow.com/questions/19478679/setting-maximum-number-of-lines-entry-on-uitextview
  -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *currentText = [NSMutableString stringWithString:textView.text];
    [currentText replaceCharactersInRange:range withString:text];

    NSUInteger numberOfLines = 0;
    for(NSUInteger i = 0; i < currentText.length; i++) {
      if([[NSCharacterSet newlineCharacterSet] characterIsMember:[currentText characterAtIndex:i]]) {
        numberOfLines++;
      }
    }

    if(numberOfLines >= textView.textContainer.maximumNumberOfLines) {
      return NO;
    }

    NSAttributedString *wrappingCheck = [[NSAttributedString alloc] initWithString:[NSMutableString stringWithString:currentText] attributes:@{NSFontAttributeName:textView.font}];

    __block NSInteger lineCount = 0;
    CGFloat maxWidth = textView.bounds.size.width - 10;

    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:wrappingCheck];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainerBlock, NSRange glyphRange, BOOL *stop) {
      lineCount++;
    }];

    return (lineCount <= textView.textContainer.maximumNumberOfLines);
  }

  -(void)textViewDidBeginEditing:(UITextView *)textView {
    _editing = YES;
    self.activeTextView = textView;

    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];

    [self disablePageScroll:YES];
  }

  -(void)textViewDidEndEditing:(UITextView *)textView {
    _editing = NO;
    self.activeTextView = nil;

    [self saveNotes];
    [self disablePageScroll:NO];
  }

  -(void)textViewDidChange:(UITextView *)textView {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
  }

  -(void)textViewDidChangeSelection:(UITextView *)textView {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
  }

  -(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.toolBar = (self.toolBar) ?: [[UIToolbar alloc] init];
    self.toolBar.barStyle = (self.isDarkMode) ? UIBarStyleBlack : UIBarStyleDefault;
    self.toolBar.tintColor = [self getTintColor];
    [self.toolBar sizeToFit];
    [self setToolBarButtons:NO];

    textView.inputAccessoryView = self.toolBar;

    return YES;
  }

#pragma mark - UIToolbar

  -(void)setToolBarButtons:(BOOL)showPageManagement {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];

    if([self.preferences boolForKey:@"enablePageManagement"] && showPageManagement) {
      [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UITabBarMoreTemplate"] style:UIBarButtonItemStylePlain target:self action:@selector(setToolBarButtons:)]];
      [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UIRemoveControlPlus"] style:UIBarButtonItemStylePlain target:self action:@selector(addPage)]];
      [buttons addObject:_removePageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UIRemoveControlMinus"] style:UIBarButtonItemStylePlain target:self action:@selector(removePage)]];

      _removePageButton.enabled = (self.pages.count > 1);
    } else {

      if([self.preferences boolForKey:@"enableUndoRedo"]) {
        [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:(_atLeastiOS13) ? @"kb-undoHUD-undo" : @"UIButtonBarKeyboardUndo"] style:UIBarButtonItemStylePlain target:self action:@selector(undoButtonAction)]];
        [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:(_atLeastiOS13) ? @"kb-undoHUD-redo" : @"UIButtonBarKeyboardRedo"] style:UIBarButtonItemStylePlain target:self action:@selector(redoButtonAction)]];
      }

      if([self.preferences boolForKey:@"enablePageManagement"]) {
        if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){14, 0, 0}]) {
          [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UITabBarMoreTemplate"] menu:[self pageManagementMenu]]];
        } else {
          [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UITabBarMoreTemplate"] style:UIBarButtonItemStylePlain target:self action:@selector(pageManagementAction)]];
        }
      }
    }

    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    [buttons addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"UIImageNameStandaloneIndicatorDot"] style:UIBarButtonItemStylePlain target:self action:@selector(pointButtonAction)]];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction)]];

    if([self.preferences boolForKey:@"invertToolBarButtons"]) {
      buttons = [[[buttons reverseObjectEnumerator] allObjects] mutableCopy];
    }

    [self.toolBar setItems:buttons animated:YES];
  }

  -(UIMenu *)pageManagementMenu {
    UIAction *addPageAction = [UIAction actionWithTitle:@"Add Note" image:[UIImage systemImageNamed:@"rectangle.stack.fill.badge.plus"] identifier:nil handler:^(UIAction *action) {
      [self addPage];
    }];

    UIAction *removePageAction = [UIAction actionWithTitle:@"Remove Note" image:[UIImage systemImageNamed:@"rectangle.stack.fill.badge.minus"] identifier:nil handler:^(UIAction *action) {
      [self removePage];
    }];
    removePageAction.attributes = (self.pages.count > 1) ? UIMenuElementAttributesDestructive : UIMenuElementAttributesDisabled;

    return [UIMenu menuWithTitle:@"" children:@[removePageAction, addPageAction]];
  }

  -(IBAction)undoButtonAction {
    if([[self.activeTextView undoManager] canUndo]) {
      [[self.activeTextView undoManager] undo];
    }
  }

  -(IBAction)redoButtonAction {
    if([[self.activeTextView undoManager] canRedo]) {
      [[self.activeTextView undoManager] redo];
    }
  }

  -(IBAction)pageManagementAction {
    [[NSClassFromString(@"SBIdleTimerGlobalCoordinator") sharedInstance] resetIdleTimer];
    [self setToolBarButtons:YES];
  }

  -(IBAction)pointButtonAction {
    [self.activeTextView replaceRange:self.activeTextView.selectedTextRange withText:@"\u2022 "];
  }

  -(IBAction)doneButtonAction {
    [self.activeTextView resignFirstResponder];
  }

#pragma mark - Toggle Visibility

  -(void)setupGestures {
    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLibellum:)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.pageController.view addGestureRecognizer:_swipeGesture];

    //DGh0st - CornerLock
    //https://github.com/DGh0st/CornerLock
    _edgeGesture = [[NSClassFromString(@"SBScreenEdgePanGestureRecognizer") alloc] initWithTarget:self action:@selector(handleCornerPull:)];
    _edgeGesture.delegate = self;
    _edgeGesture.edges = UIRectEdgeTop;

    Class SystemGestureManager = (NSClassFromString(@"FBSystemGestureManager")) ?: NSClassFromString(@"_UISystemGestureManager");
    id displayIdentity = [[NSClassFromString(@"SBSystemGestureManager") mainDisplayManager] valueForKey:@"_displayIdentity"];
    [[SystemGestureManager sharedInstance] addGestureRecognizer:_edgeGesture toDisplayWithIdentity:displayIdentity];
  }

  -(void)handleCornerPull:(SBScreenEdgePanGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded) {
      UIInterfaceOrientation orientation = [[NSClassFromString(@"SpringBoard") sharedApplication] activeInterfaceOrientation];
      CGPoint velocity = [gesture velocityInView:nil];
      CGPoint location = [gesture locationInView:nil];

      switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
          if(velocity.y > 75 && location.y < (gesture.view.bounds.size.height / 2)) {
            [self toggleLibellum:gesture];
          }
        }
        break;

        case UIInterfaceOrientationPortraitUpsideDown:
        {
          if(fabs(velocity.y) > 75 && (gesture.view.bounds.size.height - location.y) < (gesture.view.bounds.size.height / 2)) {
            [self toggleLibellum:gesture];
          }
        }
        break;

        case UIInterfaceOrientationLandscapeRight:
        {
          if(fabs(velocity.x) > 75) {
            [self toggleLibellum:gesture];
          }
        }
        break;

        case UIInterfaceOrientationLandscapeLeft:
        {
          if(velocity.x > 75) {
            [self toggleLibellum:gesture];
          }
        }
        break;

        default:
        break;
      }
    }
  }

  -(BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGesture {
    UIInterfaceOrientation orientation = [[NSClassFromString(@"SpringBoard") sharedApplication] activeInterfaceOrientation];
    CGPoint location = [gesture locationInView:nil];

    switch (orientation) {
      case UIInterfaceOrientationPortrait:
        return location.x > (gesture.view.bounds.size.width / 4);
      break;

      case UIInterfaceOrientationPortraitUpsideDown:
        return (gesture.view.bounds.size.height - location.x) > (gesture.view.bounds.size.width / 4);
      break;

      case UIInterfaceOrientationLandscapeRight:
        return location.y > (gesture.view.bounds.size.height / 3);
      break;

      case UIInterfaceOrientationLandscapeLeft:
        return (gesture.view.bounds.size.height - location.y) > (gesture.view.bounds.size.height / 3);
      break;

      default:
      break;
    }

    return YES;
  }

  -(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture {
    SBLockScreenManager *lockScreenManager = [NSClassFromString(@"SBLockScreenManager") sharedInstance];
    BOOL mainPageVisible = (_atLeastiOS13) ? [lockScreenManager.coverSheetViewController _isMainPageShowing] : [lockScreenManager.lockScreenViewController isMainPageVisible];

    if(mainPageVisible) {
      UIInterfaceOrientation orientation = [[NSClassFromString(@"SpringBoard") sharedApplication] activeInterfaceOrientation];
      CGPoint location = [gesture locationInView:nil];
      //os_log(OS_LOG_DEFAULT, "O: %ld || LOC x: %f | y: %f || h: %f | w: %f", orientation, location.x, location.y, gesture.view.bounds.size.height, gesture.view.bounds.size.width);

      switch (orientation) {
        case UIInterfaceOrientationPortrait:
          return location.x < (gesture.view.bounds.size.width / 4);
        break;

        case UIInterfaceOrientationPortraitUpsideDown:
          return (gesture.view.bounds.size.height - location.x) < (gesture.view.bounds.size.width / 4);
        break;

        case UIInterfaceOrientationLandscapeRight:
          return location.y < (gesture.view.bounds.size.height / 3);
        break;

        case UIInterfaceOrientationLandscapeLeft:
          return (gesture.view.bounds.size.height - location.y) < (gesture.view.bounds.size.height / 3);
        break;

        default:
        break;
      }
    }

    return NO;
  }

  -(void)toggleLibellum:(UIGestureRecognizer *)gesture {
    if([self.preferences boolForKey:@"hideGesture"] && !_editing) {
      if([self.preferences boolForKey:@"feedback"]) {
        AudioServicesPlaySystemSound([self.preferences integerForKey:@"feedbackStyle"]);
      }

      if(self.pageController.view.hidden) {
        self.pageController.view.hidden = NO;
        [self forceLockScreenStackViewLayout];

        self.pageController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.pageController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.pageController.view.alpha = 1;
          } completion:nil];
        });

        [self.preferences setBool:NO forKey:@"isHidden"];
        return;

      } if(!self.pageController.view.hidden) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.pageController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
          self.pageController.view.alpha = 0;
        } completion:^(BOOL finished) {
          self.pageController.view.hidden = YES;
          [self forceLockScreenStackViewLayout];
        }];

        [self.preferences setBool:NO forKey:@"isHidden"];
        return;
      }
    }
  }

  -(void)forceLockScreenStackViewLayout {
    if([self.pageController.view.superview.superview respondsToSelector:@selector(_layoutStackView)]) {
      [self.pageController.view.superview.superview performSelector:@selector(_layoutStackView)];
    } else {
      [self.pageController.view.superview.superview layoutSubviews];
    }
  }

#pragma mark - Saving\Backing-up Note Data

  -(void)saveNotes {
    [self.notesByIndex removeAllObjects];
    for(LibellumViewController *viewController in self.pages) {
      [self.notesByIndex setObject:viewController.noteTextView.attributedText forKey:[NSNumber numberWithInt:viewController.index]];

      if(viewController.index >= (self.pages.count - 1)) {
        [self.preferences setObject:[NSKeyedArchiver archivedDataWithRootObject:self.notesByIndex requiringSecureCoding:NO error:nil] forKey:@"notes"];
      }
    }
  }

  -(void)backupNotes {
    /*NSDate *date = [NSDate date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a zzz"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];*/

    [self.preferences setObject:[self.preferences objectForKey:@"notes"] forKey:@"backupNotes"];
  }

#pragma mark - Preferences Changed

  -(void)preferencesChanged {
    self.swipeGesture.enabled = [self.preferences boolForKey:@"useSwipeGesture"];
    self.tapGesture.enabled = [self.preferences boolForKey:@"useTapGesture"];
    self.edgeGesture.enabled = [self.preferences boolForKey:@"useEdgeGesture"];
    self.heightConstraint.constant = [self.preferences integerForKey:@"noteSize"];
    [self forceLockScreenStackViewLayout];

    for(LibellumViewController *libellumViewController in self.pages) {
      [libellumViewController updatePreferences];
    }

    if(![self.preferences boolForKey:@"hideGesture"] && self.pageController.view.hidden) {
      [self toggleLibellum:nil];
    }
  }

  -(void)notifyViewControllersOfInterfaceChange:(NSInteger)style {
    self.isDarkMode = (style == 2) ?: NO;

    for(LibellumViewController *libellumViewController in self.pages) {
      [libellumViewController interfaceStyleDidChange:self.isDarkMode];
    }
  }

  -(UIColor *)getTintColor {
    if([self.preferences boolForKey:@"useKalmTintColor"]) {
      UIColor *kalmTint = [NSClassFromString(@"KalmAPI") getColor];

      if(kalmTint) {
        return kalmTint;
      }
    }

    return [UIColor PF_colorWithHex:[self.preferences objectForKey:@"customTintColor"]];
  }

#pragma mark - Misc.

  -(void)convertNotesFromPreviousVersions {
    _notesByIndex = [[NSMutableDictionary alloc] init];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSInteger numberOfConvertedNotes = 0;

      //Oldest form of notes were stored in a txt file
    if([defaultManager fileExistsAtPath:@"/User/Library/Preferences/LibellumNotes.txt"]) {
      NSString *contents = [NSString stringWithContentsOfFile:@"/User/Library/Preferences/LibellumNotes.txt" encoding:NSUTF8StringEncoding error:nil];
      NSAttributedString *newContents = [[NSAttributedString alloc] initWithString:contents attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
      [self.notesByIndex setObject:newContents forKey:[NSNumber numberWithInt:numberOfConvertedNotes]];
      [defaultManager removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.txt" error:nil];
      [defaultManager removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.bk" error:nil];

      numberOfConvertedNotes++;
    }

      //Last form of notes were stored in a rtf file
    if([defaultManager fileExistsAtPath:@"/User/Library/Preferences/LibellumNotes.rtf"]) {
      NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:@"/User/Library/Preferences/LibellumNotes.rtf"] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:nil];
      [self.notesByIndex setObject:content forKey:[NSNumber numberWithInt:numberOfConvertedNotes]];
      [defaultManager removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.rtf" error:nil];
      [defaultManager removeItemAtPath:@"/User/Library/Preferences/LibellumNotes.bk" error:nil];
    }

    [self.preferences setBool:YES forKey:@"checkedForOldNotes"];
    [self.preferences setObject:[NSKeyedArchiver archivedDataWithRootObject:self.notesByIndex requiringSecureCoding:NO error:nil] forKey:@"notes"];
  }

  -(UIView *)viewForSystemGestureRecognizer:(UIGestureRecognizer *)gesture {
    return nil;
  }
@end
