//
//  WBRContactRequestOrdersArrayModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 4/16/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactRequestOrdersArrayModel.h"

@implementation WBRContactRequestOrdersArrayModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"orders"]) {
        return YES;
    }
    
    return NO;
}

@end
