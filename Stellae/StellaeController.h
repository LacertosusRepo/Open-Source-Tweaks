/*
 * StellaeController.h
 * Stellae
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 3/21/2019.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */

@interface StellaeController : NSObject
+(id)sharedInstance;
-(id)init;
-(UIImage *)getImageFromReddit:(NSString *)subredditName numberOfPostsGrabbed:(int)postsGrabbed nsfwFiltered:(BOOL)nsfwFilter currentImageURL:(NSString *)currentURL;
-(NSString *)getFinalRedditURL:(NSString *)subredditName numberOfPostsGrabbed:(int)postsGrabbed;
-(NSDictionary *)getRedditJSONData:(NSString *)redditURL;
-(BOOL)postIsNSFW:(int)postNumber fromDictionary:(NSDictionary *)dictionary;
-(void)saveURL:(NSString *)URL forKey:(NSString *)key;
-(NSArray *)excludedProviders;
@end
