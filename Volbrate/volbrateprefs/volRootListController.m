		//---Definitions---//
#define Switch_Color [UIColor colorWithRed:0.25 green:0.76 blue:0.50 alpha:1.0]
#define Main_Color [UIColor colorWithRed:0.25 green:0.76 blue:0.50 alpha:1.0]
#define Sec_Color [UIColor colorWithRed:0.58 green:0.91 blue:0.75 alpha:1.0]

#include "volRootListController.h"
#import "VolbrateCustomHeaderClassCell.h"
#import <UIKit/UIKit.h>

@implementation volRootListController

	-(NSArray *)specifiers {
	
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}

	return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
		if (section == 0) {
			return (UIView *)[[VolbrateCustomHeaderCell alloc] init];
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
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/volbrateprefs.bundle/navlogo.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc]
							   initWithImage:iconBar
							   style:UIBarButtonItemStyleBordered 
                               target:self
                               action:@selector(webButtonAction)];
	
		self.navigationItem.rightBarButtonItem = webButton;
		
		[webButton release];
		
		[super viewDidLoad];
	
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
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/Lacertosus"]];
	}

	-(void)github
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
	}
@end
