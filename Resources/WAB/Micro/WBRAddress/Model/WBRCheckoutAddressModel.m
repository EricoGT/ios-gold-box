//
//  WBRCheckoutAddressModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCheckoutAddressModel.h"

@implementation WBRCheckoutAddressModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"defaultAddress"     : @"default",
                                                                  @"descriptionAddress" : @"description"
                                                                  }];
}

@end
