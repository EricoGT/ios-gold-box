//
//  WBRContactRequestDeliveryModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "WBRContactRequestProductModel.h"
#import "TrackingSeller.h"

@protocol WBRContactRequestDeliveryModel
@end

@interface WBRContactRequestDeliveryModel : JSONModel

@property (strong, nonatomic) NSString *deliveryId;
@property (strong, nonatomic) NSArray<WBRContactRequestProductModel> *products;
@property (strong, nonatomic) TrackingSeller *seller;
@property (strong, nonatomic) NSNumber <Optional> *expiredDelivery;
@end
