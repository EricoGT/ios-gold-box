//
//  ModelShelfItems.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelPrice.h"

@protocol ModelShelfItems
@end

@interface ModelShelfItems : JSONModel

@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber *skuId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageId;
@property (strong, nonatomic) NSNumber *hasMoreOffers;
@property (strong, nonatomic) NSNumber *hasSkuOptions;
@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) ModelPrice *price;

@end
