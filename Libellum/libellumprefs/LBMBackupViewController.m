#import "LBMBackupViewController.h"

@implementation LBMNoteBackupViewController {
  HBPreferences *_preferences;
  UILabel *_titleLabel;
  UITextView *_textView;
  UIButton *_viewBackupButton;
  UIButton *_backupNowButton;
  UIButton *_restoreBackupButton;
  UIButton *_deleteBackupButton;
  UIButton *_closeButton;
  UIStackView *_stackView;
}

  -(instancetype)init {
    if(self = [super init]) {
      self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
      self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
      self.view.translatesAutoresizingMaskIntoConstraints = NO;

      _preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.libellumprefs"];
    }

    return self;
  }

  -(void)viewDidLoad  {
    [super viewDidLoad];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBlack];
    _titleLabel.numberOfLines = 1;
    _titleLabel.text = @"Backup Management";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel sizeToFit];

    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.scrollEnabled = YES;
    _textView.text = [NSString stringWithFormat:@"Use this menu to manage your backup of notes and to read great jokes.\n\n%@", [self randomJokes][arc4random_uniform([self randomJokes].count)]];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.translatesAutoresizingMaskIntoConstraints = NO;

    if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
      _titleLabel.textColor = [UIColor labelColor];
      _textView.textColor = [UIColor secondaryLabelColor];
      [self setModalInPresentation:YES];
    }

    _viewBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _viewBackupButton.clipsToBounds = YES;
    _viewBackupButton.backgroundColor = Pri_Color;
    _viewBackupButton.layer.cornerRadius = 5;
    _viewBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    _viewBackupButton.tintColor = [UIColor whiteColor];
    _viewBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_viewBackupButton addTarget:self action:@selector(viewBackupNotes) forControlEvents:UIControlEventTouchUpInside];
    [_viewBackupButton setTitle:@"View Backup" forState:UIControlStateNormal];

    _backupNowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backupNowButton.clipsToBounds = YES;
    _backupNowButton.backgroundColor = Pri_Color;
    _backupNowButton.layer.cornerRadius = 5;
    _backupNowButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    _backupNowButton.tintColor = [UIColor whiteColor];
    _backupNowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_backupNowButton addTarget:self action:@selector(backupNotesNow) forControlEvents:UIControlEventTouchUpInside];
    [_backupNowButton setTitle:@"Backup Now" forState:UIControlStateNormal];

    _restoreBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _restoreBackupButton.clipsToBounds = YES;
    _restoreBackupButton.backgroundColor = Pri_Color;
    _restoreBackupButton.layer.cornerRadius = 5;
    _restoreBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    _restoreBackupButton.tintColor = [UIColor whiteColor];
    _restoreBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_restoreBackupButton addTarget:self action:@selector(restoreBackupNotes) forControlEvents:UIControlEventTouchUpInside];
    [_restoreBackupButton setTitle:@"Restore from Backup" forState:UIControlStateNormal];

    _deleteBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteBackupButton.clipsToBounds = YES;
    _deleteBackupButton.backgroundColor = Pri_Color;
    _deleteBackupButton.layer.cornerRadius = 5;
    _deleteBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    _deleteBackupButton.tintColor = [UIColor whiteColor];
    _deleteBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_deleteBackupButton addTarget:self action:@selector(deleteBackupNotes) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBackupButton setTitle:@"Delete Backup" forState:UIControlStateNormal];

    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeButton.clipsToBounds = YES;
    _closeButton.backgroundColor = Pri_Color;
    _closeButton.layer.cornerRadius = 5;
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    _closeButton.tintColor = [UIColor whiteColor];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitle:@"Done" forState:UIControlStateNormal];

    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _textView, _viewBackupButton, _backupNowButton, _restoreBackupButton, _deleteBackupButton, _closeButton]];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.distribution = UIStackViewDistributionFillProportionally;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.spacing = 10;
    [self.view addSubview:_stackView];

    [NSLayoutConstraint activateConstraints:@[
      [_stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:35],
      [_stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
      [_stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
      [_stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-35],

      [_titleLabel.heightAnchor constraintEqualToConstant:50],

      [_textView.widthAnchor constraintEqualToConstant:330],
      [_textView.heightAnchor constraintEqualToConstant:150],

      [_viewBackupButton.widthAnchor constraintEqualToConstant:330],
      [_viewBackupButton.heightAnchor constraintEqualToConstant:50],

      [_backupNowButton.widthAnchor constraintEqualToConstant:330],
      [_backupNowButton.heightAnchor constraintEqualToConstant:50],

      [_restoreBackupButton.widthAnchor constraintEqualToConstant:330],
      [_restoreBackupButton.heightAnchor constraintEqualToConstant:50],

      [_deleteBackupButton.widthAnchor constraintEqualToConstant:330],
      [_deleteBackupButton.heightAnchor constraintEqualToConstant:50],

      [_closeButton.widthAnchor constraintEqualToConstant:330],
      [_closeButton.heightAnchor constraintEqualToConstant:50],
    ]];
  }

  -(void)animateTextChangeTo:(NSString *)text {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: _textView.textColor} range:(NSRange){0, attributedText.length}];

    [UIView transitionWithView:_textView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      _textView.attributedText = attributedText;
    } completion:nil];
  }

  -(IBAction)viewBackupNotes {
    NSError *error = nil;
    NSMutableString *notesContent = [[NSMutableString alloc] init];
    NSMutableDictionary *notes = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSMutableDictionary class], [NSAttributedString class], nil] fromData:[_preferences objectForKey:@"backupNotes"] error:&error];

    for(NSNumber *key in notes) {
      [notesContent appendString:[NSString stringWithFormat:@"Note #%d:\n%@\n\n", [key intValue] + 1, ((NSAttributedString *)notes[key]).string]];

      if([key intValue] == notes.count - 1) {
        [self animateTextChangeTo:notesContent];
      } else {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error viewing backed up notes:\n\n%@\n\n", error]];
      }
    }

    if(notes.count == 0) {
      [self animateTextChangeTo:@"Looks like you don't have any notes :("];
    }
  }

  -(IBAction)backupNotesNow {
    if([_preferences objectForKey:@"notes"]) {
      /*NSDate *date = [NSDate date];
      NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
      [timeFormatter setDateFormat:@"h:mm a zzz"];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MMMM d, yyyy"];*/

      [_preferences setObject:[_preferences objectForKey:@"notes"] forKey:@"backupNotes"];

      [self animateTextChangeTo:@"Backup successful!"];

    } else {
      [self animateTextChangeTo:@"There are no notes to backup."];
    }
  }

  -(IBAction)restoreBackupNotes {
    if([_preferences objectForKey:@"backupNotes"]) {
      UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Restore" message:@"Are you sure you want to restore the backup of your notes? This will delete your current notes and respring your device." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [_preferences setObject:[_preferences objectForKey:@"backupNotes"] forKey:@"notes"];
        [HBRespringController respring];
      }];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

      [cautionAlert addAction:confirmAction];
      [cautionAlert addAction:cancelAction];
      [self presentViewController:cautionAlert animated:YES completion:nil];

    } else {
      [self animateTextChangeTo:@"There is no backup to restore from."];
    }
  }

  -(IBAction)deleteBackupNotes {
    if([_preferences objectForKey:@"backupNotes"]) {
      UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete the backup of your notes?" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [_preferences removeObjectForKey:@"backupNotes"];
        [_preferences removeObjectForKey:@"notesBackupTime"];
        [self animateTextChangeTo:@"Backup deleted successfully."];
      }];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

      [cautionAlert addAction:confirmAction];
      [cautionAlert addAction:cancelAction];
      [self presentViewController:cautionAlert animated:YES completion:nil];

    } else {
      [self animateTextChangeTo:@"There is no backup to delete."];
    }
  }

  -(IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
  }

  -(NSArray *)randomJokes {
    return @[@"What do you get when you mix ducks with fireworks? Firequackers.", @"Did you hear about that great new shovel? It’s ground breaking.", @"Bazinga", @"Why should you never trust a train? They have loco motives.", @"What do you call a spanish pig? Porque."];
  }
@end
