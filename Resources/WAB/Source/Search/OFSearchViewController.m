//
//  OFSearchViewController.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFSearchViewController.h"

#import "WMBSearchView.h"
#import "SearchOrchestrator.h"

#import "UISearchBar+CancelButton.h"
#import "OrdersViewController.h"
#import "WMMyAccountViewController.h"
#import "WBRCustomSearchBar.h"

@interface OFSearchViewController () <SearchOrchestratorDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (strong, nonatomic) SearchOrchestrator *searchOrchestrator;

@property (strong, nonatomic) NSString *initialQuery;

@end

@implementation OFSearchViewController

- (OFSearchViewController *)initWithQuery:(NSString *)query {
     self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _initialQuery = query;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.searchBar = [[WBRCustomSearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    
    self.searchOrchestrator = [SearchOrchestrator new];
    _searchOrchestrator.searchBar = _searchBar;
    _searchOrchestrator.searchView = (WMBSearchView *) self.view;
    _searchOrchestrator.presenterController = self;
    _searchOrchestrator.delegate = self;
    
    if (_initialQuery.length > 0) {
        [_searchOrchestrator searchWithQuery:_initialQuery resetOriginalQuery:YES searchedTerm:nil];
    }
    else {
        [_searchBar becomeFirstResponder];
    }
    
    [_searchBar setShowsCancelButton:YES animated:NO];
    [_searchBar reenableCancelButton];
    
    [FlurryWM logEvent_search_doSearch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.view layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.view layoutSubviews];
}

- (void)refreshWithQuery:(NSString *)query {
    [_searchOrchestrator searchWithQuery:query resetOriginalQuery:YES searchedTerm:nil];
}

#pragma mark - SearchOrchestratorDelegate
- (void)searchOrchestratorSearchBarCancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchOrchestratorSearchBarOpenOrders {
    
    BOOL activeSession = [WALSession isAuthenticated];
    
    if (activeSession) {
        [self openOrders];
    } else {
        __weak OFSearchViewController *weakSelf = self;
        [self presentLoginWithLoginSuccessBlock:^{
            if (weakSelf != nil) {
                [self openOrders];
            }
        }];
    }
}

- (void)searchOrchestratorSearchBarOpenMyAccount {
    
    BOOL activeSession = [WALSession isAuthenticated];
    
    if (activeSession) {
        [self openMyAccount];
    } else {
        __weak OFSearchViewController *weakSelf = self;
        [self presentLoginWithLoginSuccessBlock:^{
            if (weakSelf != nil) {
                [weakSelf openMyAccount];
            }
        }];
    }
}

- (void)openOrders {
    OrdersViewController *orderViewController = [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

- (void)openMyAccount {
    WMMyAccountViewController *myAccountViewController = [[WMMyAccountViewController alloc] initWithNibName:@"WMMyAccountViewController" bundle:nil];
    [self.navigationController pushViewController:myAccountViewController animated:YES];
}

#pragma mark UTMIIdentifier
- (NSString *)UTMIIdentifier {
    return @"resultado-busca";
}

@end
