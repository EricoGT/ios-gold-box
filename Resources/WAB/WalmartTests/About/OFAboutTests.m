//
//  OFAboutTests.m
//  Walmart
//
//  Created by Marcelo Santos on 2/22/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OFAboutViewController.h"

@interface OFAboutTests : XCTestCase
@property (nonatomic, strong) OFAboutViewController *ofa;
@end

@interface OFAboutViewController (Tests)
- (NSString *)UTMIIdentifier;
@end

@implementation OFAboutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _ofa = [[OFAboutViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _ofa = nil;
    
    [super tearDown];
}

- (void)testInit {
    
    NSDictionary *skinDict = @{@"test" : @"test"};
    [_ofa setDictSkin:skinDict];
    
    XCTAssertEqualObjects(_ofa.dictSkin, skinDict, @"FAIL: <%@>", _ofa.dictSkin);
}

- (void)testUtmiIdentifier {
    
    XCTAssert([[_ofa UTMIIdentifier] isEqualToString:@"explore-app"], @"FAIL: <%@>", [_ofa UTMIIdentifier]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
