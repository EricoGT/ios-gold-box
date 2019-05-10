//
//  DeliveryDetailView.h
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingDeliveryDetail.h"
#import "TrackingDeliveryDetailItem.h"
#import "TrackingOrderPayment.h"

@protocol DeliveryDetailViewDelegate <NSObject>
@optional
- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId;
@end

@interface DeliveryDetailView : TrackingViewWithXib

@property (weak) id <DeliveryDetailViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *deliveryLabel;

- (void)setupWithTracking:(TrackingDeliveryDetail *)tracking payment:(TrackingOrderPayment *)payment;

@end
