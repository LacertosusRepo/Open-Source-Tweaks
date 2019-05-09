/*
 * StellaeController.h
 * Stellae
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/21/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "StellaeController.h"


@implementation StellaeController
  +(id)sharedInstance {
    static StellaeController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
  }

  -(id)init {
    if(self = [super init]) {
      NSLog(@"Stellae || Initalized");
    }
    return self;
  }

  -(UIImage *)getImageFromReddit:(NSString *)subredditName numberOfPostsGrabbed:(int)postsGrabbed nsfwFiltered:(BOOL)nsfwFilter currentImageURL:(NSString *)currentURL {
    NSString *finalRedditURL = [self getFinalRedditURL:subredditName numberOfPostsGrabbed:postsGrabbed];
    NSDictionary *redditJSONDictionary = [self getRedditJSONData:finalRedditURL];
    int postNumber = arc4random_uniform([redditJSONDictionary[@"data"][@"children"] count]);
    BOOL postIsNSFW = [self postIsNSFW:postNumber fromDictionary:redditJSONDictionary];

    if(nsfwFilter && postIsNSFW) {
      NSLog(@"Stellae || NSFW filter is on and post is NSFW - %d", postIsNSFW);
      return nil;
    } else {
      NSString *redditImageURL = redditJSONDictionary[@"data"][@"children"][postNumber][@"data"][@"url"];
      NSString *redditImageDomain = redditJSONDictionary[@"data"][@"children"][postNumber][@"data"][@"domain"];
      if([[self excludedProviders] containsObject:redditImageDomain] || [redditImageURL containsString:@".gif"] || redditJSONDictionary[@"data"][@"children"][postNumber][@"data"][@"is_video"]) {
        NSLog(@"Stellae || Image URL is a video/gif");
        return nil;
      } if([redditImageURL isEqualToString:currentURL] && postsGrabbed > 1) {
        NSLog(@"Stellae || Image URL is a duplicate");
        return nil;
      } if([redditImageURL containsString:@"imgur.com"] && ![redditImageURL containsString:@"i.imgur"]) {
        redditImageURL = [redditImageURL stringByAppendingString:@".jpg"];
      }

      NSString *postURL = @"https://reddit.com";
      postURL = [postURL stringByAppendingString:redditJSONDictionary[@"data"][@"children"][postNumber][@"data"][@"permalink"]];
      [self saveURL:postURL forKey:@"currentRedditURL"];
      [self saveURL:redditImageURL forKey:@"currentImageURL"];

      NSData *redditImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:redditImageURL]];
      UIImage *redditUIImage = [UIImage imageWithData:redditImageData];

      return redditUIImage;
    }

    return nil;
  }

  -(NSString *)getFinalRedditURL:(NSString *)subredditName numberOfPostsGrabbed:(int)postsGrabbed {
    if([subredditName isEqualToString:@""] || [subredditName containsString:@"r/"] || [subredditName containsString:@" "]) {
      NSLog(@"Stellae || Error with subredditName - %@", subredditName);
      subredditName = @"spaceporn";
    }

    NSString *redditURL = @"https://reddit.com/r/SUB/hot.json?limit=NUM";
    redditURL = [redditURL stringByReplacingOccurrencesOfString:@"SUB" withString:subredditName];
    redditURL = [redditURL stringByReplacingOccurrencesOfString:@"NUM" withString:[NSString stringWithFormat:@"%d", postsGrabbed]];

    return redditURL;
  }

  -(NSDictionary *)getRedditJSONData:(NSString *)redditURL {
    NSError *error = nil;
    NSURL *redditJSONURL = [NSURL URLWithString:redditURL];
    NSData *redditJSONData = [NSData dataWithContentsOfURL:redditJSONURL];
    NSDictionary *redditJSONDictionary = nil;

    if(redditJSONData != nil) {
      redditJSONDictionary = [NSJSONSerialization JSONObjectWithData:redditJSONData options:0 error:&error];
    } else {
      NSLog(@"Stellae || Error getting data - %@", error);
      return nil;
    }

    return redditJSONDictionary;
  }

  -(BOOL)postIsNSFW:(int)postNumber fromDictionary:(NSDictionary *)dictionary {
    return [dictionary[@"data"][@"children"][postNumber][@"data"][@"over_18"] boolValue];
  }

  -(void)saveURL:(NSString *)URL forKey:(NSString *)key {
    NSString *file = @"/User/Library/Preferences/com.lacertosusrepo.stellaesaveddata.plist";
    NSMutableDictionary *saveddata = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [saveddata setObject:URL forKey:key];
    [saveddata writeToFile:file atomically:YES];
  }

  -(NSArray *)excludedProviders {
    return [NSArray arrayWithObjects:@"gfycat.com", nil];
  }
@end
