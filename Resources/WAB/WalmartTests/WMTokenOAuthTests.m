//
//  WMTokenOAuthTests.m
//  Walmart
//
//  Created by Marcelo Santos on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "WMTokens.h"
#import "WMBTokenModel.h"

@interface WMTokenOAuthTests : XCTestCase {
    
@private
    WMTokens *tok;
    NSString *wordToTest;
}


@end

@implementation WMTokenOAuthTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    tok = [[WMTokens alloc] init];
    wordToTest = @"OAUTH TESTE";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    tok = nil;
    [tok deleteTokenOAuth];
}

- (void) DISABLED_testAddTokenOauth {
    
    NSString *strError = [NSString stringWithFormat:@"Token %@ Fail to persist", wordToTest];
    WMBTokenModel *token = [[WMBTokenModel alloc] initWithToken:wordToTest type:nil expiration:nil refreshToken:nil];
    XCTAssertTrue([tok addTokenOAuth:token], @"%@", strError);
}

- (void) DISABLED_testDeleteTokenOAuth {

    WMBTokenModel *token = [[WMBTokenModel alloc] initWithToken:wordToTest type:nil expiration:nil refreshToken:nil];
    [tok addTokenOAuth:token];
    [tok deleteTokenOAuth];
    
    NSString *strError = [NSString stringWithFormat:@"Token %@ not removed", wordToTest];
    XCTAssertEqualObjects([tok getTokenOAuthWithoutRefreshToken], @"", @"%@", strError);
}

@end
