//
//  WALCacheTests.m
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALCache.h"
#import "FXKeychain.h"
#import "WALSession.h"

@interface WALCacheTests : XCTestCase
@property (nonatomic, strong) WALCache *cacheInstance;
@end

@implementation WALCacheTests

- (void)setUp
{
    [super setUp];
    self.cacheInstance = [WALCache new];
}

- (void)tearDown
{
    self.cacheInstance = nil;
    [super tearDown];
}

- (void)testKeychain
{
    FXKeychain *keychainItem = [self.cacheInstance keychainAccess];
    XCTAssertNotNil(keychainItem);
}

- (void)DISABLED_testGetGUID
{
    FXKeychain *keychainItem = self.cacheInstance.keychainAccess;
    [keychainItem setObject:@"FakeGUID" forKey:kGUIDkey];
    XCTestExpectation *expectation = [self expectationWithDescription:@"guid_from_keychain"];
    [self.cacheInstance guIDWithCompletionBlock:^(NSString * _Nullable guid)
    {
         XCTAssert(guid.length > 0);
         [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [self.cacheInstance.keychainAccess removeObjectForKey:kGUIDkey];
    expectation = [self expectationWithDescription:@"guid_from_server_with_error"];
    [self.cacheInstance guIDWithCompletionBlock:^(NSString * _Nullable guid)
    {
        XCTAssertNil(guid);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:15 handler:nil];


}

- (void)testStoreCache
{
    NSData *data = nil;
    NSString *identifier = nil;
    XCTAssertNil(identifier);
    XCTAssertNil(data);

    identifier = @"CacheTestIdentifier";
    data = [NSData new];
    XCTAssertNotNil(identifier);
    XCTAssertNotNil(data);

    BOOL didSave = [self.cacheInstance storeCache:data withIdentifier:identifier];
    XCTAssertTrue(didSave);
}

- (void)testRetrieveFromCache
{
    NSData *data = [NSData new];
    NSString *identifier = nil;
    XCTAssertNil(identifier);

    identifier = @"CacheTestIdentifier";
    XCTAssertNotNil(identifier);

    BOOL didSave = [self.cacheInstance storeCache:data withIdentifier:identifier];
    if (didSave)
    {
        NSData *dataFromCache = [self.cacheInstance cacheWithIdentifier:identifier];
        XCTAssertNotNil(dataFromCache);
        XCTAssertEqual(data, dataFromCache);
    }
}

- (void)testRemoveCache
{
    NSData *data = [NSData new];
    NSString *identifier = nil;
    XCTAssertNil(identifier);

    identifier = @"CacheTestIdentifier";
    XCTAssertNotNil(identifier);

    BOOL didSave = [self.cacheInstance storeCache:data withIdentifier:identifier];
    if (didSave)
    {
        NSData *dataFromCache = [self.cacheInstance cacheWithIdentifier:identifier];
        XCTAssertNotNil(dataFromCache);
        XCTAssertEqual(data, dataFromCache);

        [self.cacheInstance removeCacheWithIdentifier:identifier];
        dataFromCache = [self.cacheInstance cacheWithIdentifier:identifier];
        XCTAssertNil(dataFromCache);
    }
}

- (void)testRemoveFileFromBackup
{
    NSData *data = [NSData new];
    NSString *identifier = nil;
    XCTAssertNil(identifier);

    identifier = @"CacheTestIdentifier";
    XCTAssertNotNil(identifier);

    BOOL didSave = [self.cacheInstance storeCache:data withIdentifier:identifier];
    if (didSave)
    {
        NSString *path = [_cacheInstance.cachesPath stringByAppendingPathComponent:identifier];
        NSURL *filePath = [NSURL URLWithString:path];

        id flag;
        NSError *error = nil;
        BOOL result = [filePath getResourceValue:&flag forKey:NSURLIsExcludedFromBackupKey error:&error];

        XCTAssertNil(error);
        XCTAssertTrue(result);
    }

}

@end
