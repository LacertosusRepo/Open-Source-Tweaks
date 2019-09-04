/*
 * Tweak.xm
 * FreeMarket
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 9/4/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
@interface AppStoreDynamicTypeLabel : UILabel
@property (nonatomic, copy, readwrite) NSString *text;
@end

%hook AppStoreDynamicTypeLabel
  -(void)setFont:(id)arg1 {
    %orig;

    AppStoreDynamicTypeLabel *letsGetSwifty = self;
    if([letsGetSwifty.text isEqualToString:@"GET"]) {
      letsGetSwifty.text = @"FREE";
    }
  }
%end

%ctor {
  %init(_ungrouped, AppStoreDynamicTypeLabel = NSClassFromString(@"AppStore.DynamicTypeLabel"));
}
