//
//  WBRContactTicketTableViewCellTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 3/29/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRContactTicketTableViewCell.h"

@interface WBRContactTicketTableViewCell (Testing)

@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *ticketSubject;
@property (weak, nonatomic) IBOutlet UIView *productsContainer;

- (void)setDate:(double)dateDouble inField:(UILabel *)dateLabel;
- (void)setupCellWithCollection:(WBRModelTicket *)ticket;

@end

@interface WBRContactTicketTableViewCellTests : XCTestCase

@property WBRContactTicketTableViewCell *viewCell;

@end

@implementation WBRContactTicketTableViewCellTests

- (void)setUp {
    [super setUp];
    self.viewCell = [[NSBundle.mainBundle loadNibNamed:[WBRContactTicketTableViewCell reusableIdentifier] owner:nil options:nil] firstObject];
}

- (void)tearDown {
    self.viewCell = nil;
    [super tearDown];
}

- (void)testSetDate {
    NSString *formattedDate = @"26/10/2018";
    NSString *timestampDate = @"26/10/2018 09:03";
    UILabel *label = [[UILabel alloc] init];
    [self.viewCell setDate:timestampDate inField:label];
    
    XCTAssertTrue([label.text isEqualToString:formattedDate]);
}

- (void)testSetupCell {
    
    WBRModelTicket *ticket1 = [[WBRModelTicket alloc] initWithString:@"{\"id\":36616, \"walmartOrderId\":\"51462595\", \"creationDate\":\"14/12/2018 09:09\",\"slaDate\":\"21/12/2018 09:10\",\"status\":\"open\", \"reason\":{\"id\":1926,\"label\":\"Nota Fiscal\"},\"description\":\"Nota Fiscal\",\"commentsVisible\":true,\"canBeReopened\":false,\"qtyItems\":1,\"items\":[{\"imageUrl\":\"//static.wmobjects.com.br/imgres/arquivos/ids/4261847\"}]}" error:nil];
    
    [self.viewCell setupCellWithCollection:ticket1];
    XCTAssertTrue([self.viewCell.ticketNumber.text isEqualToString:ticket1.ticketId.stringValue]);
    XCTAssertTrue([self.viewCell.creationDate.text isEqualToString:@"14/12/2018"]);
    XCTAssertTrue([self.viewCell.ticketSubject.text isEqualToString:ticket1.ticketDescription]);
    XCTAssertFalse(self.viewCell.productsContainer.hidden);
    
    WBRModelTicket *ticket2 = [[WBRModelTicket alloc] initWithString:@"{\"canBeReopened\": false,\"creationDate\": \"26/10/2018 09:03\",\"description\": \"Dúvidas sobre o site\",\"dueDate\": \"28/10/2018 09:03\",\"id\": \"51442000\",\"status\": \"open\"}" error:nil];
    
    [self.viewCell prepareForReuse];
    [self.viewCell setupCellWithCollection:ticket2];
    
    XCTAssertTrue(self.viewCell.productsContainer.hidden);
}

@end
