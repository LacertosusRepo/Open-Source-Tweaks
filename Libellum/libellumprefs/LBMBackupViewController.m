#import "LBMBackupViewController.h"
#import <rootless.h>
#include <spawn.h>

@implementation LBMNoteBackupViewController {
  NSUserDefaults *_preferences;
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

      _preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.lacertosusrepo.libellumprefs"];
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

- (IBAction)viewBackupNotes {
    NSData *backupData = [_preferences objectForKey:@"backupNotes"];
    if (!backupData) {
        [self animateTextChangeTo:@"There is no backup to show."];
        return;
    }

    NSError *error = nil;
    NSMutableString *notesContent = [[NSMutableString alloc] init];

    // Include NSNumber in the set of allowed classes
    NSSet *allowedClasses = [NSSet setWithObjects:[NSMutableDictionary class], [NSAttributedString class], [NSNumber class], nil];
    NSMutableDictionary *notes = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:backupData error:&error];

    if (error) {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error viewing backed up notes:\n\n%@\n\n", error]];
        return;
    }

    if (notes.count == 0) {
        [self animateTextChangeTo:@"Looks like you don't have any notes :("];
        return;
    }

    // Ensure the order of the notes if necessary by sorting the keys
    NSArray *sortedKeys = [[notes allKeys] sortedArrayUsingSelector: @selector(compare:)];

    for (NSNumber *key in sortedKeys) {
        NSAttributedString *note = notes[key];
        if (note) {
            [notesContent appendString:[NSString stringWithFormat:@"Note #%ld:\n%@\n\n", (long)[key integerValue] + 1, note.string]];
        }
    }

    [self animateTextChangeTo:notesContent];
}


-(IBAction)backupNotesNow {
    NSData *notesData = [_preferences objectForKey:@"notes"];

    if(notesData) {
      LOGS(@"Starting backup of notes. Size of notes data: %lu bytes", (unsigned long)[notesData length]);

      [_preferences setObject:notesData forKey:@"backupNotes"];
      BOOL syncSuccess = [_preferences synchronize];  // Synchronize is not typically needed but can be used to force immediate save.

      if (syncSuccess) {
        LOGS(@"Backup successful.");
        [self animateTextChangeTo:@"Backup successful!"];
      } else {
        LOGS(@"Failed to synchronize after backup.");
        [self animateTextChangeTo:@"Failed to backup notes. Please try again."];
      }
    } else {
      LOGS(@"There are no notes to backup.");
      [self animateTextChangeTo:@"There are no notes to backup."];
    }
}

-(IBAction)restoreBackupNotes {
    NSData *backupNotesData = [_preferences objectForKey:@"backupNotes"];

    if (backupNotesData) {
        LOGS(@"Backup data found. Size of backup data: %lu bytes", (unsigned long)[backupNotesData length]);
        UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Restore" message:@"Are you sure you want to restore the backup of your notes? This will delete your current notes and respring your device." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [_preferences setObject:backupNotesData forKey:@"notes"];
            BOOL syncSuccess = [_preferences synchronize]; // Synchronize to ensure the data is saved immediately.

            if (syncSuccess) {
                NSData *restoredNotesData = [_preferences objectForKey:@"notes"];
                LOGS(@"Notes restored from backup successfully. Data size after restore: %lu bytes", (unsigned long)[restoredNotesData length]);
                [self respring];
            } else {
                LOGS(@"Failed to synchronize after restoring backup.");
                [self animateTextChangeTo:@"Failed to restore notes. Please try again."];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

        [cautionAlert addAction:confirmAction];
        [cautionAlert addAction:cancelAction];
        [self presentViewController:cautionAlert animated:YES completion:nil];

    } else {
        LOGS(@"There is no backup to restore from.");
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

- (void)minimizeSettings {
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
}

	- (void)terminateSettingsUsingBKS {
		pid_t pid;
		const char* args[] = {"sbreload", NULL};
		posix_spawn(&pid, ROOT_PATH("/usr/bin/sbreload"), NULL, NULL, (char* const*)args, NULL);
	}

- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self terminateSettingsUsingBKS];
    });
}
- (void)respring {
    [self minimizeSettings];
    [self terminateSettingsAfterDelay:0.1];
}

@end
