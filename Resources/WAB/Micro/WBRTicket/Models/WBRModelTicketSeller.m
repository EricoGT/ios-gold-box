//
//  WBRModelTicketSeller.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 4/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRModelTicketSeller.h"

@implementation WBRModelTicketSeller

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sellerId" : @"id"}];
}

@end
