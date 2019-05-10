//
//  DAOChanges.m
//  Walmart
//
//  Created by Marcelo Santos on 5/31/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDSSqlite.h"

@interface DAOChanges : XCTestCase {
    
    @private
    MDSSqlite *sq;
}

@end

@implementation DAOChanges

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    sq = [[MDSSqlite alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    sq = nil;
}

//- (void) testDBAddTableTKS {
//    
//    BOOL okTable = [sq verifyByTable:@"tks"];
//    XCTAssertTrue(okTable, @"");
//}

- (void) DISABLED_testDBTables {
    
    BOOL okCart = [sq verifyByTable:@"cart"];
    XCTAssertTrue(okCart, @"Table CART fail!");
    
    BOOL okSkin = [sq verifyByTable:@"skin"];
    XCTAssertTrue(okSkin, @"Table SKIN fail!");
    
    BOOL okSplash = [sq verifyByTable:@"splash"];
    XCTAssertTrue(okSplash, @"Table SPLASH fail!");
    
    BOOL okTkOAuth = [sq verifyByTable:@"tkOAuth"];
    XCTAssertTrue(okTkOAuth, @"Table TKOAUTH fail!");
    
    BOOL okTkCheck = [sq verifyByTable:@"tkCheck"];
    XCTAssertTrue(okTkCheck, @"Table TKCHECK fail!");
    
    BOOL okCartId = [sq verifyByTable:@"cartId"];
    XCTAssertTrue(okCartId, @"Table CARTID fail!");
}


@end
