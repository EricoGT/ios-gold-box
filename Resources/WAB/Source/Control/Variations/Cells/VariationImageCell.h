//
//  VariationImageCell.h
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationCollectionViewCell.h"

@class VariationNode;

@interface VariationImageCell : VariationCollectionViewCell

+ (NSString *)reuseIdentifier;

+ (void)setBaseImageURLString:(NSString *)string;
+ (NSString *)baseImageURLString;

@end
