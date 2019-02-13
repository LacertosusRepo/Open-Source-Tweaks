// Based on CPDigitalDarkroom's CloudtoButt
// https://github.com/CPDigitalDarkroom/TweakBattles/blob/master/cloudtobutt

%hook UILabel
  -(void)setText:(NSString *)arg1 {
      //Featured corrections
    //arg1 = [arg1 stringByReplacingOccurrencesOfString:@"0000" withString:@"0000"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Maybe Like Movie" withString:@"Movies You Might Like"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Continue Play" withString:@"Continue Watching"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Today Hot Movie" withString:@"Todays Hot Movies"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"This Week Hot Movie" withString:@"This Weeks Hot Movies"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Today Hot TV" withString:@"Todays Hot Shows"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"This Week Hot TV" withString:@"This Weeks Hot Shows"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"IMDB Rating Movie" withString:@"Highly Rated Movies by IMDB"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Latest Upload Movie" withString:@"Recently Uploaded Movies"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Latest Update TV" withString:@"Recently Updated Shows"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Action Movie" withString:@"Action Movies"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Adventure Movie" withString:@"Adventure Movies"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Sci-fi Movie" withString:@"Sci-fi Movies"];
      //Movielist corrections
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Mine" withString:@"Your Lists"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Hot List" withString:@"Hot Lists"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Latest List" withString:@"New Lists"];
      //Misc corrections
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Update This Week" withString:@"Updated This Week"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"No Download Movie" withString:@"No Downloads"];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Expire Date" withString:@"Expiration Date"];
    %orig(arg1);
  }
%end

%hook _UINavigationBarContentView
  -(void)setTitle:(NSString *)arg1 {
      //tab corrections
    if([arg1 isEqualToString:@"FAVORITE"]) {
      %orig(@"FAVORITES");
    } else if([arg1 isEqualToString:@"DOWNLOAD"]) {
      %orig(@"DOWNLOADS");
    } else {
      %orig(arg1);
    }
  }
%end
