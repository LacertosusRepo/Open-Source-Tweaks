	//---Definitions---//
#define Switch_Color [UIColor colorWithRed:0.20 green:0.29 blue:0.37 alpha:1.0]
#define Main_Color [UIColor colorWithRed:0.77 green:0.79 blue:0.82 alpha:1.0]
#define Sec_Color [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0]

#include "obcRootListController.h"
#import "ObscuriteCustomHeaderClassCell.h"
#import <UIKit/UIKit.h>

@implementation obcRootListController

	- (NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}

		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
		if (section == 0) {
			return (UIView *)[[ObscuriteCustomHeaderCell alloc] init];
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
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/obscuriteprefs.bundle/navbarlogo2.png"];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc]
							   initWithImage:iconBar
							   style:UIBarButtonItemStyleBordered 
                               target:self
                               action:@selector(webButtonAction)];
	
		self.navigationItem.rightBarButtonItem = webButton;
		
		[webButton release];
		
		UIImage *icon = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/obscuriteprefs.bundle/navbarlogo.png"];
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
			self.navigationController.navigationController.navigationBar.tintColor = Main_Color;
			self.navigationController.navigationController.navigationBar.barTintColor = Sec_Color;
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
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/Lacertosus"]];
	}

	-(void)github
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
	}

@end
