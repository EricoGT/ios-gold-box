//
//  ModelProducts.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelProductsPrice.h"

@protocol ModelProducts
@end

@interface ModelProducts : JSONModel

@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber *skuId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageId;
@property (strong, nonatomic) NSNumber *hasMoreOffers;
@property (strong, nonatomic) NSNumber *hasSkuOptions;
@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) ModelProductsPrice *price;
@property (strong, nonatomic) NSNumber<Optional> *hasReview;

@end
