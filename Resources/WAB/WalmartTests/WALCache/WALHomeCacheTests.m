//
//  WALHomeCacheTests.m
//  Walmart
//
//  Created by Bruno Delgado on 6/30/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALHomeCache.h"
#import "HomeModel.h"

@interface WALHomeCacheTests : XCTestCase

@property (nonatomic, strong) WALHomeCache *homeCacheInstance;

@end

@implementation WALHomeCacheTests

- (void)setUp
{
    [super setUp];
    [WALHomeCache setCustomRefreshTime:300];
    self.homeCacheInstance = [WALHomeCache new];
}

- (void)tearDown
{
    self.homeCacheInstance = nil;
}

- (void)testSave
{
    HomeModel *home = nil;
    XCTAssertNil(home);

    home = [HomeModel new];
    XCTAssertNotNil(home);

    [WALHomeCache save:home];
    HomeModel *homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNotNil(homeFromCache);
}

- (void)testClean
{
    HomeModel *home = nil;
    XCTAssertNil(home);

    home = [HomeModel new];
    XCTAssertNotNil(home);

    [WALHomeCache save:home];
    HomeModel *homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNotNil(homeFromCache);

    [WALHomeCache clean];
    homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNil(homeFromCache);

}

- (void)testHomeFromCache
{
    HomeModel *homeWithParserError = nil;
    XCTAssertNil(homeWithParserError);

    homeWithParserError = [HomeModel new];
    XCTAssertNotNil(homeWithParserError);

    [WALHomeCache save:homeWithParserError];
    HomeModel *homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNotNil(homeFromCache);
    [WALHomeCache clean];

    HomeModel *homeValid = [HomeModel new];
    homeValid.showcases = (NSArray <ShowcaseModel> *)@[];
    [WALHomeCache save:homeValid];
    homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNotNil(homeFromCache);

    [WALHomeCache cleanInMemoryHome];
    homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNotNil(homeFromCache);

    [WALHomeCache save:homeValid];
    [WALHomeCache setCustomRefreshTime:0];
    homeFromCache = [WALHomeCache homeFromCache];
    XCTAssertNil(homeFromCache);

    [WALHomeCache setCustomRefreshTime:300];
}

@end
