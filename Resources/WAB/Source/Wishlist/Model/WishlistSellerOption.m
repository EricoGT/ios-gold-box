//
//  WishlistSellerOption.m
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WishlistSellerOption.h"

@implementation WishlistSellerOption

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"paymentSuggestion": @"suggestion" }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"wishlist"]);
}

@end
