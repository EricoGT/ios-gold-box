//
//  WALDynamicShowcasesCacheTests.m
//  Walmart
//
//  Created by Bruno Delgado on 6/30/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALDynamicShowcasesCache.h"
#import "ShowcaseModel.h"

@interface WALDynamicShowcasesCacheTests : XCTestCase

@property (nonatomic, strong) WALDynamicShowcasesCache *dynamicShowcasesCacheInstance;

@end

@implementation WALDynamicShowcasesCacheTests

- (void)setUp
{
    [super setUp];
    [WALDynamicShowcasesCache setCustomRefreshTime:300];
    self.dynamicShowcasesCacheInstance = [WALDynamicShowcasesCache new];
}

- (void)tearDown
{
    self.dynamicShowcasesCacheInstance = nil;
    [super tearDown];
}

- (void)testSave
{
    NSArray *dynamicShowcases = nil;
    XCTAssertNil(dynamicShowcases);

    dynamicShowcases = @[[ShowcaseModel new],[ShowcaseModel new],[ShowcaseModel new]];
    XCTAssertNotNil(dynamicShowcases);

    [WALDynamicShowcasesCache save:dynamicShowcases];
    NSArray *dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNotNil(dynamicShowcasesFromCache);
    XCTAssertTrue(dynamicShowcasesFromCache.count == dynamicShowcases.count);
}

- (void)testClean
{
    NSArray *dynamicShowcases = nil;
    XCTAssertNil(dynamicShowcases);

    dynamicShowcases = @[[ShowcaseModel new],[ShowcaseModel new],[ShowcaseModel new]];
    XCTAssertNotNil(dynamicShowcases);

    [WALDynamicShowcasesCache save:dynamicShowcases];
    NSArray *dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNotNil(dynamicShowcasesFromCache);
    XCTAssertTrue(dynamicShowcasesFromCache.count == dynamicShowcases.count);

    [WALDynamicShowcasesCache clean];
    dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNil(dynamicShowcasesFromCache);
}

- (void)DISABLED_testDynamicShowcasesFromCache
{
    NSArray *dynamicShowcasesWithParserError = nil;
    XCTAssertNil(dynamicShowcasesWithParserError);

    dynamicShowcasesWithParserError = @[[ShowcaseModel new],[ShowcaseModel new],[ShowcaseModel new]];
    XCTAssertNotNil(dynamicShowcasesWithParserError);

    [WALDynamicShowcasesCache save:dynamicShowcasesWithParserError];
    NSArray *dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNotNil(dynamicShowcasesFromCache);
    XCTAssertTrue(dynamicShowcasesFromCache.count == dynamicShowcasesWithParserError.count);
    [WALDynamicShowcasesCache clean];

    ShowcaseModel *validShowcase = [ShowcaseModel new];
    validShowcase.showcaseId = @"";
    validShowcase.name = @"";
    validShowcase.icon = @"";
    validShowcase.products = (NSArray <ShowcaseProductModel> *)@[];
    validShowcase.isRefreshing = NO;
    validShowcase.dynamic = NO;
    [WALDynamicShowcasesCache save:@[validShowcase]];

    dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNotNil(dynamicShowcasesFromCache);
    XCTAssertTrue(dynamicShowcasesFromCache.count == 1);

    [WALDynamicShowcasesCache cleanInMemoryDynamicShowcases];
    dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNotNil(dynamicShowcasesFromCache);
    XCTAssertTrue(dynamicShowcasesFromCache.count == 1);

    [WALDynamicShowcasesCache save:@[validShowcase]];
    [WALDynamicShowcasesCache setCustomRefreshTime:0];
    dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    XCTAssertNil(dynamicShowcasesFromCache);

    [WALDynamicShowcasesCache setCustomRefreshTime:300];
}

@end
