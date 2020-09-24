/*
 * Tweak.x
 * TweakSearch
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 8/13/2020.
 * Copyright © 2020 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "TweakSearch.h"

  /*
   *  Tweaks
   */

%hook TweakSpecifiersController
%property (nonatomic, assign) NSUInteger lastSearchBarTextLength;

  -(void)viewDidLoad {
    %orig;

    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.definesPresentationContext = YES;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.searchBar.delegate = self;

    if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
      searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
      searchController.dimsBackgroundDuringPresentation = NO;
    }

    [((TweakSpecifiersController *)self).navigationItem setSearchController:searchController];
    [((TweakSpecifiersController *)self).navigationItem setHidesSearchBarWhenScrolling:YES];
    [self setLastSearchBarTextLength:0];
  }

  -(void)viewDidDisappear:(BOOL)animated {
    %orig;

    [self reloadSpecifiers];
    [((TweakSpecifiersController *)self).navigationItem.searchController setActive:NO];
    [self setLastSearchBarTextLength:0];
  }

%new
  -(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
  }

%new
  -(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
  }

%new
  -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    if([text length] < [self lastSearchBarTextLength]) {  //by p0358
      [self reloadSpecifiers];
    }

    if([text length] > 0) {
      for(PSSpecifier *specifier in [self valueForKey:@"_specifiers"]) {
        NSRange titleRange = [specifier.name rangeOfString:text options:NSCaseInsensitiveSearch];
        if([specifier.name length] > 0 && titleRange.location == NSNotFound) {
          [self removeSpecifier:specifier];
        }
      }
    }

    [self setLastSearchBarTextLength:[text length]];
  }

%new
  -(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadSpecifiers];
    [self setLastSearchBarTextLength:0];
  }
%end

  /*
   *  System Apps
   */

%hook AppleAppSpecifiersController
%property (nonatomic, assign) NSUInteger lastSearchBarTextLength;

  -(void)viewDidLoad {
    %orig;

    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.definesPresentationContext = YES;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.searchBar.delegate = self;

    if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
      searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
      searchController.dimsBackgroundDuringPresentation = NO;
    }

    [((AppleAppSpecifiersController *)self).navigationItem setSearchController:searchController];
    [((AppleAppSpecifiersController *)self).navigationItem setHidesSearchBarWhenScrolling:YES];
    [self setLastSearchBarTextLength:0];
  }

  -(void)viewDidDisappear:(BOOL)animated {
    %orig;

    [self reloadSpecifiers];
    [((AppleAppSpecifiersController *)self).navigationItem.searchController setActive:NO];
    [self setLastSearchBarTextLength:0];
  }

%new
  -(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
  }

%new
  -(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
  }

%new
  -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    if([text length] < [self lastSearchBarTextLength]) {  //by p0358
      [self reloadSpecifiers];
    }

    if([text length] > 0) {
      for(PSSpecifier *specifier in [self valueForKey:@"_specifiers"]) {
        NSRange titleRange = [specifier.name rangeOfString:text options:NSCaseInsensitiveSearch];
        if([specifier.name length] > 0 && titleRange.location == NSNotFound) {
          [self removeSpecifier:specifier];
        }
      }
    }

    [self setLastSearchBarTextLength:[text length]];
  }

%new
  -(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadSpecifiers];
    [self setLastSearchBarTextLength:0];
  }
%end

  /*
   *  App Store Apps
   */
%hook AppStoreAppSpecifiersController
%property (nonatomic, assign) NSUInteger lastSearchBarTextLength;

  -(void)viewDidLoad {
    %orig;

    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.definesPresentationContext = YES;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.searchBar.delegate = self;

    if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
      searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
      searchController.dimsBackgroundDuringPresentation = NO;
    }

    [((AppStoreAppSpecifiersController *)self).navigationItem setSearchController:searchController];
    [((AppStoreAppSpecifiersController *)self).navigationItem setHidesSearchBarWhenScrolling:YES];
    [self setLastSearchBarTextLength:0];
  }

  -(void)viewDidDisappear:(BOOL)animated {
    %orig;

    [self reloadSpecifiers];
    [((AppStoreAppSpecifiersController *)self).navigationItem.searchController setActive:NO];
    [self setLastSearchBarTextLength:0];
  }

%new
  -(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
  }

%new
  -(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
  }

%new
  -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    if([text length] < [self lastSearchBarTextLength]) {  //by p0358
      [self reloadSpecifiers];
    }

    if([text length] > 0) {
      for(PSSpecifier *specifier in [self valueForKey:@"_specifiers"]) {
        NSRange titleRange = [specifier.name rangeOfString:text options:NSCaseInsensitiveSearch];
        if([specifier.name length] > 0 && titleRange.location == NSNotFound) {
          [self removeSpecifier:specifier];
        }
      }
    }

    [self setLastSearchBarTextLength:[text length]];
  }

%new
  -(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadSpecifiers];
    [self setLastSearchBarTextLength:0];
  }
%end

  //Shuffle just had to have different class names, didn't they
%ctor {
  id SystemController = ([objc_getClass("SystemAppsController") class]) ? objc_getClass("SystemAppsController") : objc_getClass("AppleAppSpecifiersController");
  id AppsController = ([objc_getClass("AppSpecifiersController") class]) ? objc_getClass("AppSpecifiersController") : objc_getClass("AppStoreAppSpecifiersController");

  %init(AppleAppSpecifiersController = SystemController, AppStoreAppSpecifiersController = AppsController);
}
