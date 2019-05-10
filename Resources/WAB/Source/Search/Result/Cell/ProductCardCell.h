//
//  ProductCardCell.h
//  Walmart
//
//  Created by Bruno Delgado on 9/29/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchProduct;
@class SearchProductHubConnection;

@protocol ProductCardCellDelegate <NSObject>
- (void)tappedHeartButtonInProductCell:(id)cell;
@end

@interface ProductCardCell : UITableViewCell

@property (weak) id<ProductCardCellDelegate> delegate;

- (void)updateHeartStatus;
- (void)updateHeartStatusHubConnection;
- (void)setupWithSearchProduct:(SearchProduct *)product;
- (void)setupWithSearchProductHubConnection:(SearchProductHubConnection *)product;
+ (UINib *)nib;

@end
