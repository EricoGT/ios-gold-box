//
//  WBRShipmentConnection.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelCheckoutDelivery.h"

@interface WBRShipmentConnection : NSObject

- (void) requestDeleteShipment:(ModelCheckoutDelivery *)delivery success:(void (^)(void))success failure:(void (^)(NSError *error, NSData *dataError))failure;

@end
