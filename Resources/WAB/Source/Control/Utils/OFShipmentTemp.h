//
//  OFShipmentTemp.h
//  Ofertas
//
//  Created by Marcelo Santos on 26/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardShippingAddressViewController.h"

@interface OFShipmentTemp : NSObject

- (void)assignSelectedShipmentDetails:(NSDictionary *)dict;
- (NSDictionary *)getSelectedShipmentDetails;

- (void) assignShipmentDictionary:(NSDictionary *) dict;
- (NSDictionary *) getShipmentDictionary;

- (void)assignDeliveries:(NSArray *)deliveries;
- (NSArray *)getDeliveries;

- (void)assignCartItems:(NSArray *)cartItems;
- (NSArray *)getCartItens;

- (void)resetDeliveries;

- (void) assignCardDeliverieAddress:(CardShippingAddressViewController *) viewAddress;
- (CardShippingAddressViewController *) getViewDeliveryAddressCard;

@end
