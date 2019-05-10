//
//  OFCardPayTemp.m
//  Walmart
//
//  Created by Marcelo Santos on 6/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFCardPayTemp.h"

@implementation OFCardPayTemp

static NSDictionary *dict;

- (void) assignCardValue:(NSDictionary *) dictValues {
    
    dict = [[NSDictionary alloc] initWithDictionary:dictValues];
}

- (NSDictionary *) getCardValue {
    
    return dict;
}

@end
