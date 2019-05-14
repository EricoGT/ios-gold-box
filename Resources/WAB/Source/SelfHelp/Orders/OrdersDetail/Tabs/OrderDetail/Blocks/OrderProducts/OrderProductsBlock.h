//
//  OrderProductsBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingOrderDetail.h"

@protocol OrderProductsBlockDelegate <NSObject>
@optional
- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId;
@end

@interface OrderProductsBlock : TrackingViewWithXib

@property (weak) id <OrderProductsBlockDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *currentAndTotalDeliveriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingDoneBy;
@property (weak, nonatomic) IBOutlet UILabel *shippingEstimated;

- (void)setupWithOrderDelivery:(TrackingDeliveryDetail *)delivery kits:(NSArray *)kits;

@end
