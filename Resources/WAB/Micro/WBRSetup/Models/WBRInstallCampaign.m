//
//  WBRInstallCampaign.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/12/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRInstallCampaign.h"

@implementation WBRInstallCampaign

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"descriptionText" : @"description"
                                                                  }];
}

@end
