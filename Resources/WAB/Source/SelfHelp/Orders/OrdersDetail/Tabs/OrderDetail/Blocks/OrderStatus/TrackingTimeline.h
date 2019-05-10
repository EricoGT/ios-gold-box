//
//  TrackingTimeline.h
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"

@protocol TrackingTimelineDelegate

@end

@class TrackingOrderPayment;

@interface TrackingTimeline : TrackingViewWithXib

@property (nonatomic, assign) BOOL hasInvoice;
@property (nonatomic, strong) NSString *invoiceUrl;
@property (strong, nonatomic) NSString *barcodeURL;

- (void)setupWithItems:(NSArray *)items payment:(TrackingOrderPayment *)payment;

@end
