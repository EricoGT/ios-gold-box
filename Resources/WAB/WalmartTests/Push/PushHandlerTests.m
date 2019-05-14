//
//  PushHandlerTests.m
//  Walmart
//
//  Created by Bruno Delgado on 6/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PushHandler.h"
//#import "UAPush.h"

@interface PushHandler (Testable)

- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber;

@end

@interface PushHandlerTests : XCTestCase

@property (nonatomic, strong) PushHandler *handler;

@end

@implementation PushHandlerTests

- (void)setUp
{
    [super setUp];
    
    self.handler = [PushHandler singleton];
}

- (void)tearDown
{
    self.handler = nil;
    [super tearDown];
}

- (void)testPushHandlerSingletonCreation
{
    XCTAssertNotNil([PushHandler singleton]);
}

- (void)testPushHandlerSingletonEquality
{
    XCTAssertEqual(self.handler, [PushHandler singleton]);
}

- (void)testDestroy
{
    self.handler.notificationDictionary = @{};
    
    XCTAssertNotNil(self.handler.notificationDictionary);
    [PushHandler destroy];
    XCTAssertNil(self.handler.notificationDictionary);
}

- (void)testHandlePushReceived
{
    self.handler.notificationDictionary = nil;
    XCTAssertNil(self.handler.notificationDictionary);
    
    [self.handler handlePushReceived:@{}];
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive)
    {
        XCTAssertNil(self.handler.notificationDictionary);
    }
    else
    {
        XCTAssertNotNil(self.handler.notificationDictionary);
    }
    
}

- (void)testIsHomePushNotification
{
    NSDictionary *pushWithWrongType = @{@"type" : @"product"};
    NSDictionary *pushWithValidType = @{@"type" : @"home"};
    
    self.handler.notificationDictionary = pushWithWrongType;
    XCTAssertFalse([self.handler isHomePushNotification]);
    
    self.handler.notificationDictionary = pushWithValidType;
    XCTAssertTrue([self.handler isHomePushNotification]);
}

- (void)testProductIdFromNotification
{
    NSString *productID = @"1212121212";
    NSDictionary *invalidPushWithProductModel_1 = @{@"type" : @"home", @"product" : productID};
    NSDictionary *invalidPushWithProductModel_2 = @{@"produto" : productID};
    
    NSDictionary *validPushWithProductModel_1 = @{@"product_id" : productID};
    NSDictionary *validPushWithProductModel_2 = @{@"type" : @"product", @"product" : productID};
    NSDictionary *validPushWithProductModel_3 = @{@"type" : @"pRodUct", @"product" : productID};
    
    self.handler.notificationDictionary = invalidPushWithProductModel_1;
    XCTAssertNil([self.handler productIdFromNotification]);
    
    self.handler.notificationDictionary = invalidPushWithProductModel_2;
    XCTAssertNil([self.handler productIdFromNotification]);
    
    NSString *product;
    
    self.handler.notificationDictionary = validPushWithProductModel_1;
    product = [self.handler productIdFromNotification];
    XCTAssertNotNil(product);
    XCTAssertTrue([productID isEqualToString:product]);
    
    self.handler.notificationDictionary = validPushWithProductModel_2;
    product = [self.handler productIdFromNotification];
    XCTAssertNotNil(product);
    XCTAssertTrue([productID isEqualToString:product]);
    
    self.handler.notificationDictionary = validPushWithProductModel_3;
    product = [self.handler productIdFromNotification];
    XCTAssertNotNil(product);
    XCTAssertTrue([productID isEqualToString:product]);
}

