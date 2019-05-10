//
//  FilterBaseViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 8/4/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SearchSortViewController.h"
#import "SearchSortTableViewController.h"

@interface SearchSortViewController ()

@property (nonatomic, strong) UIView *dimmedView;
@property (nonatomic, strong) UINavigationController *containerNavigationController;

@property (weak) id <FilterDelegate> delegate;
@property (nonatomic, strong) SortOption *optionSelected;

@end

@implementation SearchSortViewController

- (SearchSortViewController *)initWithSelectedOption:(SortOption *)selectedOption delegate:(id<FilterDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _optionSelected = selectedOption;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *controller;
    NSInteger topDistance = 0;
    CGRect frameNavigation;
    
    controller = [[SearchSortTableViewController alloc] init];
    [(SearchSortTableViewController *)controller setBaseViewController:self];
    [(SearchSortTableViewController *)controller setOptionSelected:_optionSelected];
    topDistance = (self.view.frame.size.height-40) - 265;
    frameNavigation = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topDistance);
    
    [self showDimmedView];
    
    self.containerNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.containerNavigationController.view.frame = frameNavigation;
    __block CGRect navigationViewFrame = self.containerNavigationController.view.frame;
    
    [self addChildViewController:self.containerNavigationController];
    [self.view addSubview:self.containerNavigationController.view];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        navigationViewFrame.origin.y = topDistance;
        self.containerNavigationController.view.frame = navigationViewFrame;
    } completion:^(BOOL finished) {
        [self.containerNavigationController willMoveToParentViewController:self];
    }];
}

- (void)showDimmedView
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.dimmedView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, bounds.size.width, bounds.size.height)];
    self.dimmedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.dimmedView.backgroundColor = RGBA(0, 0, 0, 1);
    self.dimmedView.alpha = 0;
    [self.view addSubview:self.dimmedView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidReceiveTouchEvent)];
    [self.dimmedView addGestureRecognizer:singleTap];
    
    [UIView animateWithDuration:.3 animations:^{
        self.dimmedView.alpha = .6;
    }];
}

- (void)hideDimmedView
{
    [UIView animateWithDuration:.3 animations:^{
        self.dimmedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dimmedView removeFromSuperview];
        self.dimmedView = nil;
    }];
}

- (void)dismiss
{
    LogInfo(@"dismiss ");
    
    if (self.containerNavigationController)
    {
        __block CGRect navigationViewFrame = self.containerNavigationController.view.frame;
        [self hideDimmedView];
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            navigationViewFrame.origin.y = self.view.frame.size.height;
            self.containerNavigationController.view.frame = navigationViewFrame;
        } completion:^(BOOL finished) {
            [self.containerNavigationController.view removeFromSuperview];
            [self.containerNavigationController removeFromParentViewController];
            self.containerNavigationController = nil;
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}

- (void)backgroundDidReceiveTouchEvent
{
    [self dismiss];
}

- (void)selectOption:(NSInteger)optionIndex fromOptions:(NSArray *)options
{
    [self dismiss];
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(sortDidSelectOption:fromOptions:)]))
    {
        [self.delegate sortDidSelectOption:optionIndex fromOptions:options];
    }
}

@end
