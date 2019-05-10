//
//  ExtendedWarranty.m
//  Walmart
//
//  Created by Renan Cargnin on 1/27/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarranty.h"

@implementation ExtendedWarranty

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"extendedWarrantyId" : @"id",
                                                                  @"instalment" : @"price.installmentAmount",
                                                                  @"instalmentValue" : @"price.valuePerInstallment",
                                                                  @"price" : @"price.sellPrice"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"showRecommended"];
}

@end
