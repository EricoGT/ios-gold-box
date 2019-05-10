//
//  WishlistSellerOption.h
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "WBRRatingModel.h"
#import "WishlistTax.h"
#import "WBRPaymentSuggestion.h"

@protocol WishlistSellerOption
@end

@interface WishlistSellerOption : JSONModel

@property (nonatomic, assign) NSNumber <Optional>*hasExtendedWarranty;
@property (nonatomic, assign) BOOL wishlist;
@property (nonatomic, strong) NSNumber *sku;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *discountPrice;
@property (nonatomic, strong) NSNumber *price;
//@property (nonatomic, strong) NSString *saveAmount;
//@property (nonatomic, strong) NSNumber *savePercentage;
//@property (nonatomic, strong) NSString *formattedListPrice;
//@property (nonatomic, strong) NSString *formattedSellPrice;
@property (nonatomic, strong) NSNumber *instalment;
@property (nonatomic, strong) NSNumber *instalmentValue;
@property (nonatomic, strong) NSNumber *quantityAvailable;
@property (nonatomic, strong) NSString *seller;
@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL available;
//@property (nonatomic, assign) BOOL supplierStock;
//@property (nonatomic, strong) WishlistTax *tax;
@property (nonatomic, strong) NSArray *imageIds;
@property (strong, nonatomic) WBRRatingModel<Optional> *rating;
@property (strong, nonatomic) WBRPaymentSuggestion<Optional> *paymentSuggestion;

@end
