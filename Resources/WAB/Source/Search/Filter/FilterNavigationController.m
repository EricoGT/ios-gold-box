//
//  FilterNavigationController.m
//  Walmart
//
//  Created by Bruno Delgado on 11/14/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "FilterNavigationController.h"
#import "UIImage+Additions.h"
#import "OFFilterViewController.h"
#import "Filter.h"

@implementation FilterNavigationController

- (FilterNavigationController *)initWithFiltersData:(Filter *)filtersData originalQuery:(NSString *)originalQuery currentQuery:(NSString *)currentQuery filterDelegate:(id<FilterNavigationControllerDelegate>)filterDelegate
{
    OFFilterViewController *rootViewController = [[OFFilterViewController alloc] initWithFiltersData:filtersData query:currentQuery];
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        _originalQuery = originalQuery;
        _filterDelegate = filterDelegate;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"filterAction" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyFilterPressed)
                                                 name:@"filterAction"
                                               object:nil];
    
    UIColor *walmartBlueColor = RGBA(26, 117, 207, 1);
    self.navigationBar.backgroundColor = walmartBlueColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:walmartBlueColor size:CGSizeMake(self.view.bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *applyFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[applyFilterButton titleLabel] setFont:[UIFont fontWithName:@"OpensSans" size:15]];
    [applyFilterButton setTitle:@"APLICAR FILTRO" forState:UIControlStateNormal];
    [applyFilterButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [applyFilterButton setBackgroundImage:[OFColors imageWithColor:RGBA(26, 117, 207, 1)] forState:UIControlStateNormal];
    [applyFilterButton setBackgroundImage:[OFColors imageWithColor:RGBA(21, 94, 166, 1)] forState:UIControlStateHighlighted];
    [applyFilterButton setImage:[UIImage imageNamed:@"UISearchFilterButtonFilter.png"] forState:UIControlStateNormal];
    [applyFilterButton setImage:[UIImage imageNamed:@"UISearchFilterButtonFilter.png"] forState:UIControlStateHighlighted];
    [applyFilterButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [applyFilterButton addTarget:self action:@selector(applyFilterPressed) forControlEvents:UIControlEventTouchUpInside];
    [applyFilterButton setFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        
        LogInfo(@"topPadding    : %f", topPadding);
        LogInfo(@"bottomPadding : %f", bottomPadding);
        
        if (bottomPadding > 0) {
            [applyFilterButton setFrame:CGRectMake(15, self.view.frame.size.height - 64, self.view.frame.size.width-30, 44)];
            applyFilterButton.layer.cornerRadius = 3.0;
            applyFilterButton.layer.masksToBounds = YES;
        }
    }
    
    [self.view addSubview:applyFilterButton];
}

- (void)applyFilterPressed
{
    OFFilterViewController *lastController = (OFFilterViewController *) self.viewControllers.lastObject;
    if ([lastController respondsToSelector:@selector(result)]) {
        if (lastController.result && _filterDelegate && [_filterDelegate respondsToSelector:@selector(filterContentWithResult:query:)])
        {
            [_filterDelegate filterContentWithResult:lastController.result query:lastController.query];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
