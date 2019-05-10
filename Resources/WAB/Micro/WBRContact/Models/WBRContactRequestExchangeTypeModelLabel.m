//
//  WBRContactRequestExchangeTypeModelLabel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactRequestExchangeTypeModelLabel.h"

@implementation WBRContactRequestExchangeTypeModelLabel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"exchangeTypeLabel" : @"label"}];
}

@end
