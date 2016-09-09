//Headers
#include "hpkRootListController.h"
#import "HaptikCustomHeaderClassCell.h"
#import "HaptikPreferencesInfo.h"

//Root Prefs
@implementation hpkRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (UIView *)[[HaptikCenterCustomHeaderCell alloc] init];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 140.f;
    }
    return (CGFloat)-1;
}

-(void)viewDidLoad {
    UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/hcprefs.bundle/navbarlogo.png"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    self.navigationItem.titleView = iconView;
    self.navigationItem.titleView.alpha = 0;

    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(increaseAlpha)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)increaseAlpha {
    [UIView animateWithDuration:3.0
                     animations:^{
			self.navigationItem.titleView.alpha = 1;
                }completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        self.navigationController.navigationController.navigationBar.tintColor = Main_Color;
        self.navigationController.navigationController.navigationBar.barTintColor = Nav_Color;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = Switch_Color;
	[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = Switch_Color;

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
	
	[[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
	
	prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)twitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"]];
}

-(void)paypal
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/Lacertosus"]];
}

-(void)github
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
}
@end

//CC Prefs
@implementation CCOptionsListController

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"CCOptions" target:self] retain];
    
	}
    return _specifiers;
}

-(void)viewDidLoad {
    UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/hcprefs.bundle/CCNavBar.png"];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    self.navigationItem.titleView = iconView;
    self.navigationItem.titleView.alpha = 0;

    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(increaseAlpha)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        self.navigationController.navigationController.navigationBar.tintColor = Main_Color;
        self.navigationController.navigationController.navigationBar.barTintColor = Nav_Color;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = Switch_Color;
	[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = Switch_Color;
	
    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)increaseAlpha {
    [UIView animateWithDuration:3.0
                     animations:^{
			self.navigationItem.titleView.alpha = 1;
                }completion:nil];
}
@end

//NC Prefs
@implementation NCOptionsListController

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"NCOptions" target:self] retain];
	
	}
    return _specifiers;

}

-(void)viewDidLoad {
    UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/hcprefs.bundle/NCNavBar.png"];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    self.navigationItem.titleView = iconView;
    self.navigationItem.titleView.alpha = 0;

    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(increaseAlpha)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        self.navigationController.navigationController.navigationBar.tintColor = Main_Color;
        self.navigationController.navigationController.navigationBar.barTintColor = Nav_Color;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = Switch_Color;
	[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = Switch_Color;
	
    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)increaseAlpha {
    [UIView animateWithDuration:3.0
                     animations:^{
			self.navigationItem.titleView.alpha = 1;
                }completion:nil];
}
@end