//
//  ExtendedWarrantyCardCell.m
//  Walmart
//
//  Created by Renan on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WMBExtendedWarrantyCardCell.h"

#import "ExtendedWarrantyBuilder.h"
#import "ExtendedWarrantyResumeModel.h"
#import "NSDate+DateTools.h"

@interface ExtendedWarrantyCardCellTests : XCTestCase

@property (strong, nonatomic) WMBExtendedWarrantyCardCell *card;
@property (strong, nonatomic) ExtendedWarrantyResumeModel *warranty;

@end

@implementation ExtendedWarrantyCardCellTests

- (void)setUp {
    [super setUp];
    
    self.card = [[WMBExtendedWarrantyCardCell alloc] initForTestCase];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstantInfo {
    self.warranty = [ExtendedWarrantyBuilder baseWarranty];
    [self.card setupWithExtendedWarrantyResumeModel:self.warranty];
    
    XCTAssertTrue([self.card.ticketNumberTitleLabel.text isEqualToString:EXTENDED_WARRANTY_TICKET_TITLE]);
    XCTAssertTrue([self.card.ticketNumberLabel.text isEqualToString:self.warranty.ticketNumber]);
    XCTAssertTrue([self.card.accessionDateTitleLabel.text isEqualToString:EXTENDED_WARRANTY_ACCESSION_DATE_TITLE]);
    XCTAssertTrue([self.card.accessionDateLabel.text isEqualToString:[self.warranty.enrollmentDate formattedDateWithFormat:DATE_FORMAT]]);

//    XCTAssertTrue([self.card.extendedWarrantyLabel.text isEqualToString:self.warranty.descriptionText]);
    
    [self.card setupProductWithImage:nil];
    XCTAssertNotNil(self.card.productImage.image);
}

- (void)testBaseWarranty {
    self.warranty = [ExtendedWarrantyBuilder baseWarranty];
    [self.card setupWithExtendedWarrantyResumeModel:self.warranty];
    
    NSString *startDate = [self.warranty.startDate formattedDateWithFormat:DATE_FORMAT];
    NSString *expirationDate = [self.warranty.expirationDate formattedDateWithFormat:DATE_FORMAT];
    NSString *coverageStr = [NSString stringWithFormat:@"%@\n%@ %@ %@", EXTENDED_WARRANTY_COVERAGE_TITLE, startDate, EXTENDED_WARRANTY_LICENSE_COVERAGE_DATE_SEPARATOR, expirationDate];
    XCTAssertTrue([self.card.coverageLabel.text isEqualToString:coverageStr]);
}

- (void)testCancelledWarranty {
    self.warranty = [ExtendedWarrantyBuilder cancelledWarranty];
    [self.card setupWithExtendedWarrantyResumeModel:self.warranty];
    
    NSString *rescissionDate = [self.warranty.rescissionDate formattedDateWithFormat:DATE_FORMAT];
    NSString *coverageStr = [NSString stringWithFormat:@"%@ %@", EXTENDED_WARRANTY_CANCELLED_TITLE, rescissionDate];
    XCTAssertTrue([self.card.coverageLabel.text isEqualToString:coverageStr]);
}

- (void)testHighlight {
    [self.card setHighlighted:YES animated:NO];
    XCTAssertFalse(self.card.overlayView.hidden);
    
    [self.card setHighlighted:NO animated:NO];
    XCTAssertTrue(self.card.overlayView.hidden);
}

@end
