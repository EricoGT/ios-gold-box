//
//  OFPayTemp.m
//  Ofertas
//
//  Created by Marcelo Santos on 15/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFPayTemp.h"

@implementation OFPayTemp

static NSDictionary *dict;
static NSArray *arrPay;

- (void) assignPay:(NSDictionary *)dictPay {
    
    dict = [[NSDictionary alloc] initWithDictionary:dictPay];
}

- (NSDictionary *) getPay {
    
    return dict;
}

- (void) assignArrayPay:(NSArray *) arrPayReceived {
    arrPay = arrPayReceived;
}

- (NSArray *) getArrPay {
    
    return arrPay;
}

@end
