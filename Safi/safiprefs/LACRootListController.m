	//---Definitions---//
#define Switch_Color [UIColor colorWithRed:0.42 green:0.36 blue:0.91 alpha:1.0]
#define Main_Color [UIColor colorWithRed:0.42 green:0.36 blue:0.91 alpha:1.0]
#define Sec_Color [UIColor colorWithRed:0.64 green:0.61 blue:1.00 alpha:1.0]

#include "LACRootListController.h"
#import "SafiCustomHeaderClassCell.h"
#import <UIKit/UIKit.h>

@implementation LACRootListController

	- (NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}

		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
		if (section == 0) {
			return (UIView *)[[SafiCustomHeaderCell alloc] init];
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
	
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/safiprefs.bundle/github.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc]
							   initWithImage:iconBar
							   style:UIBarButtonItemStyleBordered 
                               target:self
                               action:@selector(webButtonAction)];
	
		self.navigationItem.rightBarButtonItem = webButton;
		
		[webButton release];
		
		//Adds Icon to middle of preference pane
		UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/safiprefs.bundle/navicon@2x.png"];
		icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
                     animations:^{	self.navigationItem.titleView.alpha = 1;	}
				
				completion:nil];
	
	}

	-(IBAction)webButtonAction {
	
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"]];

	}

	-(void)viewWillAppear:(BOOL)animated {
		
		[super viewWillAppear:animated];
				
			//Changed colors of Navigation Bar, Navigation Text
			self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
			self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
			self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		
		//Changes colors of Slider Filler, Switches when enabled, Segment Switches
		[UISlider appearanceWhenContainedIn:self.class, nil].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = Switch_Color;
	
		prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	
	-(void)viewWillDisappear:(BOOL)animated {
		
		[super viewWillDisappear:animated];
			
			//Returns normal colors to Navigation Bar
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
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lacertosusrepo.github.io/depictions/resources/donate.html"]];
	}

	-(void)github
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
	}

@end
