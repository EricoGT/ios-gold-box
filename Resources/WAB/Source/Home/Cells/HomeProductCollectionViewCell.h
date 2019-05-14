//
//  HomeProductCollectionViewCell.h
//  Walmart
//
//  Created by Renan Cargnin on 7/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowcaseProductModel;

@protocol HomeProductCollectionViewCellDelegate <NSObject>
@required
- (void)homeProductCellTappedHeartButton:(id)homeProductCell;
@end

@interface HomeProductCollectionViewCell : UICollectionViewCell

@property (weak) id <HomeProductCollectionViewCellDelegate> delegate;

- (void)setupWithProduct:(ShowcaseProductModel *)product delegate:(id <HomeProductCollectionViewCellDelegate>)delegate;
- (void)updateHeartStatus;

@end
