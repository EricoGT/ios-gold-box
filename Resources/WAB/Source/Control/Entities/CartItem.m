//
//  CartItem.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "CartItem.h"

@implementation CartItem

- (instancetype)initWithItemKey:(NSString *)key quantity:(NSNumber *)quantity sellerId:(NSString *)sellerId {
    self = [super init];
    
    if (self) {
        self.key = key;
        self.quantity = quantity;
        self.sellerId = sellerId;
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"productDescription" : @"description"}];
}

@end
