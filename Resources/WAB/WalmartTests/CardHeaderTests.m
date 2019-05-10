//
//  CardHeaderTests.m
//  Walmart
//
//  Created by Marcelo Santos on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardHeader.h"

@interface CardHeaderTests : XCTestCase
@property (nonatomic, strong) CardHeader *chd;
@property (nonatomic, weak) NSString *strForTestHeader;
@property (nonatomic, weak) NSString *strForTestHeader2;
@property (nonatomic, weak) NSString *strForTestHeader3;
@end

@implementation CardHeaderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _strForTestHeader = @"Card Header Test";
    _strForTestHeader2 = @"Card Header Test 2";
    _strForTestHeader3 = @"Card Header Test 3";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _chd = nil;
    
    [super tearDown];
}

- (void)testTitleForHeader {
    
    self.chd = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:_strForTestHeader];
    
    XCTAssertTrue([_chd.strTitle isEqualToString:_strForTestHeader], @"Header different. Check variable for <strTitle>!");
}

- (void)testLabelFormatAndContent {
    
    self.chd = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:_strForTestHeader2];
    
    [_chd viewDidLoad];
    
    XCTAssertTrue([_chd.strTitle isEqualToString:_strForTestHeader2], @"Header different. Check variable for <strTitle>!");
}

- (void)testFillLabelWithContent {
    
    self.chd = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:_strForTestHeader3];
    
    [_chd fillLabelWithContent];
    
    XCTAssertTrue([_chd.strTitle isEqualToString:_strForTestHeader3], @"Header different. Check variable for <strTitle>!");
}

@end
