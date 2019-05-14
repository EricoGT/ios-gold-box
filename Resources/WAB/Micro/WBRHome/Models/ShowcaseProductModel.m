//
//  ShowcaseProduct.m
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "ShowcaseProductModel.h"

@implementation ShowcaseProductModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"paymentSuggestion": @"suggestion"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isRefreshingWishlistStatus"] || [propertyName isEqualToString:@"wishlist"];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"hasVariations"]) || ([propertyName isEqualToString:@"wishlist"]) || ([propertyName isEqualToString:@"rating"]);
}

- (BOOL)isEqual:(ShowcaseProductModel *)object {
    return _skuId.integerValue == object.skuId.integerValue;
}

- (NSUInteger)hash {
    return _skuId.integerValue;
}

- (void)setWishlist:(BOOL)wishlist {
    _wishlist = wishlist;
    self.isRefreshingWishlistStatus = NO;
}

- (NSNumber<Ignore> *)favoriteSKU {
    return _favoriteSKU ?: _skuId;
}

@end
