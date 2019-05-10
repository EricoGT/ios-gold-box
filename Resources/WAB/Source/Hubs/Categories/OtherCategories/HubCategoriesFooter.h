//
//  HubCategoriesFooter.h
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryMenuItem;

@protocol HubCategoriesFooterDelegate <NSObject>
@optional
- (void)selectedOtherCategory:(CategoryMenuItem *)category;
@end

@interface HubCategoriesFooter : UICollectionReusableView <UITableViewDelegate, UITableViewDataSource>

@property (weak) id <HubCategoriesFooterDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;

- (void)setupWithCategories:(NSArray *)categories;

@end
