//
//  WMShowcaseTrackingManagerTests.m
//  Walmart
//
//  Created by Bruno on 8/31/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WALShowcaseTrackerManager.h"
#import "ShowcaseTrackerModel.h"

@interface WMShowcaseTrackingManagerTests : XCTestCase

@end

@implementation WMShowcaseTrackingManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStore
{
    [WALShowcaseTrackerManager clean];
    
    ShowcaseTrackerModel *showcase1 = [ShowcaseTrackerModel new];
    showcase1.showcaseId = @"HOME_MAIS_VENDIDOS";
    
    [WALShowcaseTrackerManager storeShowcaseTracking:showcase1];
    NSArray *list = [WALShowcaseTrackerManager retrieveListOfShowcaseTrackings];
    XCTAssertTrue(list.count == 1);
    
    ShowcaseTrackerModel *showcase2 = [ShowcaseTrackerModel new];
    showcase2.showcaseId = @"HOME_MAIS_VISTOS";
    
    [WALShowcaseTrackerManager storeShowcaseTracking:showcase2];
    list = [WALShowcaseTrackerManager retrieveListOfShowcaseTrackings];
    XCTAssertTrue(list.count == 2);
}

- (void)testClean {
    
    [WALShowcaseTrackerManager clean];
    
    ShowcaseTrackerModel *showcase1 = [ShowcaseTrackerModel new];
    showcase1.showcaseId = @"HOME_MAIS_VENDIDOS";
    
    ShowcaseTrackerModel *showcase2 = [ShowcaseTrackerModel new];
    showcase2.showcaseId = @"HOME_MAIS_VISTOS";
    
    [WALShowcaseTrackerManager storeShowcaseTracking:showcase1];
    [WALShowcaseTrackerManager storeShowcaseTracking:showcase2];
    
    NSArray *list = [WALShowcaseTrackerManager retrieveListOfShowcaseTrackings];
    XCTAssertTrue(list.count == 2);
    
    [WALShowcaseTrackerManager clean];
    
    list = [WALShowcaseTrackerManager retrieveListOfShowcaseTrackings];
    XCTAssertTrue(list.count == 0);
}

@end
