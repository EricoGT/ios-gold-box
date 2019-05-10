//
//  WBRContactTicketStatusViewTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 3/26/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRContactTicketStatusView.h"

@interface WBRContactTicketStatusView (Testing)

@property (weak, nonatomic) IBOutlet UILabel *statusDescription;

@end

@interface WBRContactTicketStatusViewTests : XCTestCase

@property WBRContactTicketStatusView *statusView;

@end

@implementation WBRContactTicketStatusViewTests

- (void)setUp {
    [super setUp];
    self.statusView = [[WBRContactTicketStatusView alloc] init];
}

- (void)testSetupClosedStatus {
    [self.statusView setupViewWithStatus:kTicketClosedStatus];
    XCTAssertTrue([self.statusView.statusDescription.text isEqualToString:@"Concluído"]);
}

- (void)testSetupOpenStatus {
    [self.statusView setupViewWithStatus:@"any other status than closed"];
    XCTAssertTrue([self.statusView.statusDescription.text isEqualToString:@"Em atendimento"]);
}

@end
