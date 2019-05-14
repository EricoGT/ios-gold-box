//
//  HubCategoriesCollectionViewController.h
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HubCategory, CategoryMenuItem, HubConnection;

@protocol HubCategoriesDelegate <NSObject>
@optional
- (void)selectedHubCategory:(HubCategory *)hubCategory;
- (void)selectedOtherCategory:(CategoryMenuItem *)category;
@end

@interface HubCategoriesCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (weak) id <HubCategoriesDelegate> delegate;

@property (strong, nonatomic) NSString *hubId;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *otherCategories;

@property (strong, nonatomic) HubConnection *connection;

- (HubCategoriesCollectionViewController *)initWithHubId:(NSString *)hubId otherCategories:(NSArray *)otherCategories;

- (void)loadHubCategories;
- (void)removeRepeatedCategories;

- (void)handleTableViewInsets:(UIEdgeInsets)insets;

@end
