//
//  HomeShowcaseTableViewCell.h
//  Walmart
//
//  Created by Renan Cargnin on 7/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowcaseModel, ShowcaseProductModel;

@protocol HomeShowcaseTableViewCellDelegate <NSObject>
@optional
- (void)selectedProduct:(NSString *)productId showcase:(ShowcaseModel *)showcase;
- (void)homeShowcaseCell:(id)homeShowcaseCell tappedHeartButtonForProductAtIndex:(NSUInteger)productIndex;
@end

@class ShowcaseModel;

@interface HomeShowcaseTableViewCell : UITableViewCell

@property (weak) id <HomeShowcaseTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)setupWithShowcase:(ShowcaseModel *)showcase;
- (void)refreshProductsWithSKU:(NSNumber *)sku;

@end
