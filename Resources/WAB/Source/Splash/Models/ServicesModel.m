//
//  ServicesModel.m
//  Walmart
//
//  Created by Renan Cargnin on 8/18/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "ServicesModel.h"

@implementation ServicesModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"tracking"              : @"services.tracking",
                                                                  @"showDepartmentsOnMenu" : @"services.showDepartmentsOnMenu",
                                                                  @"paymentByBankSlip"     : @"services.paymentByBankSlip",
                                                                  @"showWarranties"        : @"services.showWarranties",
                                                                  @"isCouponEnabled"       : @"services.isCouponEnabled",
                                                                  @"masterCampaign"        : @"services.masterCampaign"
                                                                  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
