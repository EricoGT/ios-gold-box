//
//  TrackingDeliveryDetail.m
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingDeliveryDetail.h"

@implementation TrackingDeliveryDetail

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return ([propertyName isEqualToString:@"conciergeDelayed"]);
}

@end
