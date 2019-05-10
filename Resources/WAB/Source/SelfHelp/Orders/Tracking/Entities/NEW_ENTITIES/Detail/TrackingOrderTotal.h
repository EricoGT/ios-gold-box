//
//  TrackingOrderTotal.h
//  Walmart
//
//  Created by Bruno Delgado on 10/9/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

@protocol TrackingOrderTotal
@end

#import "JSONModel.h"

@interface TrackingOrderTotal : JSONModel

@property (nonatomic, strong) NSNumber *currencyAmount;
@property (nonatomic, strong) NSString *currencyUnit;
@property (nonatomic, strong) NSNumber *itemsPrice;
@property (nonatomic, strong) NSNumber *shipping;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber<Optional> *taxImport;
@property (nonatomic, strong) NSNumber<Optional> *warranty;
@property (nonatomic, strong) NSNumber<Optional> *services;

@end
