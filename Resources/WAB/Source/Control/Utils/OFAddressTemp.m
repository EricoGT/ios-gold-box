
//
//  OFAddressTemp.m
//  Ofertas
//
//  Created by Marcelo Santos on 27/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFAddressTemp.h"
#import "AddressObj.h"

@implementation OFAddressTemp

static NSDictionary *dictAddress;

- (void) assignAddressDictionary:(NSDictionary *) dict {
    
    dictAddress = [[NSDictionary alloc] initWithDictionary:dict];
}

- (NSDictionary *) getAddressDictionary {
    
    return dictAddress;
}


@end
