//
//  ProductModel.m
//  Walmart
//
//  Created by Renan Cargnin on 9/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "ProductDetailModel.h"

#import "NSString+HTML.h"
#import "WALFavoritesCache.h"

@implementation ProductDetailModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sellerOptions" : @"offers",
                                                                  @"ratingValue" : @"rating.value",
                                                                  @"ratingTotal" : @"rating.total",
                                                                  @"standardSku" : @"skuId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return [propertyName isEqualToString:@"wishlist"] ||
            [propertyName isEqualToString:@"rating"] ||
            [propertyName isEqualToString:@"hasReview"];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isFavorite"];
}

- (void)setTitle:(NSString *)title {
    _title = [title kv_decodeHTMLCharacterEntities];
}

- (NSArray *)imagesIds {
    NSMutableArray *imageIdsMutable;
    if (_sellerOptions.count > 0) {
        SellerOptionModel *sellerOption = _sellerOptions[0];
        imageIdsMutable = sellerOption.imageIds.mutableCopy;
    }
    if (imageIdsMutable.count == 0) {
        imageIdsMutable = _imagesIds.mutableCopy;
    }
//    [imageIdsMutable removeLastObject];
    return imageIdsMutable.copy;
}

- (NSNumber *)defaultSKU {
//    if (_sellerOptions.count > 0) {
//        SellerOptionModel *firstSeller = _sellerOptions[0];
//        return firstSeller.sku;
//    }
//    return nil;
    
    return _standardSku;
}

- (SellerOptionModel *)defaultSeller {
    return _sellerOptions.count == 0 ? nil : _sellerOptions[0];
}

- (NSArray *)otherSellers {
    if (_sellerOptions.count <= 1) return nil;
    return [_sellerOptions subarrayWithRange:NSMakeRange(1, _sellerOptions.count - 1)];
}

- (SellerOptionModel *)sellerWithId:(NSString *)sellerId {
    for (SellerOptionModel *sellerOption in _sellerOptions) {
        if ([sellerOption.sellerId isEqualToString:sellerId]) {
            return sellerOption;
        }
    }
    return nil;
}

- (BOOL)isAvailable {
//    NSInteger quantityAvailable = 0;
//    for (SellerOptionModel *sellerOption in _sellerOptions) {
//        quantityAvailable += sellerOption.quantityAvailable.integerValue;
//    }
//    return quantityAvailable > 0;
    
    BOOL isAvailable = NO;
    
    for (SellerOptionModel *sellerOption in _sellerOptions) {
        isAvailable = sellerOption.available.boolValue;
    }
    
    return isAvailable;
}

- (BOOL)hasVariations {
    return _variationsTree.options.count > 0;
}

- (BOOL)isFavorite {
    return [WALFavoritesCache isFavorite:self.defaultSKU];
}

- (BOOL)isReview {
    if(self.hasReview && [self.hasReview isEqual:@(1)]){
        return YES;
    }
    return NO;
}

//- (void)setIsFavorite:(BOOL)isFavorite {
//    if (_variationsTree.options.count > 0) {
//        [self defaultSeller].wishlist = isFavorite;
//    }
//    else {
//        self.wishlist = isFavorite;
//    }
//}

@end
