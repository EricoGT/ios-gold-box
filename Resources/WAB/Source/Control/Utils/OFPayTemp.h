//
//  OFPayTemp.h
//  Ofertas
//
//  Created by Marcelo Santos on 15/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFPayTemp : NSObject

- (void) assignPay:(NSDictionary *) dictPay;
- (NSDictionary *) getPay;

- (void) assignArrayPay:(NSArray *) arrPayReceived;
- (NSArray *) getArrPay;

@end
