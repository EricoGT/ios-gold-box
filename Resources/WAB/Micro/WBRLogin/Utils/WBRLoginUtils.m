//
//  WBRLoginUtils.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 05/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRLoginUtils.h"

@implementation WBRLoginUtils

+ (NSArray *)defaultFacebookPermissions {
    return  @[@"email", @"public_profile"];
}

@end
