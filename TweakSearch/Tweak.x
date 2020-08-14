/*
 * Tweak.x
 * TweakSearch
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 8/13/2020.
 * Copyright © 2019 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface TweakSpecifiersController : PSListController <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, assign) NSUInteger lastSearchBarTextLength;
@end

@interface UISearchController (iOS13)
@property (nonatomic, assign) BOOL dimsBackgroundDuringPresentation;
@end

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

    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    self.lastSearchBarTextLength = 0;
  }

  -(void)viewDidDisappear:(BOOL)animated {
    %orig;

    [self reloadSpecifiers];
    [self.navigationItem.searchController setActive:NO];
    self.lastSearchBarTextLength = 0;
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
    if([text length] < self.lastSearchBarTextLength) {
      [self reloadSpecifiers]; // only reload if there are less characters than previously (otherwise we only remove items, without adding anything)
    }

    if([text length] > 0) {
      for(PSSpecifier *specifier in [self valueForKey:@"_specifiers"]) {
        NSRange titleRange = [specifier.name rangeOfString:text options:NSCaseInsensitiveSearch];
        if([specifier.name length] > 0 && titleRange.location == NSNotFound) {
          [self removeSpecifier:specifier];
        }
      }
    }

    self.lastSearchBarTextLength = [text length];
  }

%new
  -(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadSpecifiers];
    self.lastSearchBarTextLength = 0;
  }
%end
