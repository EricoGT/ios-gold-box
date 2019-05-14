//
//  ModelCheckoutDeliveryTests.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/29/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ModelCheckoutDelivery.h"
#import "CartItem.h"

@interface ModelCheckoutDeliveryTests : XCTestCase

@property (strong, nonatomic) ModelCheckoutDelivery *model;

@end

@implementation ModelCheckoutDeliveryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithItemsToDelete {
    
    NSString *key = @"KEY";
    NSString *selletId = @"SELLER";
    NSNumber *quantity = @0;
    
    NSArray<CartItem> *items = [[NSArray<CartItem> alloc] initWithObjects:[[CartItem alloc] initWithItemKey:key quantity:quantity sellerId:selletId], nil];
    self.model = [[ModelCheckoutDelivery alloc] initWithItemsToDelete:items];
    
    CartItem *itemFromModel = (CartItem *)self.model.items.firstObject;
    
    XCTAssertEqual(itemFromModel.key, key);
    XCTAssertEqual(itemFromModel.quantity, quantity);
    XCTAssertEqual(itemFromModel.sellerId, selletId);
}

@end
