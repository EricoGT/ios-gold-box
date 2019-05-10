//
//  ModelCheckoutDelivery.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ModelCheckoutDelivery.h"

@implementation ModelCheckoutDelivery

- (instancetype)initWithItemsToDelete:(NSArray<CartItem> *)items {
    self = [super init];
    
    if (self) {
        self.items = items;
        self.selectedDeliveries = @[];
        self.giftCard = nil;
        self.splitServicePayment = NO;
    }
    
    return self;
}

@end
