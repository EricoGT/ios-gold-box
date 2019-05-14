//
//  ShippingDelivery.h
//  Walmart
//
//  Created by Bruno Delgado on 6/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "ShippingDelivery.h"

@interface ShippingDeliveries : JSONModel

@property (nonatomic, strong) NSArray<ShippingDelivery> *deliveries;
@property (nonatomic, strong) NSString<Ignore> *cookies;
@property (nonatomic, strong) NSNumber<Optional> *totalPrice;

@end
