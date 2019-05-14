//
//  WALMenuItemViewController.h
//  Walmart
//
//  Created by Renan on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@class WALMenuViewController;

@interface WALMenuItemViewController : WMBaseViewController

@property (nonatomic, strong) WALMenuViewController *menu;

- (WALMenuItemViewController *)initWithTitle:(NSString *)title isModal:(BOOL)isModal searchButton:(BOOL)searchButton cartButton:(BOOL)cartButton wishlistButton:(BOOL)wishlistButton;

#pragma mark - Menu
- (void)tappedMenu;

#pragma mark - Helper
- (void)enableInteraction:(BOOL)enable;


@end
