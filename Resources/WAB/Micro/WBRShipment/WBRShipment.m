//
//  WBRShipment.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRShipment.h"

@implementation WBRShipment

- (void)deleteShipment:(ModelCheckoutDelivery *)delivery success:(void (^)(void))success failure:(void (^)(NSError *error, NSData *data))failure {
    WBRShipmentConnection *conn = [[WBRShipmentConnection alloc] init];
    [conn requestDeleteShipment:delivery success:success failure:failure];
}

@end
