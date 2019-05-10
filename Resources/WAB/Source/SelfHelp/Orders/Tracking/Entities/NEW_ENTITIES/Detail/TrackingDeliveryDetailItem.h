//
//  TrackingDeliveryDetailItem.h
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

@protocol TrackingDeliveryDetailItem
@end

#import "JSONModel.h"

@interface TrackingDeliveryDetailItem : JSONModel

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *originCountry;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, strong) NSNumber *acquiredQuantity;
@property (nonatomic, strong) NSString<Optional> *parentId;

@end
