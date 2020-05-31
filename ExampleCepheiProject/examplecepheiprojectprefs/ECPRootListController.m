#include "ECPRootListController.h"

@implementation ECPRootListController
	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		}

		return _specifiers;
	}

		//Add respring method that we call with a PSButtonCell in our root.plist
	-(void)respringMethod {
		[HBRespringController respring];
	}
@end
