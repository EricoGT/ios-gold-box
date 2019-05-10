//
//  SearchProduct.h
//  Walmart
//
//  Created by Bruno Delgado on 7/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "SearchProductVariation.h"
#import "WBRPaymentSuggestion.h"
#import "WBRRatingModel.h"
#import "WBRBestInstallment.h"

@protocol SearchProduct
@end

@interface SearchProduct : JSONModel

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber<Optional> *skuId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *imageId;
@property (nonatomic, strong) NSString<Optional> *stampImage;
@property (nonatomic, strong) NSArray<Optional, SearchProductVariation> *productVariations;
//@property (nonatomic, strong) NSNumber <Optional> *priceVariations;

@property (nonatomic, strong) NSNumber <Optional> *listPrice;
@property (nonatomic, strong) NSNumber <Optional> *sellPrice;
@property (nonatomic, strong) NSNumber *hasMoreOffers;
@property (nonatomic, strong) NSNumber *hasAvailability;
@property (nonatomic, strong) NSString <Optional> *sellerId;
@property (nonatomic, strong) NSNumber <Optional> *instalment;
@property (nonatomic, strong) NSNumber <Optional> *instalmentValue;
@property (nonatomic, strong) NSNumber <Optional> *totalColors;
@property (nonatomic, strong) NSArray<Optional> *imageIds;
@property (assign, nonatomic) BOOL wishlist;
@property (assign, nonatomic) BOOL isRefreshingWishlistStatus;
//@property (assign, nonatomic) BOOL hasVariations;
@property (nonatomic, strong) NSNumber *hasSkuOptions;
@property (strong, nonatomic) NSNumber<Ignore> *favoriteSKU;
@property (nonatomic, strong) NSArray<NSString *><Optional> *paymentTypes;

@property (strong, nonatomic) WBRRatingModel<Optional> *rating;

@property (strong, nonatomic) WBRPaymentSuggestion<Optional> *paymentSuggestion;

- (BOOL)hasDiscount;

@end
