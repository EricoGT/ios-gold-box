//
//  OFShippingsTemp.h
//  Ofertas
//
//  Created by Marcelo Santos on 09/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeliveryItemView;

@interface OFShippingsTemp: NSObject

- (void) assignShipJson:(NSString *) jsonShipping;
+ (NSString *) getShippingsJson;

- (void)setDeliveryType:(DeliveryItemView *)deliveryItemView;
+ (DeliveryItemView *)deliveryItemView;

@end
