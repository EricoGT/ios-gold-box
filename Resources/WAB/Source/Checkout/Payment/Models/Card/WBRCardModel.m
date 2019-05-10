//
//  WBRCardModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCardModel.h"

@implementation WBRCardModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"cardId" : @"id",
                                                                  @"holderName": @"holder.name",
                                                                  @"holderDocument": @"holder.document",
                                                                  @"defaultCard": @"default"}];
}

@end
