//
//  ExtendedWarrantyCancelTicket.m
//  Walmart
//
//  Created by Bruno on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyCancelTicket.h"

@implementation ExtendedWarrantyCancelTicket

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.warrantyNumber forKey:@"warrantyNumber"];
    [encoder encodeObject:self.protocolNumber forKey:@"protocolNumber"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        self.warrantyNumber = [decoder decodeObjectForKey:@"warrantyNumber"];
        self.protocolNumber = [decoder decodeObjectForKey:@"protocolNumber"];
    }
    return self;
}

@end
