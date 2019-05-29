/*
 * Tweak.xm
 * Return2Sender2
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 05/28/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

#define LD_DEBUG NO

@interface CKMessageEntryRichTextView : UITextView
@end

@interface CKEntryViewButton : UIButton
@end

@interface CKMessageEntryView : UIView
@end

  CKEntryViewButton *sendButton;

%hook CKMessageEntryView
  -(id)sendButton {
    return sendButton = %orig;
  }

  -(BOOL)shouldShowAppStrip {
    return NO;
  }
%end

%hook CKMessageEntryRichTextView
  -(void)keyboardDidShow:(id)arg2 {
    self.returnKeyType = UIReturnKeySend;
    return %orig;
  }
%end

%hook CKMessageEntryContentView
-(void)textViewDidChange:(UITextView *)arg1 {
  %orig;

  if([arg1.text containsString:@"\n"]) {
    arg1.text = [arg1.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [sendButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  }
}
%end
