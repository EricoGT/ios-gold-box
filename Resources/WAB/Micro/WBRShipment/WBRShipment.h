//
//  WBRShipment.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRShipmentConnection.h"

@interface WBRShipment : NSObject


/**
 Delete shipment from shipments list on checkout flow

 @param delivery Shipment to be removed from cart
 @param success Success callback
 @param failure NSError and NSData
 */
- (void)deleteShipment:(ModelCheckoutDelivery *)delivery success:(void (^)(void))success failure:(void (^)(NSError *error, NSData *data))failure;

@end
