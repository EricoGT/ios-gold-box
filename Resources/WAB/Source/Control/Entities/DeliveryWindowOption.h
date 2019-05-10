//
//  DeliveryWindowOption.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol DeliveryWindowOption
@end

@interface DeliveryWindowOption : JSONModel

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, strong) NSNumber *startDateUtc;
@property (nonatomic, strong) NSNumber *endDateUtc;

@end
