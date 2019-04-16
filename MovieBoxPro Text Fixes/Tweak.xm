/*
 * Tweak.xm
 * MovieBoxProTextFixes
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 4/16/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

  static NSDictionary *labelReplacements = @{
      //Featured corrections
    @"Maybe Like Movie" : @"Movies You Might Like",
    @"Continue Play" : @"Continue Watching",
    @"Today Hot Movie" : @"Todays Hot Movies",
    @"This Week Hot Movie" : @"This Weeks Hot Movies",
    @"Today Hot TV" : @"Todays Hot TV Shows",
    @"This Week Hot TV" : @"This Weeks Hot TV Shows",
    @"IMDB Rating Movie" : @"Highly Rated Movies by IMDB",
    @"Latest Upload Movie" : @"Recently Uploaded Movies",
    @"Latest Update TV" : @"Recently Updated TV Shows",
    @"Action Movie" : @"Action Movies",
    @"Adventure Movie" : @"Adventure Movies",
    @"Sci-fi Movie" : @"Sci-fi Movies",
      //Movielist corrections
    @"My collect" : @"My Collection",
    @"Day Hot List" : @"Todays Hot Lists",
    @"Week Hot List" : @"This Weeks Hot Lists",
    @"Latest List" : @"New Lists",
      //Tab corrections
    @"MOVIELIST" : @"MOVIE LISTS",
    @"FAVORITE" : @"FAVORITES",
      //Misc
    @"WEEK" : @"THIS WEEK",
  };

%hook UILabel
  -(void)setText:(NSString *)arg1 {
    if(labelReplacements[arg1]) {
      arg1 = labelReplacements[arg1];
      if([arg1 isEqualToString:@"MOVIE LISTS"] || [arg1 isEqualToString:@"FAVORITES"]) {
        self.textColor = [UIColor whiteColor];
      }
    }
    %orig(arg1);
  }
%end
