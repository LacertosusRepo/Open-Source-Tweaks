#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <HBLog.h>

#import "TweakCount.h"

%hook PSListController
%property(nonatomic, retain) NSMutableDictionary *packageInfo;

  -(void)viewDidLoad {
    [self loadStatusFile];

    %orig;

    [self insertCountSpecifiers];
  }

  -(void)reloadSpecifiers {
    %orig;

    if(![self specifierForID:@"TWEAK_COUNT_GROUP"]) {
      [self insertCountSpecifiers];
    }
  }

%new
  -(void)insertCountSpecifiers {
    PSSpecifier *groupSpecifier = [PSSpecifier emptyGroupSpecifier];
    [groupSpecifier setProperty:@"TWEAK_COUNT_GROUP" forKey:@"id"];

    NSString *installedTweakCount = [NSString stringWithFormat:@"%d Tweaks Installed", [self.packageInfo[@"Tweaks"] intValue]];
    PSSpecifier *tweakCountSpecifier = [PSSpecifier preferenceSpecifierNamed:installedTweakCount target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
    tweakCountSpecifier->action = @selector(showDetailedCount:);

      /*
       * What a confusing mess...
       * If the instance of PSListController is the main PSUIPrefsListController page & TweakSpecifiersController doesnt exist, insert specifiers.
       * Alternatively if no preference bundles are present, insert the count specifier beneath the apple account specifier.
       *
       * Otherwise if the instance of PSListController is TweakSpecifiersController, insert count specifier at the top of the page.
       */
    if([self isMemberOfClass:[%c(PSUIPrefsListController) class]] && !%c(TweakSpecifiersController)) {
      BOOL specifiersInserted = NO;
      for(PSSpecifier *specifier in self.specifiers) {
        if([specifier.properties count] == 1) {

          NSInteger group;
          if([self getGroup:&group row:nil ofSpecifier:specifier]) {
            [self insertContiguousSpecifiers:@[groupSpecifier, tweakCountSpecifier] atEndOfGroup:group - 1];
            specifiersInserted = YES;
          }

          break;
        }
      }

      if(!specifiersInserted) {
        [self insertContiguousSpecifiers:@[groupSpecifier, tweakCountSpecifier] afterSpecifier:[self specifierForID:@"APPLE_ACCOUNT"]];
      }

    } else if([self isMemberOfClass:[%c(TweakSpecifiersController) class]]) {
      [self insertContiguousSpecifiers:@[groupSpecifier, tweakCountSpecifier] atIndex:0];
    }
  }

%new
  -(void)hideDetailedCount:(PSSpecifier *)specifier {
    NSString *installedTweakCount = [NSString stringWithFormat:@"%d Tweaks Installed", [self.packageInfo[@"Tweaks"] intValue]];
    specifier->action = @selector(showDetailedCount:);
    [specifier setName:installedTweakCount];
    [self reloadSpecifier:specifier animated:YES];

    PSSpecifier *groupSpecifier = [self specifierForID:@"TWEAK_COUNT_GROUP"];
    [groupSpecifier setProperty:@"" forKey:@"footerText"];
    [self reloadSpecifier:groupSpecifier animated:YES];
  }

%new
  -(void)showDetailedCount:(PSSpecifier *)specifier {
    NSMutableArray *packageBreakdownBySection = [[NSMutableArray alloc] init];

    for(NSString *type in self.packageInfo) {
      [packageBreakdownBySection addObject:[NSString stringWithFormat:@"%@ : %d", type, [self.packageInfo[type] intValue]]];

      if([packageBreakdownBySection count] == [self.packageInfo count]) {
        NSArray *sortedArray = [packageBreakdownBySection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSString *packageBreakdown = [sortedArray componentsJoinedByString:@"\n"];

        specifier->action = @selector(hideDetailedCount:);
        [specifier setName:@"Show Less"];
        [self reloadSpecifier:specifier animated:YES];

        PSSpecifier *groupSpecifier = [self specifierForID:@"TWEAK_COUNT_GROUP"];
        [groupSpecifier setProperty:packageBreakdown forKey:@"footerText"];
        [self reloadSpecifier:groupSpecifier animated:YES];
      }
    }
  }

%new
  -(void)loadStatusFile {
    if(!self.packageInfo) {
      self.packageInfo = [[NSMutableDictionary alloc] init];

      NSString *dpkgStatus = [NSString stringWithContentsOfFile:@"Library/dpkg/status" encoding:NSUTF8StringEncoding error:nil];
      NSArray *packages = [dpkgStatus componentsSeparatedByString:@"\n\n"];
      for(NSString *p in packages) {
        [p enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
          if([line hasPrefix:@"Section: "]) {
            *stop = YES;

            NSString *section = [line stringByReplacingOccurrencesOfString:@"Section: " withString:@""];
            section = [section stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            if(self.packageInfo[section]) {
              self.packageInfo[section] = @([self.packageInfo[section] intValue] + 1);
            } else {
              [self.packageInfo setObject:@1 forKey:section];
            }
          }
        }];
      }
    }
  }
%end
