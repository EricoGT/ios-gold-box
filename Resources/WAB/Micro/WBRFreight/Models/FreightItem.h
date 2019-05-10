//
//  FreightItem.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "DeliveryType.h"
@protocol FreightItem
@end

@interface FreightItem : JSONModel
@property(nonatomic, strong) NSString *sellerId;
@property(nonatomic, strong) NSNumber *sku;
@property(nonatomic, strong) NSArray<DeliveryType>*deliveryTypes;

- (NSArray<DeliveryType> *)bestDeliveryTypeOption:(NSArray<DeliveryType>*)deliveryTypes;

@end
