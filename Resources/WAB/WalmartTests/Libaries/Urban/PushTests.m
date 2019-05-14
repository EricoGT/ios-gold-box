//
//  PushTests.m
//  Walmart
//
//  Created by Marcelo Santos on 11/24/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PushTests : XCTestCase

@end

@implementation PushTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)DISABLED_testPushFiles {
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AirshipConfig" ofType:@"plist"];
//    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
//    NSPropertyListFormat plistFormat;
//    NSString *strerrorDesc = nil;
//    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&plistFormat errorDescription:&strerrorDesc];
//    NSLog(@"temp: %@", temp);
//    //Correct: OxcuCn1FSLOpTjAA9cx-Mw
//    NSString *strAppKey = [temp objectForKey:@"productionAppKey"];
//    XCTAssertTrue([strAppKey isEqualToString:@"OxcuCn1FSLOpTjAA9cx-Mw"]);
}

- (void)DISABLED_testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
