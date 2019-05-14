//
//  HubCategoriesTests.m
//  Walmart
//
//  Created by Renan on 7/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HubCategoriesCollectionViewController.h"
#import "HubCategory.h"
#import "CategoryMenuItem.h"

@interface HubCategoriesTests : XCTestCase

@property (strong, nonatomic) HubCategoriesCollectionViewController *hub;

@end

@implementation HubCategoriesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.hub = [[HubCategoriesCollectionViewController alloc] initWithHubId:@"1" otherCategories:nil];
    [self.hub view];
}

- (void)testRemoveRepeatedCategories {
    HubCategory *category1 = [HubCategory new];
    category1.searchParameter = @"teste1";
    
    HubCategory *category2 = [HubCategory new];
    category2.searchParameter = @"teste2";
    
    CategoryMenuItem *menuItem1 = [CategoryMenuItem new];
    menuItem1.url = @"teste1";
    
    CategoryMenuItem *menuItem2 = [CategoryMenuItem new];
    menuItem2.url = @"teste2";
    
    self.hub.categories = @[category1, category2];
    self.hub.otherCategories = @[menuItem1, menuItem2];
    
    [self.hub removeRepeatedCategories];
    
    XCTAssertTrue(self.hub.otherCategories.count == 0);
    
    menuItem2.url = @"não retirar";
    
    self.hub.categories = @[category1, category2];
    self.hub.otherCategories = @[menuItem1, menuItem2];
    
    [self.hub removeRepeatedCategories];
    
    XCTAssertTrue(self.hub.otherCategories.count == 1);
    
    menuItem1.url = @"não retirar1";
    menuItem2.url = @"não retirar2";
    
    self.hub.categories = @[category1, category2];
    self.hub.otherCategories = @[menuItem1, menuItem2];
    
    [self.hub removeRepeatedCategories];
    
    XCTAssertTrue(self.hub.otherCategories.count == 2);
}

@end
