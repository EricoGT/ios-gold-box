//
//  OrdersListTest.m
//  Walmart
//
//  Created by Bruno Delgado on 5/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OrdersViewController.h"
#import "OFMessages.h"
#import "UserSession.h"

@interface OrdersListTest : XCTestCase
{
    OrdersViewController *orders;
}

@end

@implementation OrdersListTest

- (void)setUp
{
    [super setUp];
    orders = [OrdersViewController new];
    [orders view];
}

- (void)tearDown
{
    orders = nil;
    [super tearDown];
}

- (void)DISABLED_testEmptyOrders
{
    [orders setOrders:@[]];
    [orders setEmptyState];
    [orders reloadUI];
    
    XCTAssert(orders.emptyView.hidden == NO, @"Empty View must be visible because we don't have any order");
    XCTAssertEqualObjects(orders.errorImageView.image, [UIImage imageNamed:@"ic_shoppingcart_noproducts.png"]);
    
    NSString *emptyMessage = [[OFMessages new] emptyOrders];
    XCTAssertTrue([emptyMessage isEqualToString:orders.emptyMessageLabel.text]);
}

- (void)testShowErrorWhenGettingOrders
{
    [orders setOrders:@[]];
    
    NSError *testError = [NSError errorWithDomain:@"com.walmart" code:500 userInfo:@{NSLocalizedDescriptionKey : @"Error!"}];
    [orders setErrorState:testError];
    [orders reloadUI];
    
    XCTAssert(!orders.emptyView.hidden, @"Empty View must be visible because we had an error");
    XCTAssertEqualObjects(orders.errorImageView.image, [UIImage imageNamed:@"UISharedSadface.png"]);
}

- (void)testResetPagination
{
    UserSession *session = [UserSession sharedInstance];
    [session setCurrentPage:@0];
    
    XCTAssertEqual(session.currentPage.integerValue, 0);
}

- (void)testPagination
{
    UserSession *session = [UserSession sharedInstance];
    [session setCurrentPage:@0];
    
    [orders updatePageForLoadMore];
    XCTAssertEqual(session.currentPage.integerValue, 1);
    
    [orders increasePage];
    XCTAssertEqual(session.currentPage.integerValue, 2);
    
    NSInteger lastPage = session.currentPage.integerValue;
    [orders increasePage];
    XCTAssertEqual(session.currentPage.integerValue, lastPage + 1);
}

@end
