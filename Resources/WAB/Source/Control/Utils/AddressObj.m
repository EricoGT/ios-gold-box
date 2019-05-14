//
//  AddressObj.m
//  Walmart
//
//  Created by Marcelo Santos on 6/9/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved..
//

#import "AddressObj.h"
#import "OFAddressTemp.h"

@implementation AddressObj

//- (id)initWithModelToJSONDictionary:(NSDictionary *) dict {
//    
//    if ((self = [super init])) {
//        
//        _street = [dict objectForKey:@"street"];
//    }
//    return self;
//}

- (id)init {
    
    if (self = [super init]) {
        
        OFAddressTemp *oat = [OFAddressTemp new];
        NSDictionary *dict = [oat getAddressDictionary];
        
        _idDelivery = [dict objectForKey:@"id"];
        _receiverName = [dict objectForKey:@"receiverName"];
        _country = [dict objectForKey:@"country"];
        _state = [dict objectForKey:@"state"];
        _city = [dict objectForKey:@"city"];
        _neighborhood = [dict objectForKey:@"neighborhood"];
        _street = [dict objectForKey:@"street"];
        _number = [dict objectForKey:@"number"];
        _complement = [dict objectForKey:@"complement"];
        _postalCode = [dict objectForKey:@"postalCode"];
        _referencePoint = [dict objectForKey:@"referencePoint"];
        _type = [dict objectForKey:@"type"];
        //_description = [dict objectForKey:@"description"];
        
    }
    return self;
}


@end
