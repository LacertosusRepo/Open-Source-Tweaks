/*
 * Tweak.x
 * KeywordReplace
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 9/13/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Cephei/HBPreferences.h>
#define LD_DEBUG NO

@interface UITextField (MissingStuff)
@property (getter=isEditable, nonatomic, readonly) BOOL editable;
@end

  static NSDictionary *wordReplacements;

static NSString *switchKeyword(NSString *originalText) {
  for(NSString *stringToReplace in wordReplacements) {
    if([originalText containsString:stringToReplace]) {
      return [originalText stringByReplacingOccurrencesOfString:stringToReplace withString:wordReplacements[stringToReplace]];
    }
  }

  return originalText;
}

%hook UILabel
  -(void)setText:(NSString *)arg1 {
    if(arg1.length == 0) {
      %orig;
      return;
    }

    %orig(switchKeyword(arg1));
  }
%end

%hook UITextField
  -(void)setText:(NSString *)arg1 {
    if(arg1.length == 0 || self.editable) {
      %orig;
      return;
    }

    %orig(switchKeyword(arg1));
  }
%end

%hook UITextView
  -(void)setText:(NSString *)arg1 {
    if(arg1.length == 0 || self.editable) {
      %orig;
      return;
    }

    %orig(switchKeyword(arg1));
  }
%end

%ctor {
  if([[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@".app"]) {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.lacertosusrepo.keywordreplaceprefs"];
    [preferences registerObject:&wordReplacements default:nil forKey:@"wordReplacements"];

    %init;
  }
}
