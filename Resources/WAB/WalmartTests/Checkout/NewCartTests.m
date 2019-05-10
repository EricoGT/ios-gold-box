//
//  NewCartTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/28/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NewCartViewController.h"
#import "WMTokens.h"

@interface NewCartTests : XCTestCase {
    
    @private
    NewCartViewController *nc;
    WMTokens *tok;
}

@end

@implementation NewCartTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    nc = [[NewCartViewController alloc] init];
    [nc view];
    
    tok = [[WMTokens alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void) testShowLoginScreen {
//    
//    //Test with Token
//    LogInfo(@"Before 1: %i", nc.showLoginScreen);
//    [tok addTokenOAuth:@"1234-56789-abcde"];
//    nc = [[NewCartViewController alloc] init];
//    [nc view];
//    [nc buyOrder];
//    
//    BOOL showLoginScreen = [self verifyShowLoginScreen];
//    
//    XCTAssertFalse(showLoginScreen, @"Login Screen should NOT be presented!");
//}

- (void) testNoShowLoadingScreen {
    
    //Test without Token
    LogInfo(@"Before: %i", nc.showLoginScreen);
    WMBTokenModel *token = [[WMBTokenModel alloc] initWithToken:@"token" type:nil expiration:nil refreshToken:nil];
    [tok addTokenOAuth:token];
    nc = [[NewCartViewController alloc] init];
    [nc view];
    [nc buyOrder];
    
    BOOL showLoginScreen = [self verifyShowLoginScreen];
    
    XCTAssertTrue(showLoginScreen, @"Login Screen should BE presented!");
}

- (BOOL) verifyShowLoginScreen {
    [NSThread sleepForTimeInterval:1.0];
    return nc.showLoginScreen;
}

@end
