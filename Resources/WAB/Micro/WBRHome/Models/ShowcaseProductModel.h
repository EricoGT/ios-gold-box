//
//  ShowcaseProduct.h
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "JSONModel.h"
#import "ModelPrice.h"
#import "WBRRatingModel.h"
#import "WBRPaymentSuggestion.h"
#import "WBRBestInstallment.h"

@protocol ShowcaseProductModel <NSObject>
@end

@interface ShowcaseProductModel : JSONModel

@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber<Optional> *skuId;
@property (strong, nonatomic) NSString<Optional> *sellerId;

@property (assign, nonatomic) NSNumber *hasSkuOptions;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageId;
@property (strong, nonatomic) WBRPaymentSuggestion<Optional> *paymentSuggestion;
@property (strong, nonatomic) NSArray<Optional> *paymentType;
@property (strong, nonatomic) NSArray<NSString *><Optional> *paymentTypes;

@property (strong, nonatomic) NSString<Optional> *stampImage;
//@property (strong, nonatomic) NSString<Optional> *stampTitle;
//@property (strong, nonatomic) NSString<Optional> *stampDescription;

@property (strong, nonatomic) NSNumber<Optional> *totalColors;

@property (assign, nonatomic) NSNumber <Optional> *quantityAvailable;
@property (strong, nonatomic) NSString <Optional> *currency;

@property (strong, nonatomic) ModelPrice *price;

//@property (assign, nonatomic) NSNumber <Optional> *priceVariations;

@property (strong, nonatomic) NSNumber <Optional> *hasMoreOffers;
@property (strong, nonatomic) NSNumber <Optional> *discountPrice;
@property (strong, nonatomic) NSNumber <Optional> *instalment;
@property (strong, nonatomic) NSNumber <Optional> *instalmentValue;

@property (assign, nonatomic) BOOL wishlist;
@property (assign, nonatomic) BOOL isRefreshingWishlistStatus;

@property (strong, nonatomic) WBRRatingModel<Optional> *rating;

/**
 *  Returns favorite SKU if available. If not, returns product default SKU.
 */
@property (strong, nonatomic) NSNumber<Ignore> *favoriteSKU;

@end
