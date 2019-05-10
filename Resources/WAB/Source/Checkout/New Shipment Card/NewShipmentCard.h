//
//  NewShipmentCard.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingDelivery.h"
@class ShipmentOptions;
@class DeliveryItemView;

@protocol NewShipmentCardDelegate <NSObject>
@optional
- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId;
@end

@interface NewShipmentCard : UIView

@property (weak) id <NewShipmentCardDelegate> delegate;

@property (nonatomic, strong) ShipmentOptions *shipmentOptionsReference;
@property (nonatomic, strong) ShippingDelivery *shippingDelivery;
@property (nonatomic, strong) NSDictionary *currentShipmentDictionary;


+ (UIView *)viewWithXibName:(NSString *)xibName;
- (void)setShippingEstimate:(NSString *)shippingEstimate;
- (void)setDeliveryTitleText:(NSString *)currentDeliveryFormatted;
- (void)openDeliveryOptionsForDeliveryItemView:(DeliveryItemView *)item;
- (void)setupCardWithShippingDelivery:(ShippingDelivery *)shippingInfos
                        simpleVersion:(BOOL)simpleVersion
              showShipmentInformation:(BOOL)showShipmentInformation
                       showSellerName:(BOOL)showSellerName;

@end
