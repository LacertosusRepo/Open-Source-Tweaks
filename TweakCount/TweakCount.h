@interface PSListController (TweakCount)
@property (nonatomic, retain) NSMutableDictionary *packageInfo;
-(void)insertCountSpecifiers;
-(void)hideDetailedCount:(PSSpecifier *)specifier;
-(void)showDetailedCount:(PSSpecifier *)specifier;
-(void)loadStatusFile;
-(BOOL)preferenceOrganizationTweakIsInstalled;
@end

@interface TweakSpecifiersController : PSListController
@end

@interface PSUIPrefsListController : PSListController
@end
