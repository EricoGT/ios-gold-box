//
//  TrackingDeliveryDetail.h
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "TrackingDeliveryDetailItem.h"
#import "TrackingInfo.h"
#import "TrackingSeller.h"
#import "TrackingAddress.h"
#import "TrackingCode.h"

@protocol TrackingDeliveryDetail
@end

@interface TrackingDeliveryDetail : JSONModel

@property (nonatomic, strong) NSDate<Optional> *shippingEstimateDate;
@property (nonatomic, strong) NSDate<Optional> *expectedDeliveryDate;
@property (nonatomic, strong) NSString<Optional> *messageDate;
@property (nonatomic, strong) NSArray<TrackingDeliveryDetailItem> *items;
@property (nonatomic, strong) TrackingInfo *groupedTracking;
@property (nonatomic, strong) TrackingSeller *seller;
@property (nonatomic, strong) TrackingAddress *address;
@property (nonatomic, assign) NSNumber<Optional> *hasInvoice;
@property (nonatomic, strong) NSString<Optional> *invoiceUrl;
@property (nonatomic, strong) TrackingCode<Optional> *trackingCode;
@property (nonatomic, assign) BOOL conciergeDelayed;

@end
