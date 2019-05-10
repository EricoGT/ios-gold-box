//
//  SearchCategoryResult.m
//  Walmart
//
//  Created by Bruno Delgado on 7/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SearchCategoryResult.h"

#import "WishlistInteractor.h"

@implementation SearchCategoryResult

//+ (JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"filters" : @"filter"}];
//}

- (instancetype)initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err {
    JSONModelError *parserError = nil;
    if (self = [super initWithString:string error:&parserError])
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithModelToJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    JSONModelError *parserError = nil;
    if (self = [super initWithDictionary:dict error:&parserError])
    {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSMutableArray *allProductsMutable = [NSMutableArray new];
    
    SearchCategoryResult *scr = self;
    LogMicro(@"Dict [%i]: %@", (int)scr.products.count, scr.products);
    
    [allProductsMutable addObjectsFromArray:scr.products];

//    for (SearchCategoryResult *result in _products) {
//        LogMicro(@"result: %@", result);
//        [allProductsMutable addObjectsFromArray:result.products];
//    }
    
//    for (SearchCategory *category in _products) {
//    
//        [allProductsMutable addObjectsFromArray:category.products];
//    }
    
    [WishlistInteractor assignWishlistStatusToProducts:allProductsMutable.copy skuKey:@"standardSku" wishlistKey:@"wishlist"];
}

@end
