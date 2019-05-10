//
//  WBRModelCreditCard.m
//  Walmart
//
//  Created by Rafael Valim on 27/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRModelCreditCard.h"

@implementation WBRModelCreditCard

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"flagDefault":@"default"}];
}

@end
