//
//  WishlistProduct.m
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WishlistProduct.h"

#import "NSString+HTML.h"

@implementation WishlistProduct

//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"discountPrice": @"skuPrice"}];
//}

- (BOOL)isLowPrice {
    return _statusPrice.integerValue == -1;
}

- (BOOL)isOutOfStock {
    return _quantity <= 0;
}

- (BOOL)hasExtendedWarranty {
    if (_sellerOptions.count == 0) return NO;
    WishlistSellerOption *firstSellerOption = _sellerOptions.firstObject;
    return firstSellerOption.hasExtendedWarranty.boolValue;
}

- (WishlistSellerOption *)defaultSellerOption {
    return _sellerOptions.count > 0 ? _sellerOptions.firstObject : nil;
}

- (NSString *)defaultName {
    if (_sellerOptions.count == 0) return nil;
    WishlistSellerOption *sellerOption = _sellerOptions.firstObject;
    return [sellerOption.name kv_decodeHTMLCharacterEntities];
}

- (NSNumber *)defaultSKU {
    if (_sellerOptions.count == 0) return nil;
    WishlistSellerOption *sellerOption = _sellerOptions.firstObject;
    return sellerOption.sku;
}

- (NSString *)firstImageId {
    if (_sellerOptions.count == 0) return nil;
    WishlistSellerOption *sellerOption = _sellerOptions.firstObject;
    if (sellerOption.imageIds.count == 0) return nil;
    return sellerOption.imageIds.firstObject;
}

- (NSNumber *)discountPrice {
    if (_sellerOptions.count == 0) return nil;
    WishlistSellerOption *sellerOption = _sellerOptions.firstObject;
    return sellerOption.discountPrice;
}

@end
