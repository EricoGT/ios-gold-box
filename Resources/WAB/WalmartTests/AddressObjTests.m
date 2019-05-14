//
//  AddressObjTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AddressObj.h"
#import "OFAddressTemp.h"

@interface AddressObjTests : XCTestCase {
    
    AddressObj *ao;
    OFAddressTemp *at;
    
    NSDictionary *dictCorrect;
}

@end

@implementation AddressObjTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    dictCorrect = [NSDictionary new];
    dictCorrect = @{@"id"             : @"123456",
                    @"receiverName"   : @"Walmart Brasil",
                    @"country"        : @"BR",
                    @"state"          : @"SP",
                    @"city"           : @"Barueri",
                    @"neighborhood"   : @"Alphaville",
                    @"street"         : @"Avenida Tamboré",
                    @"number"         : @"267",
                    @"complement"     : @"6o. andar",
                    @"postalCode"     : @"06485-370",
                    @"referencePoint" : @"Nenhum",
                    @"type"           : @"Comercial"
                    };
    
    at = [[OFAddressTemp alloc] init];
    [at assignAddressDictionary:dictCorrect];
}

-(void) testObjectDictionaty {
    
    ao = [[AddressObj alloc] init];
    
    NSDictionary *dictObject = @{@"id"             : ao.idDelivery,
                                 @"receiverName"   : ao.receiverName,
                                 @"country"        : ao.country,
                                 @"state"          : ao.state,
                                 @"city"           : ao.city,
                                 @"neighborhood"   : ao.neighborhood,
                                 @"street"         : ao.street,
                                 @"number"         : ao.number,
                                 @"complement"     : ao.complement,
                                 @"postalCode"     : ao.postalCode,
                                 @"referencePoint" : ao.referencePoint,
                                 @"type"           : ao.type
                                 };
    
    LogInfo(@"Address Correct: %@", dictCorrect);
    LogInfo(@"Address Object : %@", dictObject);
    
    XCTAssertTrue([dictObject isEqualToDictionary:dictCorrect], @"Dictionaries should be equal!");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    ao = nil;
    [super tearDown];
}

@end
