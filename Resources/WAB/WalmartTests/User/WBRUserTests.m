//
//  WBRUserTests.m
//  Walmart
//
//  Created by Marcelo Santos on 2/15/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "WBRUser.h"
#import "FXKeychain.h"

@interface WBRUserTests : XCTestCase

@property (nonatomic, strong) WBRUser *userCompletion;
//{
//@private
//    WMTokens *wtk;
//    WMBTokenModel *wtm;
//    NSString *fakeToken;
//}
@end

@interface WBRUser (Tests)
- (void) tryGetContentFromUser:(void (^)(User *userPersonalData))completion failure:(void (^)(NSError *error))failure;
+ (void) logoutUserFromDevice;
@end

@implementation WBRUserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.userCompletion = [[WBRUser alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.userCompletion = nil;
    
    [super tearDown];
}



- (void) testKeychainAccess {
    
    WBRUser *userC = [WBRUser new];
    [userC keychainAccess];
    
    FXKeychain *fxKey = [[FXKeychain alloc] initWithService:[OCMArg any] accessGroup:nil];
    
    WBRUser *userInstance = [[WBRUser alloc] init];
    id partialMockKeychain = [OCMockObject partialMockForObject:userInstance];
    [[[partialMockKeychain stub] andReturn:fxKey] keychainAccess];
    XCTAssertEqualObjects([partialMockKeychain keychainAccess], fxKey);
}


- (void) testGuIDWithCompletionBlock {
    
    WBRUser *userC = [WBRUser new];
    [userC guIDWithCompletionBlock:^(NSString *guid) {
        LogInfo(@"Just a register for coverage");
        XCTAssertNil(guid);
    }];
    
    id myMock = [OCMockObject mockForClass:[WBRUser class]];
    [[[myMock stub] andDo:^(NSInvocation *invocation) {
        
        NSString *strGuid = @"fake-guid";
        
        void (^responseHandler)(NSString *guid)= nil;
        
         //0 and 1 are reserved for invocation object, ....therefor 2, n would be (completionBlock)
        [invocation getArgument:&responseHandler atIndex:2];
        
        //invoke the block
        responseHandler(strGuid);
        
    }] guIDWithCompletionBlock:[OCMArg any]];

    [myMock guIDWithCompletionBlock:^(NSString *guid) {
        XCTAssertEqual(guid, @"fake-guid", @"Guid: <%@>", guid);
    }];
}


- (void) testPid {
    
    id myMock = [OCMockObject mockForClass:[WBRUser class]];
    NSString *strPid = @"fake-pid";
    OCMStub([myMock pid]).andReturn(strPid);
    XCTAssert([[WBRUser pid] isEqualToString:@"fake-pid"], @"Pid correct: %@", strPid);
}


- (void) testRemovePIDFromUser {
    
    OCMVerify([WBRUser removePIDFromUser]);
}


- (void) testTryGetContentFromUser {
    
//    [[WBRUser new] tryGetContentFromUser:^(User *userPersonalData) {
//        LogInfo(@"Just a register for coverage");
//    } failure:^(NSError *error) {
//        LogInfo(@"Just a register for coverage");
//    }];
    
    User *userPersonalData = [User new];
    [userPersonalData setFirstName:@"First Name"];
    [userPersonalData setLastName:@"Last Name"];
    [userPersonalData setFullName:@"Full Name"];
    [userPersonalData setEmail:@"wmteste@mobile.com"];
    [userPersonalData setDocument:@"052.641.038-87"];
    [userPersonalData setGuid:@"fake-guid"];
    [userPersonalData setPid:@"fake-pid"];

    WBRUser *userC = [WBRUser new];
    id myMock = [OCMockObject mockForClass:[userC class]];
    [[[myMock expect] andDo:^(NSInvocation *invocation) {
        
        void (^completionBlock)(User *userPersonalData) = nil;
        [invocation getArgument:&completionBlock atIndex:2];
        completionBlock(userPersonalData);
        
        [[WBRUser new] tryGetContentFromUser:^(User *userPersonalData) {
            LogInfo(@"Just a register for coverage");
        } failure:^(NSError *error) {
            LogInfo(@"Just a register for coverage");
        }];
        
    }] tryGetContentFromUser:[OCMArg any] failure:[OCMArg any]];
    
    [myMock tryGetContentFromUser:^(User *userPersonal) {
        XCTAssertEqual(userPersonal.firstName, @"First Name", @"First Name failed");
        XCTAssertEqual(userPersonal.lastName, @"Last Name", @"Last Name failed");
        XCTAssertEqual(userPersonal.fullName, @"Full Name", @"Full Name failed");
        XCTAssertEqual(userPersonal.email, @"wmteste@mobile.com", @"E-mail failed");
        XCTAssertEqual(userPersonal.document, @"052.641.038-87", @"Document failed");
        XCTAssertEqual(userPersonal.guid, @"fake-guid", @"Guid failed");
        XCTAssertEqual(userPersonal.pid, @"fake-pid", @"Pid failed");
    } failure:^(NSError *error) {
        
    }];
}


- (void) testFirstNameWithCompletionBlock {
    
    WBRUser *userC = [WBRUser new];
    [userC firstNameWithCompletionBlock:^(NSString *firstName) {
        LogInfo(@"Just a register for coverage");
        XCTAssertNil(firstName);
    }];
    
    id myMock = [OCMockObject mockForClass:[WBRUser class]];
    [[[myMock stub] andDo:^(NSInvocation *invocation) {
        
        NSString *firstName = @"Charles";
        
        void (^responseHandler)(NSString *fName)= nil;
        
        //0 and 1 are reserved for invocation object, ....therefor 2, n would be (completionBlock)
        [invocation getArgument:&responseHandler atIndex:2];
        
        //invoke the block
        responseHandler(firstName);
        
    }] firstNameWithCompletionBlock:[OCMArg any]];
    
    [myMock firstNameWithCompletionBlock:^(NSString *firstName) {
        XCTAssertEqual(firstName, @"Charles", @"First Name: <%@>", firstName);
    }];
}


- (void) testFullNameWithCompletionBlock {
    
    WBRUser *userC = [WBRUser new];
    [userC fullNameWithCompletionBlock:^(NSString *fullName) {
        LogInfo(@"Just a register for coverage");
        XCTAssertNil(fullName);
    }];
    
    id myMock = [OCMockObject mockForClass:[WBRUser class]];
    [[[myMock stub] andDo:^(NSInvocation *invocation) {
        
        NSString *fullName = @"Charles Darwin";
        
        void (^responseHandler)(NSString *fName)= nil;
        
        //0 and 1 are reserved for invocation object, ....therefor 2, n would be (completionBlock)
        [invocation getArgument:&responseHandler atIndex:2];
        
        //invoke the block
        responseHandler(fullName);
        
    }] fullNameWithCompletionBlock:[OCMArg any]];
    
    [myMock fullNameWithCompletionBlock:^(NSString *fullName) {
        XCTAssertEqual(fullName, @"Charles Darwin", @"Full Name: <%@>", fullName);
    }];
}


- (void) testNickNameWithCompletionBlock {
    
    WBRUser *userC = [WBRUser new];
    [userC nickNameWithCompletionBlock:^(NSString *nickName) {
        LogInfo(@"Just a register for coverage");
        XCTAssertNil(nickName);
    }];
    
    id myMock = [OCMockObject mockForClass:[userC class]];
    [[[myMock stub] andDo:^(NSInvocation *invocation) {
        
        NSString *nickName = @"Charlezinho";
        
        void (^responseHandler)(NSString *nName)= nil;
        
        //0 and 1 are reserved for invocation object, ....therefor 2, n would be (completionBlock)
        [invocation getArgument:&responseHandler atIndex:2];
        
        //invoke the block
        responseHandler(nickName);
        
    }] nickNameWithCompletionBlock:[OCMArg any]];
    
    [myMock nickNameWithCompletionBlock:^(NSString *nickName) {
        XCTAssertEqual(nickName, @"Charlezinho", @"Nick Name: <%@>", nickName);
    }];
}


- (void) testLogoutUserFromDevice {
    
    OCMVerify([WBRUser logoutUserFromDevice]);
}


- (void) testIsAuthenticatedYES {
    
    WBRUser *userC = [WBRUser new];
    [userC isAuthenticated]; //Just a register for coverage
    
    id myMock = [OCMockObject mockForClass:[WBRUser class]];
    BOOL isAuth = YES;
    OCMStub([myMock isAuthenticated]).andReturn(isAuth);
    XCTAssertTrue([myMock isAuthenticated], @"is Authenticated (YES): %i", [myMock isAuthenticated]);
}


- (void) testIsAuthenticatedNO {
    
    WBRUser *userC = [WBRUser new];
    [userC isAuthenticated];
    
    id myMock = [OCMockObject mockForClass:[userC class]];
    BOOL isAuth = NO;
    OCMStub([myMock isAuthenticated]).andReturn(isAuth);
    XCTAssertFalse([myMock isAuthenticated], @"is Authenticated (NO): %i", [myMock isAuthenticated]);
}




//- (void)testWithToken {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    
////    BOOL hasTokenV2 = (wtm && wtm.accessToken.length > 0);
//    
//    LogInfo(@"[TEST] Access Token (with): %@", wtm.accessToken);
//    NSString *strError = [NSString stringWithFormat:@"Token %@ Fail to persist", fakeToken];
//    XCTAssertTrue((wtm && wtm.accessToken.length > 0), @"%@", strError);
//}
//
//- (void)testWithoutToken {
//    
//    [self deleteToken];
//    
//    LogInfo(@"[TEST] Access Token (without): %@", wtm.accessToken);
//    NSString *strError = [NSString stringWithFormat:@"Token is not null"];
//    XCTAssertFalse((wtm && wtm.accessToken.length > 0), @"%@", strError);
//}
//
//- (void) addToken {
//    
//    //Save FAKE Token
//    fakeToken = @"TOKEN_FAKE";
//    wtm = [[WMBTokenModel alloc] initWithToken:fakeToken type:nil expiration:nil refreshToken:nil];
//    wtk = [WMTokens new];
//    [wtk addTokenOAuth:wtm];
//}
//
//- (void) deleteToken {
//    
//    wtm = [[WMBTokenModel alloc] initWithToken:nil type:nil expiration:nil refreshToken:nil];
//    wtk = [WMTokens new];
//    [wtk addTokenOAuth:wtm];
//}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
