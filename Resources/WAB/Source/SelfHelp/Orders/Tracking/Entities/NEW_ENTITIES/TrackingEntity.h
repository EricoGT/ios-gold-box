//
//  TrackingEntity.h
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "TrackingOrder.h"

@interface TrackingEntity : JSONModel

@property (nonatomic, strong) NSArray<TrackingOrder> *orders;

@end
