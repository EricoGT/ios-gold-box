//
//  SellerOptionModel.m
//  Walmart
//
//  Created by Renan Cargnin on 9/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "SellerOptionModel.h"

@implementation SellerOptionModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"productName": @"name",
                                                                  @"name": @"seller.name",
                                                                  @"sellerId": @"seller.id",
                                                                  @"quantityAvailable": @"quantity",
                                                                  @"originalPrice": @"price.listPrice",
                                                                  @"discountPrice": @"price.sellPrice",
                                                                  @"instalment": @"price.installmentAmount",
                                                                  @"instalmentValue": @"price.valuePerInstallment",
                                                                  @"paymentTypes": @"price.paymentTypes",
                                                                  @"paymentSuggestion": @"suggestion"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return [propertyName isEqualToString:@"wishlist"];
}

@end
