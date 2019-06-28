enum redditApps {
  safari = 0,
  apollo,
  reddit,
  narwhal,
};

@interface SPUISearchHeader : UIView
@property (nonatomic, readonly) NSString *currentQuery;
@end
