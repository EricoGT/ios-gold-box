//
//  SearchProduct.m
//  Walmart
//
//  Created by Bruno Delgado on 7/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SearchProduct.h"

@implementation SearchProduct

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"listPrice"        : @"price.listPrice",
                                                                  @"sellPrice"        : @"price.sellPrice",
                                                                  @"ratingValue"      : @"rating.value",
                                                                  @"ratingTotal"      : @"rating.total",
                                                                  @"instalment"       : @"price.installmentAmount",
                                                                  @"instalmentValue"  : @"price.valuePerInstallment",
                                                                  @"paymentTypes"     : @"price.paymentTypes",
                                                                  @"paymentSuggestion": @"suggestion"}];
}

- (BOOL)hasDiscount
{
    BOOL discount = NO;
    if (self.productVariations.count > 0)
    {
        SearchProductVariation *variation = self.productVariations[0];
        if (variation.savePercentage)
        {
            NSInteger percentage = variation.savePercentage.integerValue;
            if (percentage > 0)
            {
                discount = YES;
            }
        }
    }
    
    return discount;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isRefreshingWishlistStatus"] || [propertyName isEqualToString:@"wishlist"];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"wishlist"] ||
            [propertyName isEqualToString:@"hasVariations"] ||
            [propertyName isEqualToString:@"rating"]);
}

- (BOOL)isEqual:(SearchProduct *)object {
    return self.favoriteSKU.integerValue == object.favoriteSKU.integerValue;
}

- (NSUInteger)hash {
    return self.favoriteSKU.integerValue;
}

- (NSNumber<Ignore> *)favoriteSKU {
    return _favoriteSKU ?: _skuId ?: _productVariations.count > 0 ? [_productVariations[0] sku] : nil;
}

- (NSNumber<Optional> *)standardSku {
    if (_skuId) {
        return _skuId;
    }
    else if (_productVariations.count > 0) {
        SearchProductVariation *firstVariation = _productVariations[0];
        return firstVariation.sku;
    }
    return nil;
}

@end
