//
//  VariationLabelCell.h
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationCollectionViewCell.h"

@interface VariationLabelCell : VariationCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

+ (NSString *)reuseIdentifier;
+ (UIFont *)labelFont;

@end
