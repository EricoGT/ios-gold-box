//
//  SearchProductVariation.h
//  Walmart
//
//  Created by Bruno Delgado on 7/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "SearchProductVariation.h"

@protocol SearchProductHubConnection
@end

@interface SearchProductHubConnection : JSONModel

@property (nonatomic, strong) NSNumber *productID;
@property (strong, nonatomic) NSNumber<Optional> *standardSku;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *baseImageUrl;
@property (nonatomic, strong) NSString<Optional> *stampUrl;
@property (nonatomic, strong) NSArray<SearchProductVariation> *productVariations;
@property (nonatomic, assign) BOOL priceVariations;
@property (nonatomic, strong) NSArray<Optional> *imageIds;
@property (assign, nonatomic) BOOL wishlist;
@property (assign, nonatomic) BOOL isRefreshingWishlistStatus;
@property (assign, nonatomic) BOOL hasVariations;
@property (strong, nonatomic) NSNumber<Ignore> *favoriteSKU;

- (BOOL)hasDiscount;

@end
