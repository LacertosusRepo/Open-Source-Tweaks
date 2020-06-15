#import "LBMBackupViewController.h"

@implementation LBMNoteBackupViewController {
  UIView *_backgroundView;
  UILabel *_titleLabel;
  UITextView *_textView;
  UIButton *_viewBackupButton;
  UIButton *_backupNowButton;
  UIButton *_restoreBackupButton;
  UIButton *_deleteBackupButton;
  UIButton *_closeButton;
  UIImageView *_notADuckImage;
  AVAudioPlayer *_notAQuack;
}

  -(instancetype)init {
    if(self = [super init]) {
      self.view.translatesAutoresizingMaskIntoConstraints = NO;

      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:@"plattersDark" inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
        materialView.recipe = 1;
        materialView.recipeDynamic = YES;
        _backgroundView = materialView;
      } else {
        _backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
      }
      _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_backgroundView];

      UILongPressGestureRecognizer *dontLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(duckify)];
      dontLongPress.minimumPressDuration = 8;

      _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      _titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBlack];
      _titleLabel.numberOfLines = 1;
      _titleLabel.text = @"Backup Management";
      _titleLabel.textAlignment = NSTextAlignmentCenter;
      _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
      _titleLabel.userInteractionEnabled = YES;
      [_titleLabel sizeToFit];
      [_titleLabel addGestureRecognizer:dontLongPress];
      [self.view addSubview:_titleLabel];

      _textView = [[UITextView alloc] initWithFrame:CGRectZero];
      _textView.backgroundColor = [UIColor clearColor];
      _textView.editable = NO;
      _textView.font = [UIFont systemFontOfSize:14];
      _textView.scrollEnabled = YES;
      _textView.textAlignment = NSTextAlignmentLeft;
      _textView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_textView];
      [self lastBackupUpText];

      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        _titleLabel.textColor = [UIColor labelColor];
        _textView.textColor = [UIColor secondaryLabelColor];
        [self setModalInPresentation:YES];
      }

      _viewBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _viewBackupButton.clipsToBounds = YES;
      _viewBackupButton.backgroundColor = [UIColor colorWithRed:0.39 green:0.27 blue:0.47 alpha:1.00];
      _viewBackupButton.layer.cornerRadius = 5;
      _viewBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _viewBackupButton.tintColor = [UIColor whiteColor];
      _viewBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_viewBackupButton addTarget:self action:@selector(viewBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_viewBackupButton setTitle:@"View Notes Backup" forState:UIControlStateNormal];
      [self.view addSubview:_viewBackupButton];

      _backupNowButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _backupNowButton.clipsToBounds = YES;
      _backupNowButton.backgroundColor = [UIColor colorWithRed:0.39 green:0.27 blue:0.47 alpha:1.00];
      _backupNowButton.layer.cornerRadius = 5;
      _backupNowButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _backupNowButton.tintColor = [UIColor whiteColor];
      _backupNowButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_backupNowButton addTarget:self action:@selector(backupNotesNow) forControlEvents:UIControlEventTouchUpInside];
      [_backupNowButton setTitle:@"Backup Notes Now" forState:UIControlStateNormal];
      [self.view addSubview:_backupNowButton];

      _restoreBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _restoreBackupButton.clipsToBounds = YES;
      _restoreBackupButton.backgroundColor = [UIColor colorWithRed:0.39 green:0.27 blue:0.47 alpha:1.00];
      _restoreBackupButton.layer.cornerRadius = 5;
      _restoreBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _restoreBackupButton.tintColor = [UIColor whiteColor];
      _restoreBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_restoreBackupButton addTarget:self action:@selector(restoreBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_restoreBackupButton setTitle:@"Restore Notes From Backup" forState:UIControlStateNormal];
      [self.view addSubview:_restoreBackupButton];

      _deleteBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _deleteBackupButton.clipsToBounds = YES;
      _deleteBackupButton.backgroundColor = [UIColor colorWithRed:0.39 green:0.27 blue:0.47 alpha:1.00];
      _deleteBackupButton.layer.cornerRadius = 5;
      _deleteBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _deleteBackupButton.tintColor = [UIColor whiteColor];
      _deleteBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_deleteBackupButton addTarget:self action:@selector(deleteBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_deleteBackupButton setTitle:@"Delete Notes Backup" forState:UIControlStateNormal];
      [self.view addSubview:_deleteBackupButton];

      _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _closeButton.clipsToBounds = YES;
      _closeButton.backgroundColor = [UIColor colorWithRed:0.39 green:0.27 blue:0.47 alpha:1.00];
      _closeButton.layer.cornerRadius = 5;
      _closeButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _closeButton.tintColor = [UIColor whiteColor];
      _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
      [_closeButton setTitle:@"Done" forState:UIControlStateNormal];
      [self.view addSubview:_closeButton];

      UIStackView *_stackViewButtons = [[UIStackView alloc] initWithArrangedSubviews:@[_viewBackupButton, _backupNowButton, _restoreBackupButton, _deleteBackupButton, _closeButton]];
      _stackViewButtons.alignment = UIStackViewAlignmentCenter;
      _stackViewButtons.axis = UILayoutConstraintAxisVertical;
      _stackViewButtons.distribution = UIStackViewDistributionFill;
      _stackViewButtons.spacing = 15;
      _stackViewButtons.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_stackViewButtons];

      UIStackView *_stackViewText = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _textView]];
      _stackViewText.alignment = UIStackViewAlignmentCenter;
      _stackViewText.axis = UILayoutConstraintAxisVertical;
      _stackViewText.distribution = UIStackViewDistributionFill;
      _stackViewText.spacing = 30;
      _stackViewText.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_stackViewText];

      UITapGestureRecognizer *dontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quack)];
      dontTap.numberOfTapsRequired = 1;

      _notADuckImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LibellumPrefs.bundle/inconspicuous.png"]];
      _notADuckImage.alpha = 0;
      _notADuckImage.translatesAutoresizingMaskIntoConstraints = NO;
      _notADuckImage.userInteractionEnabled = YES;
      [_notADuckImage addGestureRecognizer:dontTap];
      [self.view addSubview:_notADuckImage];

      [NSLayoutConstraint activateConstraints:@[
        [_stackViewText.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:30],
        [_stackViewText.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_stackViewText.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_stackViewText.bottomAnchor constraintEqualToAnchor:_stackViewButtons.topAnchor constant:-15],

        [_backgroundView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [_backgroundView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],

        [_textView.widthAnchor constraintEqualToConstant:330],
        [_textView.heightAnchor constraintEqualToConstant:180],

        [_stackViewButtons.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_stackViewButtons.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_stackViewButtons.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30],

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

        [_notADuckImage.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [_notADuckImage.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_notADuckImage.widthAnchor constraintEqualToConstant:100],
        [_notADuckImage.heightAnchor constraintEqualToConstant:109],
      ]];
    }

    return self;
  }

  -(void)animateTextChangeTo:(id)text {
    NSMutableAttributedString *attributedText;
    if([text isKindOfClass:[NSString class]]) {
      attributedText = [[NSMutableAttributedString alloc] initWithString:text];
      [attributedText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} range:(NSRange){0, attributedText.length}];
    } else {
      attributedText = text;
    }

    [attributedText addAttributes:@{NSForegroundColorAttributeName: _textView.textColor} range:(NSRange){0, attributedText.length}];

    [UIView transitionWithView:_textView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      _textView.attributedText = attributedText;
    } completion:nil];
  }

  -(void)lastBackupUpText {
    if([[NSFileManager defaultManager] fileExistsAtPath:filePathBK]) {
      NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathBK error:nil];
      NSDate *lastModified = [fileAttributes objectForKey:NSFileModificationDate];
      NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
      [timeFormatter setDateFormat:@"h:mm a zzz"];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MMMM d, yyyy"];

      [self animateTextChangeTo:[NSString stringWithFormat:@"You last backed up your notes on %@ at %@.", [dateFormatter stringFromDate:lastModified], [timeFormatter stringFromDate:lastModified]]];
    } else {
      [self animateTextChangeTo:@"Your notes have never been backed up."];
    }
  }

  -(IBAction)viewBackupNotes {
    NSError *error = nil;
    NSMutableAttributedString *backupContent = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePathBK] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
    if(error) {
      [self animateTextChangeTo:[NSString stringWithFormat:@"Error viewing backed up notes:\n\n%@\n\nThere is no backup of your notes.", error]];
    } else {
      [self animateTextChangeTo:backupContent];
    }
  }

  -(IBAction)backupNotesNow {
    NSError *error = nil;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
    NSData *data = [content dataFromRange:(NSRange){0, content.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
    [data writeToFile:filePathBK atomically:YES];

    if(error) {
      [self animateTextChangeTo:[NSString stringWithFormat:@"Error backing up notes:\n\n%@", error]];
    } else {
      [self lastBackupUpText];
    }
  }

  -(IBAction)restoreBackupNotes {
    UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Restore" message:@"Are you sure you want to restore the backup of your notes? This will delete your current notes and respring your device." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      NSError *error = nil;
      NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePathBK] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
      NSData *data = [content dataFromRange:(NSRange){0, content.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
      [data writeToFile:filePath atomically:YES];
      if(error) {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error restoring backed up notes:\n\n%@", error]];
      } else {
        [HBRespringController respring];
      }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [cautionAlert addAction:confirmAction];
    [cautionAlert addAction:cancelAction];
    [self presentViewController:cautionAlert animated:YES completion:nil];
  }

  -(IBAction)deleteBackupNotes {
    UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete the backup of your notes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      NSError *error = nil;
      [[NSFileManager defaultManager] removeItemAtPath:filePathBK error:&error];
      if(error) {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error deleting backed up notes:\n\n%@", error]];
      } else {
        [self animateTextChangeTo:@"Backup deleted successfully."];
      }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [cautionAlert addAction:confirmAction];
    [cautionAlert addAction:cancelAction];
    [self presentViewController:cautionAlert animated:YES completion:nil];
  }

  -(IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
  }

  -(void)duckify {
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      _notADuckImage.alpha = 1;
    } completion:nil];

    _titleLabel.text = @"Duck Management";

    [_viewBackupButton setTitle:@"View Duck Backup" forState:UIControlStateNormal];
    [_backupNowButton setTitle:@"Backup Ducks Now" forState:UIControlStateNormal];
    [_restoreBackupButton setTitle:@"Restore Ducks From Backup" forState:UIControlStateNormal];
    [_deleteBackupButton setTitle:@"Delete Ducks Backup" forState:UIControlStateNormal];
    [_closeButton setTitle:@"Duck" forState:UIControlStateNormal];

    [self animateTextChangeTo:@"You last backed up your duck today."];
  }

  -(void)quack {
    if(_notADuckImage.alpha == 1) {
      if(!_notAQuack) {
          _notAQuack = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@"/Library/PreferenceBundles/LibellumPrefs.bundle/inconspicuoussound.mp3"] error:nil];
          [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryAmbient" error:nil];
      }

      [_notAQuack play];
    }
  }
@end
