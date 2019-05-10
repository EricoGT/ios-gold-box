//
//  AllShoppingViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 11/28/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"

@protocol AllShoppingDelegate <NSObject>
@required
@optional
- (void)hideAllShoppingScreenGesture;
- (void)showAllShoppingScreenGesture;
- (void)hideAllShoppingScreen;
@end

@interface AllShoppingViewController : WALMenuItemViewController

- (AllShoppingViewController *)initWithCategories:(NSArray *)categories;

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) NSURL *urlProductTest;

@end
