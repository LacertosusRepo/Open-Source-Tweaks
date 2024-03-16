#include "DIPRootListController.h"

@implementation DIPRootListController

	-(id)init {
		self = [super init];
		if(self) {
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			NSArray *chosenIDs = @[@"SetIndicatorColor"];
			self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
			for(PSSpecifier *specifier in _specifiers) {
				if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
					[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
				}
			}
		}

		return _specifiers;
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		[super setPreferenceValue:value specifier:specifier];

		NSString *key = [specifier propertyForKey:@"key"];
		if([key isEqualToString:@"indicatorUseAppColor"]) {
			if([value boolValue]) {
				[self removeSpecifier:self.savedSpecifiers[@"SetIndicatorColor"] animated:YES];
			} else {
				[self insertSpecifier:self.savedSpecifiers[@"SetIndicatorColor"] afterSpecifierID:@"UseAppAverageColor" animated:YES];
			}
		}
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.lacertosusrepo.dockindicatorsprefs"];
		if([[preferences objectForKey:@"indicatorUseAppColor"] boolValue]) {
			[self removeSpecifier:self.savedSpecifiers[@"SetIndicatorColor"] animated:YES];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		[self respringApply];
		[self reloadSpecifiers];

		//Adds header to table
		UIView *header = [[DIPHeaderView alloc] init];
		header.frame = CGRectMake(0, 0, header.bounds.size.width, 175);
		UITableView *tableView = [self valueForKey:@"_table"];
		tableView.tableHeaderView = header;
	}

	-(void)respringApply {
		_respringApplyButton = (_respringApplyButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
		_respringApplyButton.tintColor = Pri_Color;
		[self.navigationItem setRightBarButtonItem:_respringApplyButton animated:YES];
	}

	-(void)respringConfirm {
		if([self.navigationItem.rightBarButtonItem isEqual:_respringConfirmButton]) {
			[self respring];
		} else {
			_respringConfirmButton = (_respringConfirmButton) ?: [[UIBarButtonItem alloc] initWithTitle:@"Are you sure?" style:UIBarButtonItemStyleDone target:self action:@selector(respringConfirm)];
			_respringConfirmButton.tintColor = [UIColor colorWithRed:0.90 green:0.23 blue:0.23 alpha:1.00];
			[self.navigationItem setRightBarButtonItem:_respringConfirmButton animated:YES];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self respringApply];
			});
		}
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Dock Indicators";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Pri_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;

		[UIView animateWithDuration:0.2 animations:^{
				self.navigationItem.titleView.alpha = 1;
			}];
	}

	-(void)clearColorCache {
		NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.lacertosusrepo.dockindicatorsprefs"];
		[preferences removeObjectForKey:@"appColorCache"];

		[self respring];
	}

	- (void)minimizeSettings {
		UIApplication *app = [UIApplication sharedApplication];
		[app performSelector:@selector(suspend)];
	}

	- (void)terminateSettingsUsingBKS {
		pid_t pid;
		const char* args[] = {"sbreload", NULL};
		posix_spawn(&pid, ROOT_PATH("/usr/bin/sbreload"), NULL, NULL, (char* const*)args, NULL);
	}

	- (void)terminateSettingsAfterDelay:(NSTimeInterval)delay {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self terminateSettingsUsingBKS];
		});
	}
	- (void)respring {
		[self minimizeSettings];
		[self terminateSettingsAfterDelay:0.5];
	}

@end
