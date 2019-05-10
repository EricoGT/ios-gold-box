//
//  OFShipmentTemp.m
//  Ofertas
//
//  Created by Marcelo Santos on 26/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFShipmentTemp.h"

@implementation OFShipmentTemp

static NSDictionary *dictShipment;
static NSDictionary *selectedShipping;
static NSArray *currentDeliveries;
static NSArray *cart;
static CardShippingAddressViewController *viewDeliveryAddress;

- (void) assignShipmentDictionary:(NSDictionary *) dict {
    
    dictShipment = [[NSDictionary alloc] initWithDictionary:dict];
}

- (NSDictionary *) getShipmentDictionary {
    
    return dictShipment;
}

- (void)assignSelectedShipmentDetails:(NSDictionary *)dict
{
    selectedShipping = [[NSDictionary alloc] initWithDictionary:dict];
}

- (NSDictionary *)getSelectedShipmentDetails
{
    return selectedShipping;
}

- (void)assignDeliveries:(NSArray *)deliveries
{
    currentDeliveries = deliveries;
}

- (NSArray *)getDeliveries
{
    return currentDeliveries;
}

- (void)resetDeliveries {
//    dictShipment = nil;
    selectedShipping = nil;
//    currentDeliveries = nil;
}

- (void) assignCardDeliverieAddress:(CardShippingAddressViewController *) viewAddress {
    
    viewDeliveryAddress = viewAddress;
}

- (CardShippingAddressViewController *) getViewDeliveryAddressCard {
    
    return viewDeliveryAddress;
}

- (void)assignCartItems:(NSArray *)cartItems {
    cart = cartItems;
}

- (NSArray *)getCartItens {
    return cart;
}

@end
