//
//  WALMenuItemViewController.m
//  Walmart
//
//  Created by Renan on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"

#import "WALMenuViewController.h"
#import "NewCartViewController.h"

@interface WALMenuItemViewController ()

@property (strong, nonatomic) UIView *clearView;

@end

@implementation WALMenuItemViewController

#pragma mark - Init
- (WALMenuItemViewController *)initWithTitle:(NSString *)title isModal:(BOOL)isModal searchButton:(BOOL)searchButton cartButton:(BOOL)cartButton wishlistButton:(BOOL)wishlistButton
{
    self = [super initWithTitle:title isModal:isModal searchButton:searchButton cartButton:cartButton wishlistButton:wishlistButton];
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.firstObject == self && !self.navigationController.presentingViewController) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton addTarget:self action:@selector(tappedMenu) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setImage:[UIImage imageNamed:@"ico_menu"] forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0, 0, 24, 24)];
        
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuItem];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupClearView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        [self setupClearView];
    }
}

#pragma mark - WALTopBarViewDelegate
#pragma mark - Menu
- (void)tappedMenu
{
    WALMenuViewController *menu = [WALMenuViewController singleton];
    (menu.isMenuOpen) ? [menu closeMenuAnimated:YES completion:nil] : [menu openMenuWithCompletion:nil];
}

- (void)tappedDismissButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Clear View
- (void)setupClearView
{
    if (!self.clearView.superview)
    {
        self.clearView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.clearView.backgroundColor = [UIColor clearColor];
        self.clearView.translatesAutoresizingMaskIntoConstraints = NO;
        self.clearView.hidden = YES;
        
        UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
        [tapGesture addTarget:self action:@selector(tapInClearView:)];
        [self.clearView addGestureRecognizer:tapGesture];
        [self.view addSubview:self.clearView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.clearView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.clearView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.clearView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.clearView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view layoutIfNeeded];
    }
}

- (void)tapInClearView:(UITapGestureRecognizer *)tapGesture
{
    [self tappedMenu];
}

#pragma mark - Helpers
- (void)enableInteraction:(BOOL)enable
{
    self.clearView.hidden = enable;
}

@end
