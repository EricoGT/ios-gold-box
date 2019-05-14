//
//  WMBaseModelTests.m
//  Walmart
//
//  Created by Marcelo Santos on 3/1/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WMBaseModel.h"

@interface WMBaseModelTests : XCTestCase
@end

@interface WMBaseModel (Tests)
+ (id)jsonFromFileNamed:(NSString *)fileName;
@end

@implementation WMBaseModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void)DISABLED_testjsonFromFileNamed {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"globaldelivery" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    id jsonString = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    XCTAssertTrue([[WMBaseModel jsonFromFileNamed:@"globaldelivery"] isEqual:jsonString]);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
