@interface TweakSpecifiersController : PSListController <UISearchBarDelegate>
@property (nonatomic, assign) NSUInteger lastSearchBarTextLength;
@end

@interface AppleAppSpecifiersController : PSListController <UISearchBarDelegate>
@property (nonatomic, assign) NSUInteger lastSearchBarTextLength;
@end

@interface AppStoreAppSpecifiersController : PSListController <UISearchBarDelegate>
@property (nonatomic, assign) NSUInteger lastSearchBarTextLength;
@end

@interface UISearchController (iOS13)
@property (nonatomic, assign) BOOL dimsBackgroundDuringPresentation;
@end
