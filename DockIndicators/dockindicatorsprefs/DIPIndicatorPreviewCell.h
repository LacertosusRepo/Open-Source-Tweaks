@import Alderis;
#import "AlderisColorPicker.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "../DockIndicators.h"

@interface DIPIndicatorPreviewCell : PSTableCell
-(void)updateIndicatorPreview;
- (void)userDefaultsDidChange:(NSNotification *)notification;
@end
