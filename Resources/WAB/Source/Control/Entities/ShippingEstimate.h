//
//  ShippingEstimate.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol ShippingEstimate
@end

@interface ShippingEstimate : JSONModel

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *timeUnit;

@end
