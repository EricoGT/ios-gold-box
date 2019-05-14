//
//  TrackingOrderItem.h
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
@protocol TrackingOrderItem
@end

@interface TrackingOrderItem : JSONModel

@property (nonatomic, strong) NSString *orderItemId;
@property (nonatomic, strong) NSString *orderItemDescription;
@property (nonatomic, strong) NSNumber *canceledQuantity;
@property (nonatomic, strong) NSString *originCountry;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL returnable;

@end
