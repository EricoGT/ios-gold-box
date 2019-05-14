//
//  ExtendedWarrantyProduct.m
//  Walmart
//
//  Created by Renan Cargnin on 1/27/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyProduct.h"

@implementation ExtendedWarrantyProduct

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"isActive" : @"active",
                                                                  @"sku" : @"skuId",
                                                                  @"isKit" : @"kit"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isActive"] || [propertyName isEqualToString:@"isKit"];
}

- (void)setExtendedWarranties:(NSArray<ExtendedWarranty,Optional> *)extendedWarranties {
    ExtendedWarranty *noWarranty = [[ExtendedWarranty alloc] initWithDictionary:@{@"isAtive": @YES,
                                                                                  @"months": @0,
                                                                                  @"instalment": @0,
                                                                                  @"id": @0,
                                                                                  @"warrantyType": @"",
                                                                                  @"price": @0,
                                                                                  @"idSku": @0,
                                                                                  @"type": @"GARANTIA_ESTENDIDA",
                                                                                  @"name": @"",
                                                                                  @"instalmentValue": @0} error:NULL];
    NSMutableArray *mutableArray = [NSMutableArray new];
    [mutableArray addObject:noWarranty];
    [mutableArray addObjectsFromArray:extendedWarranties];
    
    ExtendedWarranty *lastWarranty = mutableArray.lastObject;
    lastWarranty.showRecommended = YES;
    
    _warranties = mutableArray.copy;
}

@end
