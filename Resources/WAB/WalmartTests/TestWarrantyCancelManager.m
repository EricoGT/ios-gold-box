//
//  TestWarrantyCancelManager.m
//  Walmart
//
//  Created by Bruno Delgado on 6/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ExtendedWarrantyCancelManager.h"
#import "ExtendedWarrantyCancelTicket.h"

@interface TestWarrantyCancelManager : XCTestCase
{
    ExtendedWarrantyCancelTicket *ticket;
}

@end

@implementation TestWarrantyCancelManager

- (void)setUp
{
    [super setUp];
    
    ticket = [ExtendedWarrantyCancelTicket new];
    [self setupTicket];
}

- (void)setupTicket
{
    ticket.warrantyNumber = @"9999999999";
    ticket.protocolNumber = @9999999999;
}

- (void)addTicket
{
    [ExtendedWarrantyCancelManager addTicket:ticket];
}

- (void)removeTicket
{
    [ExtendedWarrantyCancelManager removeTicketForWarrantyNumber:ticket.warrantyNumber];
}

- (void)testAddTicket
{
    [self addTicket];
    ExtendedWarrantyCancelTicket *storedTicket;
    
    storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNotNil(storedTicket);
    [self removeTicket];
    
    ticket.warrantyNumber = nil;
    ticket.protocolNumber = @9999999999;
    [self addTicket];
    storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNil(storedTicket);
    
    ticket.warrantyNumber = @"9999999999";
    ticket.protocolNumber = nil;
    [self addTicket];
    storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNil(storedTicket);
    
    [self setupTicket];
}

- (void)testRemoveTicket
{
    [self setupTicket];
    [self addTicket];
    
    ExtendedWarrantyCancelTicket *storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNotNil(storedTicket);
    
    [self removeTicket];
    storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNil(storedTicket);
    
    [self setupTicket];
}

- (void)testCheckOpenTickets
{
    [self setupTicket];
    [self addTicket];
    
    XCTAssertTrue([ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber]);
    XCTAssertFalse([ExtendedWarrantyCancelManager ticketForWarrantyNumber:@"12121212"]);
    XCTAssertFalse([ExtendedWarrantyCancelManager ticketForWarrantyNumber:nil]);
}

- (void)testGetTicket
{
    [self setupTicket];
    [self addTicket];
    
    ExtendedWarrantyCancelTicket *storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:ticket.warrantyNumber];
    XCTAssertNotNil(storedTicket);
    
    storedTicket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:@"12"];
    XCTAssertNil(storedTicket);
}

- (void)tearDown
{
    [super tearDown];
}

@end
