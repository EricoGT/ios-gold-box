//
//  HomeModel.m
//  Walmart
//
//  Created by Renan Cargnin on 8/18/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "HomeModel.h"

#import "WishlistInteractor.h"

@implementation HomeModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"topBanners" : @"campaigns.top",
                                                                  @"bottomBanners" : @"campaigns.bottom"
                                                                  }];

}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        [WishlistInteractor assignWishlistStatusToShowcases:_showcases];
    }
    return self;
}

/**
 *  Prevents empty showcases from being loaded
 *
 *  @param NSArray<ShowcaseModel> with the list of showcases
 */
- (void)setShowcases:(NSArray<ShowcaseModel> *)showcases {
    NSMutableArray *validShowcases = [NSMutableArray new];
    for (ShowcaseModel *showcase in showcases) {
        if (showcase.products.count > 0) [validShowcases addObject:showcase];
    }
    _showcases = validShowcases.copy;
}

- (NSArray *)productsWithSKU:(NSNumber *)sku {
    NSMutableArray *products = [NSMutableArray new];
    for (ShowcaseModel *showcase in _showcases) {
        for (ShowcaseProductModel *product in showcase.products) {
            if ([sku isEqual:product.skuId]) {
                [products addObject:product];
            }
        }
    }
    return products.copy;
}

@end
