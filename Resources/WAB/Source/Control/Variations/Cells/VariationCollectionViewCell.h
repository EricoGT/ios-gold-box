//
//  VariationCell.h
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariationNode;

@protocol VariationCellDelegate <NSObject>
@optional
- (void)selectedVariation:(VariationNode *)variationNode;
@end

@interface VariationCollectionViewCell : UICollectionViewCell

@property (weak) id <VariationCellDelegate> delegate;

@property (strong, nonatomic) VariationNode *variationNode;

+ (UIColor *)selectedColor;
+ (UIColor *)deselectedColor;
+ (UIColor *)selectdColorBackground;
+ (UIColor *)deselectedColorBackground;
+ (UIColor *)selectedBorder;
+ (UIColor *)deselectedBorder;
+ (UIColor *)highlightedColor;

- (void)setupWithVariationNode:(VariationNode *)variationNode delegate:(id <VariationCellDelegate>)delegate;

@end
