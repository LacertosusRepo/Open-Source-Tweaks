#include "KWDKeywordListController.h"

@implementation KWDKeywordListController
	-(id)init {
		self = [super init];
		if(self) {
			HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
			appearanceSettings.tintColor = Pri_Color;
			appearanceSettings.navigationBarTintColor = Sec_Color;
			appearanceSettings.navigationBarBackgroundColor = Pri_Color;
			appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
			appearanceSettings.translucentNavigationBar = NO;
			self.hb_appearanceSettings = appearanceSettings;
			self.title = @"";

			HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.keywordreplaceprefs"];
			_wordReplacements = ([[preferences objectForKey:@"wordReplacements"] mutableCopy]) ?: [[NSMutableDictionary alloc] init];
		}

		return self;
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			NSMutableArray *keywordSpecifiers = [[NSMutableArray alloc] init];
			PSSpecifier *groupSpecifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			[groupSpecifier setProperty:@"Swipe to delete keywords and their replacements." forKey:@"footerText"];
			[keywordSpecifiers addObject:groupSpecifier];

			for(NSString *keyword in _wordReplacements) {
				PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
				[specifier setProperty:@YES forKey:@"enabled"];
				[specifier setProperty:[KWDKeywordTextCell class] forKey:@"cellClass"];
				[specifier setProperty:keyword forKey:@"keyword"];
				[specifier setProperty:_wordReplacements[keyword] forKey:@"replacement"];
				[keywordSpecifiers addObject:specifier];
			}

			_specifiers = [keywordSpecifiers copy];
		}

		return _specifiers;
	}

	-(void)addKeyword {
		PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
		[specifier setProperty:@YES forKey:@"enabled"];
		[specifier setProperty:[KWDKeywordTextCell class] forKey:@"cellClass"];
		[specifier setProperty:@"" forKey:@"keyword"];
		[specifier setProperty:@"" forKey:@"replacement"];
		[self insertSpecifier:specifier atIndex:1 animated:YES];
	}

		//Basically deleteKeyword
	-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if(editingStyle == UITableViewCellEditingStyleDelete) {
			PSSpecifier *specifierToBeRemoved = [self specifierAtIndexPath:indexPath];
			[self removeSpecifier:specifierToBeRemoved animated:YES];

			[_wordReplacements removeObjectForKey:[specifierToBeRemoved propertyForKey:@"keyword"]];

			[self saveKeywords];
		}
	}

	-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		return YES;
	}

	-(void)saveKeywords {
		for(PSSpecifier *specifier in _specifiers) {
			if([[specifier propertyForKey:@"keyword"] length] > 0 && [[specifier propertyForKey:@"replacement"] length] > 0) {
				[_wordReplacements setObject:[specifier propertyForKey:@"replacement"] forKey:[specifier propertyForKey:@"keyword"]];
			}
		}

		HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.lacertosusrepo.keywordreplaceprefs"];
		[preferences setObject:_wordReplacements forKey:@"wordReplacements"];
	}

	-(void)_keyboardWillHide:(id)notification {
		[self saveKeywords];
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11, 0, 0}]) {
			self.navigationController.navigationBar.prefersLargeTitles = NO;
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}

		[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addKeyword)] animated:YES];
	}

	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];

		//Adds label to center of preferences
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.text = @"Keywords";
		title.textAlignment = NSTextAlignmentCenter;
		title.textColor = Sec_Color;
		title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
		self.navigationItem.titleView = title;
		self.navigationItem.titleView.alpha = 0;

		[UIView animateWithDuration:0.2 animations:^{
			self.navigationItem.titleView.alpha = 1;
		}];
	}
@end
