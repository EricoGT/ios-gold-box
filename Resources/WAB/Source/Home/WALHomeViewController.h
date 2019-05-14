//
//  WALHomeViewController.h
//  Walmart
//
//  Created by Renan on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"
#import "ShowcaseProductModel.h"

@class HomeModel;
@class DeepLinkAction;

typedef enum : NSUInteger {
    HomeStateShowcases = 0,
    HomeStateSearch = 1
} HomeState;

@interface WALHomeViewController : WALMenuItemViewController

@property (assign, nonatomic) HomeState state;

@property (strong, nonatomic) HomeModel *home;

@property (assign, nonatomic) BOOL isLoadingHome;

/**
 *  Loads the static and dynamic home
 */
- (void)loadHome;
- (void)favoriteProduct:(ShowcaseProductModel *)product completionBlock:(void (^)())completionBlock;

@end