- (void)testProductSKUFromNotification
{
    NSString *productSKU = @"1212121212";
    NSDictionary *invalidPushWithProductModel_1 = @{@"sku" : productSKU};
    NSDictionary *validPushWithProductModel_1 = @{@"product_sku" : productSKU};
    
    self.handler.notificationDictionary = invalidPushWithProductModel_1;
    XCTAssertNil([self.handler productSKUFromNotification]);
    
    self.handler.notificationDictionary = validPushWithProductModel_1;
    NSString *product = [self.handler productSKUFromNotification];
    XCTAssertNotNil(product);
    XCTAssertTrue([productSKU isEqualToString:product]);
}

- (void)testOrderIDFromPushNotification
{
    NSString *order = @"1212121212";
    
    NSDictionary *invalidPushWithOrder_1 = @{@"aps" : @{@"alert" : @"1212121212 - Order status update!"}};
    NSDictionary *invalidPushWithOrder_2 = @{@"aps" : @{@"alert" : @"Order status update - #1212121212"}};
    
    NSDictionary *validPushWithOrder_1 = @{@"aps" : @{@"alert" : @"#1212121212 - Order status update!"}};
    NSDictionary *validPushWithOrder_2 = @{@"type" : @"status", @"orderId" : order};
    NSDictionary *validPushWithOrder_3 = @{@"type" : @"STAtuS", @"orderId" : order};
    
    self.handler.notificationDictionary = invalidPushWithOrder_1;
    XCTAssertNil([self.handler orderIDFromPushNotification]);
    
    self.handler.notificationDictionary = invalidPushWithOrder_2;
    XCTAssertNil([self.handler orderIDFromPushNotification]);
    
    NSString *orderFromPush;
    
    self.handler.notificationDictionary = validPushWithOrder_1;
    orderFromPush = [self.handler orderIDFromPushNotification];
    XCTAssertNotNil(orderFromPush);
    XCTAssertTrue([order isEqualToString:orderFromPush]);
    
    self.handler.notificationDictionary = validPushWithOrder_2;
    orderFromPush = [self.handler orderIDFromPushNotification];
    XCTAssertNotNil(orderFromPush);
    XCTAssertTrue([order isEqualToString:orderFromPush]);
    
    self.handler.notificationDictionary = validPushWithOrder_3;
    orderFromPush = [self.handler orderIDFromPushNotification];
    XCTAssertNotNil(orderFromPush);
    XCTAssertTrue([order isEqualToString:orderFromPush]);
}

- (void)testCollectionFromPushNotification
{
    NSString *collection = @"fq=fogao";
    NSDictionary *invalidPushWithCollectionModel_1 = @{@"colecao" : collection};
    NSDictionary *validPushWithCollectionModel_1 = @{@"collection" : collection};
    
    self.handler.notificationDictionary = invalidPushWithCollectionModel_1;
    XCTAssertNil([self.handler productSKUFromNotification]);
    
    self.handler.notificationDictionary = validPushWithCollectionModel_1;
    NSString *collectionFromPush = [self.handler collectionFromPushNotification];
    XCTAssertNotNil(collectionFromPush);
    XCTAssertTrue([collection isEqualToString:collectionFromPush]);
}

- (void)DISABLED_testSetApplicationBadgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    NSInteger badge = 10;
    [self.handler setApplicationBadgeNumber:badge];
    XCTAssertTrue(application.applicationIconBadgeNumber == badge);
    [self.handler setApplicationBadgeNumber:0];
}

- (void)DISABLED_testCleanBadge
{
    UIApplication *application = [UIApplication sharedApplication];
    [self.handler setApplicationBadgeNumber:10];
    [self.handler cleanBadge];
    XCTAssertTrue(application.applicationIconBadgeNumber == 0);
}

- (void)testRegisterForPushNotificationsOnWalmartServer
{
    //We are not testing connection on unit testing, so this code is only to completely cover this class with tests
    [self.handler registerForPushNotificationsOnWalmartServer];
}

- (void)testUnregisterForPushNotificationsOnWalmartServer
{
    //We are not testing connection on unit testing, so this code is only to completely cover this class with tests
    [self.handler unregisterForPushNotificationsOnWalmartServer];
}

@end
