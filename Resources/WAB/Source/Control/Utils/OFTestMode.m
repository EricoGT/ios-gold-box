//
//  OFTestMode.m
//  Ofertas
//
//  Created by Marcelo Santos on 08/12/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFTestMode.h"

@implementation OFTestMode

static BOOL testMode;

- (void) assignTestMode:(BOOL) test {
    
    testMode = test;
}

- (BOOL) testMode {
    
    return testMode;
}

@end
