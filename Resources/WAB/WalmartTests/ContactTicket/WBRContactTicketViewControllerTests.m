//
//  WBRContactTicketViewControllerTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 3/28/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRContactTicketViewController.h"
#import "WBRModelTicket.h"

@interface WBRContactTicketViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *emptyStateView;
@property NSMutableArray<WBRModelTicket> *tickets;

- (void)populateTicketArray:(NSArray *)tickets;
- (void)showEmptyStateView:(BOOL)showView;
- (void)showRetryRequestPopup:(NSError *)error;
- (void)resetTicketList;

@end

@interface WBRContactTicketViewControllerTests : XCTestCase

@property WBRContactTicketViewController *viewController;

@end

@implementation WBRContactTicketViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[WBRContactTicketViewController alloc] initWithNibName:@"WBRContactTicketViewController" bundle:[NSBundle mainBundle]];
    [self.viewController view];
}

- (void)testEmptyStateVisibility {
    
    [self.viewController showEmptyStateView:YES];
    XCTAssertFalse(self.viewController.emptyStateView.hidden);
    
    [self.viewController showEmptyStateView:NO];
    XCTAssertTrue(self.viewController.emptyStateView.hidden);
}

- (void)DISABLED_testPopulateTicketsArray {
    
    WBRModelTicket *ticket1 = [[WBRModelTicket alloc] initWithString:@"{\"id\":36616, \"walmartOrderId\":\"51462595\", \"creationDate\":\"14/12/2018 09:09\",\"slaDate\":\"21/12/2018 09:10\",\"status\":\"open\", \"reason\":{\"id\":1926,\"label\":\"Nota Fiscal\"},\"description\":\"Nota Fiscal\",\"commentsVisible\":true,\"canBeReopened\":false,\"qtyItems\":1,\"items\":[{\"imageUrl\":\"//static.wmobjects.com.br/imgres/arquivos/ids/4261847\"}]}" error:nil];
    
    WBRModelTicket *ticket2 = [[WBRModelTicket alloc] initWithString:@"{\"canBeReopened\": false,\"creationDate\": \"14/12/2018 09:09\",\"description\": \"Dúvidas sobre o site\",\"dueDate\": \"21/12/2018 09:10\",\"id\": \"51442000\",\"status\": \"open\"}" error:nil];
    
    [self.viewController populateTicketArray:@[ticket1, ticket2]];
    
    XCTAssertTrue(self.viewController.tickets.count > 0);
    XCTAssertTrue(self.viewController.emptyStateView.hidden);
}

- (void)DISABLED_testResetTicketList {
    [self.viewController view];
    WBRModelTicket *ticket1 = [[WBRModelTicket alloc] initWithString:@"{\"id\":36616, \"walmartOrderId\":\"51462595\", \"creationDate\":\"14/12/2018 09:09\",\"slaDate\":\"21/12/2018 09:10\",\"status\":\"open\", \"reason\":{\"id\":1926,\"label\":\"Nota Fiscal\"},\"description\":\"Nota Fiscal\",\"commentsVisible\":true,\"canBeReopened\":false,\"qtyItems\":1,\"items\":[{\"imageUrl\":\"//static.wmobjects.com.br/imgres/arquivos/ids/4261847\"}]}" error:nil];
    
    WBRModelTicket *ticket2 = [[WBRModelTicket alloc] initWithString:@"{\"canBeReopened\": false,\"creationDate\": \"14/12/2018 09:09\",\"description\": \"Dúvidas sobre o site\",\"dueDate\": \"21/12/2018 09:10\",\"id\": \"51442000\",\"status\": \"open\"}" error:nil];

    [self.viewController populateTicketArray:@[ticket1, ticket2]];
    XCTAssertTrue(self.viewController.tickets.count > 0);
    XCTAssertTrue(self.viewController.emptyStateView.hidden);
    
    [self.viewController resetTicketList];
    XCTAssertTrue(self.viewController.tickets.count == 0);
    
    [self.viewController populateTicketArray:@[]];
    XCTAssertTrue(self.viewController.tickets.count == 0);
    XCTAssertFalse(self.viewController.emptyStateView.hidden);
}

@end
