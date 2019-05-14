//
//  SearchProductVariation.h
//  Walmart
//
//  Created by Bruno Delgado on 7/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol SearchProductVariation
@end

@interface SearchProductVariation : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *sku;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *quantityAvailable;
@property (nonatomic, strong) NSString<Optional> *supplierStock;
@property (nonatomic, strong) NSNumber<Optional> *originalPrice;
@property (nonatomic, strong) NSNumber<Optional> *price;
@property (nonatomic, strong) NSString<Optional> *currency;
@property (nonatomic, strong) NSNumber<Optional> *discountPrice;
@property (nonatomic, strong) NSString<Optional> *formattedSellPrice;
@property (nonatomic, strong) NSString<Optional> *formattedListPrice;
@property (nonatomic, strong) NSString<Optional> *saveAmount;
@property (nonatomic, strong) NSNumber<Optional> *savePercentage;
@property (nonatomic, strong) NSString<Optional> *sellerId;
@property (nonatomic, strong) NSString<Optional> *seller;
@property (nonatomic, strong) NSNumber<Optional> *instalment;
@property (nonatomic, strong) NSNumber<Optional> *instalmentValue;
@property (nonatomic, strong) NSArray<Optional> *imageIds;
@property (nonatomic, strong) NSNumber<Optional> *totalColors;
@property (nonatomic, strong) NSArray<NSString *><Optional> *paymentTypes;

@end
