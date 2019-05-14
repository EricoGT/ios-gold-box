//
//  AllShoppingConnectionTests.m
//  Walmart
//
//  Created by Marcelo Santos on 2/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AllShoppingConnection.h"
#import "OCMock.h"

@interface AllShoppingConnectionTests : XCTestCase
@property (nonatomic,strong) AllShoppingConnection *asc;
@end

@interface AllShoppingConnection (Tests)
@end

@implementation AllShoppingConnectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.asc = [[AllShoppingConnection alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.asc = nil;
    
    [super tearDown];
}

- (void)testLoadAllShoppingWithCompletionBlock {
    
    NSArray *arrAllShopping = @[@"fake1", @"fake2"];
    
    id myMock = [OCMockObject mockForClass:[_asc class]];
    [[[myMock stub] andDo:^(NSInvocation *invocation) {
        
        void (^responseHandler)(NSArray *success)= nil;
        [invocation getArgument:&responseHandler atIndex:2];
        responseHandler(arrAllShopping);
        
    }] loadAllShoppingWithCompletionBlock:[OCMArg any] failure:[OCMArg any]];
    
    [myMock loadAllShoppingWithCompletionBlock:^(NSArray *categories) {
        XCTAssertEqualObjects(categories, arrAllShopping, @"All Shopping: <%@>", categories);
    } failure:^(NSError *error) {
        
    }];
    
    //Last, update XCTest
    [_asc loadAllShoppingWithCompletionBlock:^(NSArray *categories) {
    } failure:^(NSError *error) {
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
