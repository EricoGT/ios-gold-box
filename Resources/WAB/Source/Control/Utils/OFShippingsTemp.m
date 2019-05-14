//
//  OFShippingsTemp.m
//  Ofertas
//
//  Created by Marcelo Santos on 09/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFShippingsTemp.h"
#import "DeliveryItemView.h"

@implementation OFShippingsTemp

static NSString *strJson;
static DeliveryItemView *deliveryView;

- (void) assignShipJson:(NSString *) jsonShipping {
    
    strJson = [[NSString alloc] initWithString:jsonShipping];
}
+ (NSString *) getShippingsJson {
    
    return strJson;
}

- (void)setDeliveryType:(DeliveryItemView *)deliveryItemView
{
    deliveryView = deliveryItemView;
}

+ (DeliveryItemView *)deliveryItemView
{
    return deliveryView;
}

@end
