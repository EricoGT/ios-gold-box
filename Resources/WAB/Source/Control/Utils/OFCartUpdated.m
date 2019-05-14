//
//  OFCartUpdated.m
//  Ofertas
//
//  Created by Marcelo Santos on 16/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFCartUpdated.h"

@implementation OFCartUpdated

static NSArray *arrProdsUpdated;
static NSDictionary *dictConf;

- (void) assignProductUpdated:(NSArray *) arrProds {
    
    arrProdsUpdated = [NSArray arrayWithArray:arrProds];
}

- (NSArray *) getAllProductsUpdated {
    
    return arrProdsUpdated;
}

- (void) assignDictConfirmation:(NSDictionary *) dictConfirmation {
    
    dictConf = [NSDictionary dictionaryWithDictionary:dictConfirmation];
}

- (NSDictionary *) getConfirmationInfo {
    
    return dictConf;
}


@end
