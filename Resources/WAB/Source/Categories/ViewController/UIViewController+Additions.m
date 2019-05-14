//
//  UIViewController+Additions.m
//  Walmart
//
//  Created by Bruno Delgado on 8/22/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (UIViewController *)topVisibleViewController
{
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)self;
        return [tabBarController.selectedViewController topVisibleViewController];
    }
    else if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)self;
        return [navigationController.visibleViewController topVisibleViewController];
    }
    else if (self.presentedViewController)
    {
        return [self.presentedViewController topVisibleViewController];
    }
    else if (self.childViewControllers.count > 0)
    {
        return [self.childViewControllers.lastObject topVisibleViewController];
    }

    return self;
}

@end
