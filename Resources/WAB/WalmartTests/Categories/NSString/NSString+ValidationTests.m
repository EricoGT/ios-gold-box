//
//  NSString+ValidationTests.m
//  Walmart
//
//  Created by Renan Cargnin on 3/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+Validation.h"

@interface NSString_ValidationTests : XCTestCase

@end

@implementation NSString_ValidationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmail {
    XCTAssertTrue([@"teste@teste.com" isEmail]);
    XCTAssertTrue([@"a@b.com" isEmail]);
    XCTAssertTrue([@"abc@abc.com.br" isEmail]);
    
    XCTAssertFalse([@"123teste.com" isEmail]);
    XCTAssertFalse([@"123@teste" isEmail]);
}

- (void)testCPF {
    XCTAssertTrue([@"710.982.860-30" isCPF]);
    XCTAssertTrue([@"40476628873" isCPF]);
    
    XCTAssertFalse([@"12345678999" isCPF]);
    XCTAssertFalse([@"123.456.789-99" isCPF]);
}

- (void)testCNPJ {
    XCTAssertTrue([@"38.537.467/0001-48" isCNPJ]);
    XCTAssertTrue([@"38537467000148" isCNPJ]);
    
    XCTAssertFalse([@"12.345.678/9101-11" isCNPJ]);
    XCTAssertFalse([@"12345678910111" isCNPJ]);
}

- (void)testPhone {
    XCTAssertTrue([@"(11)1234-5678" isPhone]);
    XCTAssertTrue([@"(11)12345678" isPhone]);
    XCTAssertTrue([@"111234-5678" isPhone]);
    XCTAssertTrue([@"1112345678" isPhone]);
    XCTAssertTrue([@"(11) 1234-5678" isPhone]);
    XCTAssertTrue([@"(11) 12345678" isPhone]);
    XCTAssertFalse([@"testPhone" isPhone]);
    XCTAssertFalse([@"(11) 12345-6789" isPhone]);
    XCTAssertFalse([@"1234" isPhone]);
}

- (void)testMobilePhone {
    XCTAssertTrue([@"(11)12345-5678" isMobilePhone]);
    XCTAssertTrue([@"(11)123455678" isMobilePhone]);
    XCTAssertTrue([@"1112345-5678" isMobilePhone]);
    XCTAssertTrue([@"11123456789" isMobilePhone]);
    XCTAssertTrue([@"(11) 12345-5678" isMobilePhone]);
    XCTAssertTrue([@"(11) 123456789" isMobilePhone]);
    XCTAssertFalse([@"testPhone" isMobilePhone]);
    XCTAssertFalse([@"(11) 123-6789" isMobilePhone]);
    XCTAssertFalse([@"1234" isMobilePhone]);
}

- (void)testName {
    XCTAssertTrue([@"Name" isName]);
    XCTAssertTrue([@"Name Lastname" isName]);
    XCTAssertTrue([@"Name Lastname Nickname" isName]);
    XCTAssertTrue([@"name" isName]);
    XCTAssertTrue([@"name lastname" isName]);
    XCTAssertTrue([@"name lastname nickname" isName]);
    XCTAssertFalse([@"Name (Nickname)" isName]);
    XCTAssertFalse([@"Name 123" isName]);
    XCTAssertFalse([@"Name123" isName]);
    XCTAssertFalse([@"Name Lastname1" isName]);
}

@end
