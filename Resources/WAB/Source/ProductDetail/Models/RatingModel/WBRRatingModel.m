//
//  WBRRatingModel.m
//  Walmart
//
//  Created by Guilherme Ferreira on 30/06/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRRatingModel.h"

@implementation WBRRatingModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ratingValue" : @"value",
                                                                  @"totalOfRatings" : @"total"}];
}

/**
 *  Overrides the setter to validate if the given value is within the range of acceptable values (0 - 5).
 *
 *  @param ratingValue Rating given by users to an specific product. Ranges goes from 0 to 5
 */
- (void)setRatingValue:(NSNumber *)ratingValue {
    
    NSNumber *newRatingValue = ratingValue;
    
    if (ratingValue.longValue < 0) {
        newRatingValue = @(0);
    }
    else if (ratingValue.longValue > 5) {
        newRatingValue = @(5);
    }
    
    _ratingValue = newRatingValue;
}

@end
