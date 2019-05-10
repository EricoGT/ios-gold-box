//
//  CartItem.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "ShippingEstimate.h"
#import "DeliveryType.h"
#import "ProductCategory.h"

@protocol CartItem
@end

@interface CartItem : JSONModel

@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSNumber *sku;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *priceWithoutDiscountCurrent;
@property (nonatomic, strong) NSNumber *priceWithoutDiscountOriginal;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSNumber *shippingValue;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *cartImageUrl;
@property (nonatomic, strong) NSString *detailUrl;
@property (nonatomic, strong) NSNumber *listPrice;
@property (nonatomic, assign) BOOL unavailableProduct;
@property (nonatomic, strong) NSArray<Ignore> *services;
@property (nonatomic, strong) NSArray<DeliveryType,Ignore> *deliveryTypes;
@property (nonatomic, strong) NSNumber *freightPrice;
@property (nonatomic, strong) NSNumber *oldFreightPrice;
@property (nonatomic, assign) BOOL markedToRemove;
@property (nonatomic, strong) NSString *vendorSkuId;
@property (nonatomic, strong) NSNumber *marketPlaceSku;
@property (nonatomic, strong) NSNumber *refId;
@property (nonatomic, assign) BOOL giftWrappable;
@property (nonatomic, strong) NSNumber *estimatedBestShippingPrice;
@property (nonatomic, strong) ShippingEstimate *estimatedBestShippingEstimate;
@property (nonatomic, strong) NSNumber *comission;
@property (nonatomic, strong) NSNumber *currentMaxQuantityBySellerAndSku;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, assign) BOOL kit;
@property (nonatomic, strong) NSString *skuName;
@property (nonatomic, strong) NSArray<Ignore> *kitItems;
@property (nonatomic, strong) NSArray<ProductCategory> *categories;
@property (nonatomic, strong) NSString *fullDescription;
@property (nonatomic, strong) NSArray<Ignore> *servicesIds;
@property (nonatomic, assign) BOOL service;
@property (nonatomic, assign) BOOL priceDivergentToLow;
@property (nonatomic, strong) NSNumber *createDateTime;
@property (nonatomic, assign) BOOL priceDivergent;
@property (nonatomic, strong) NSNumber<Optional> *categoryId;
@property (nonatomic, strong) NSNumber<Optional> *subCategoryId;
@property (nonatomic, strong) NSNumber<Optional> *departmentId;

- (instancetype)initWithItemKey:(NSString *)key quantity:(NSNumber *)quantity sellerId:(NSString *)sellerId;

@end
