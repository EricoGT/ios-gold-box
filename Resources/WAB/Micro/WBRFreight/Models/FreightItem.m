//
//  FreightItem.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "FreightItem.h"

@implementation FreightItem

- (NSArray<DeliveryType> *)bestDeliveryTypeOption:(NSArray<DeliveryType>*)deliveryTypes {
    NSSortDescriptor *priceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
    NSSortDescriptor *estimateDaysSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"shippingEstimateInDays" ascending:YES];
    
    NSArray *results = [deliveryTypes sortedArrayUsingDescriptors:[NSArray arrayWithObjects:priceSortDescriptor, estimateDaysSortDescriptor, nil]];

    NSArray<DeliveryType> *resultFinal = (NSArray<DeliveryType> *)results;
    
    return  resultFinal;
    
}

@end
