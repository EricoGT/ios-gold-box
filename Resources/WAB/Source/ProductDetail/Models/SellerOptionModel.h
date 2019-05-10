//
//  SellerOptionModel.h
//  Walmart
//
//  Created by Renan Cargnin on 9/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "WBRPaymentSuggestion.h"
#import "DeliveryType.h"

@protocol SellerOptionModel <NSObject>
@end

@interface SellerOptionModel : JSONModel

@property (strong, nonatomic) NSNumber *sku;
@property (strong, nonatomic) NSString<Optional> *productName;
@property (assign, nonatomic) BOOL hasExtendedWarranty;
@property (assign, nonatomic) NSNumber *available;
@property (strong, nonatomic) NSString <Optional>*sellerId;
@property (strong, nonatomic) NSNumber <Optional>*originalPrice;
@property (strong, nonatomic) NSNumber *discountPrice;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSArray <Optional>*imageIds;
@property (strong, nonatomic) NSNumber <Optional>*instalment;
@property (strong, nonatomic) NSNumber <Optional>*instalmentValue;
@property (assign, nonatomic) BOOL wishlist;
@property (strong, nonatomic) WBRPaymentSuggestion<Optional> *paymentSuggestion;
@property (strong, nonatomic) NSArray<NSString *><Optional>*paymentTypes;

@property (strong, nonatomic) NSArray<DeliveryType, Optional>  *deliveryTypes;

@end
