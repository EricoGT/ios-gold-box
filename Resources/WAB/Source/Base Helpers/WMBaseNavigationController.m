//
//  WMBaseNavigationController.m
//  Walmart
//
//  Created by Bruno on 8/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseNavigationController.h"

@interface WMBaseNavigationController ()

@end

@implementation WMBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLayout];
}

- (void)setupLayout
{
    [self.navigationBar setBackgroundImage:[OFColors imageWithColor:RGBA(26, 117, 207, 1) size:CGSizeMake(self.view.bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"UINavigationBarBackButton"];
    NSDictionary *attributesTitle = @{NSForegroundColorAttributeName   :   [UIColor whiteColor],
                                      NSFontAttributeName              :   [UIFont fontWithName:@"Roboto-Regular" size:15]};
    
    NSDictionary *attributesBack = @{NSForegroundColorAttributeName   :   [UIColor whiteColor],
                                     NSFontAttributeName              :   [UIFont fontWithName:@"Roboto-Regular" size:15]};
    
    [self.navigationBar setTitleTextAttributes:attributesTitle];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributesBack forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributesBack forState:UIControlStateNormal];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationBar setTitleVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.leftBarButtonItem setBackButtonBackgroundImage:[backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24.0, 0, 0.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.leftBarButtonItem setBackButtonBackgroundImage:[backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24.0, 0, 0.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

@end
