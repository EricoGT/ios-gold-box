//
//  ExtendedWarrantyListTests.m
//  Walmart
//
//  Created by Renan on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ExtendedWarrantyListViewController.h"
#import "RetryErrorView.h"

#import "ExtendedWarrantyBuilder.h"

@interface ExtendedWarrantyListTests : XCTestCase

@property (strong, nonatomic) ExtendedWarrantyListViewController *warrantiesList;
@property (strong, nonatomic) NSArray *warranties;

@end

@implementation ExtendedWarrantyListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.warranties = [ExtendedWarrantyBuilder warrantiesListWithSize:5];
    self.warrantiesList = [[ExtendedWarrantyListViewController alloc] initWithNibName:@"ExtendedWarrantyListViewController" bundle:nil];
    [self.warrantiesList view];
}

- (void)testInitialization {
    XCTAssertTrue([self.warrantiesList.title isEqualToString:EXTENDED_WARRANTY_LIST_TITLE]);
    XCTAssertTrue([self.warrantiesList.headerTitleLabel.text isEqualToString:EXTENDED_WARRANTY_LIST_HEADER_TITLE]);
    XCTAssertTrue([self.warrantiesList.noWarrantiesLabel.text isEqualToString:EXTENDED_WARRANTY_LIST_NO_WARRANTIES]);
    XCTAssertFalse(self.warrantiesList.endOfWarrantiesReached);
    XCTAssertTrue(self.warrantiesList.lastPageNumber == 0);
    
    XCTAssertTrue([self.warrantiesList.tableView numberOfRowsInSection:0] == self.warrantiesList.warranties.count);
    XCTAssertTrue(self.warrantiesList.tableView.numberOfSections == 1);
}

- (void)testLoadWarranties {
    [self.warrantiesList loadExtendedWarranties];
    
    XCTAssertFalse(self.warrantiesList.endOfWarrantiesReached);
    XCTAssertTrue(self.warrantiesList.lastPageNumber == 0);
    XCTAssertTrue(self.warrantiesList.warranties.count == 0);
    XCTAssertTrue(self.warrantiesList.loader.isAnimating);
}

- (void)testLoadWarrantiesSuccess {
    [self.warrantiesList loadSuccessWithWarranties:self.warranties];
    
    XCTAssertFalse(self.warrantiesList.loader.isAnimating);
    XCTAssertEqualObjects(self.warrantiesList.tableView.tableHeaderView, self.warrantiesList.headerView);
    XCTAssertEqualObjects(self.warrantiesList.tableView.tableFooterView, self.warrantiesList.footerView);
    XCTAssertTrue(self.warrantiesList.emptyView.hidden);
    XCTAssertTrue(self.warrantiesList.lastPageNumber == 1);
    XCTAssertTrue(self.warrantiesList.warranties = self.warranties);
}

- (void)testLoadWarrantiesSuccessWithEmptyResponse {
    [self.warrantiesList loadSuccessWithWarranties:@[]];
    
    XCTAssertFalse(self.warrantiesList.loader.isAnimating);
    XCTAssertNil(self.warrantiesList.tableView.tableHeaderView);
    XCTAssertNil(self.warrantiesList.tableView.tableFooterView);
    XCTAssertFalse(self.warrantiesList.emptyView.hidden);
}

- (void)testLoadFailure {
    [self.warrantiesList loadFailureWithError:@"Test error"];
    XCTAssertFalse(self.warrantiesList.loader.isAnimating);
    
    XCTAssertNotNil(self.warrantiesList.retryView);
    XCTAssertTrue([self.warrantiesList.retryView.backgroundColor isEqual:RGBA(255, 255, 255, 0)]);
    XCTAssertEqualObjects(self.warrantiesList, self.warrantiesList.retryView.delegate);
    XCTAssertEqualObjects(self.warrantiesList.view, self.warrantiesList.retryView.superview);
    XCTAssertTrue([self.warrantiesList.retryView.delegate respondsToSelector:@selector(retry)]);
    
    [self.warrantiesList.retryView.delegate retry];
    
    XCTAssertNil(self.warrantiesList.retryView.superview);
    XCTAssertTrue(self.warrantiesList.loader.isAnimating);
}

- (void)testLoadMore {
    [self.warrantiesList loadMore];
    
    XCTAssertTrue(self.warrantiesList.retryLoadMoreButton.hidden);
    XCTAssertTrue(self.warrantiesList.loadMoreLoader.isAnimating);
}

- (void)testLoadMoreSuccess {
    NSUInteger warrantiesCountBeforeLoadMore = self.warrantiesList.warranties.count;
    NSUInteger lastPageBeforeLoadMore = self.warrantiesList.lastPageNumber;
    [self.warrantiesList loadMoreSuccessWithWarranties:self.warranties];
    
    XCTAssertFalse(self.warrantiesList.loadMoreLoader.isAnimating);
    XCTAssertTrue(self.warrantiesList.lastPageNumber = lastPageBeforeLoadMore + 1);
    XCTAssertTrue(self.warrantiesList.warranties.count == warrantiesCountBeforeLoadMore + self.warranties.count);
    XCTAssertFalse(self.warrantiesList.endOfWarrantiesReached);
}

- (void)testLoadMoreSuccessWithEmptyResponse {
    NSUInteger warrantiesCountBeforeLoadMore = self.warrantiesList.warranties.count;
    NSUInteger lastPageBeforeLoadMore = self.warrantiesList.lastPageNumber;
    
    [self.warrantiesList loadMoreSuccessWithWarranties:@[]];
    
    XCTAssertFalse(self.warrantiesList.loadMoreLoader.isAnimating);
    XCTAssertTrue(self.warrantiesList.lastPageNumber == lastPageBeforeLoadMore);
    XCTAssertTrue(self.warrantiesList.endOfWarrantiesReached);
    XCTAssertTrue(self.warrantiesList.warranties.count == warrantiesCountBeforeLoadMore);
    XCTAssertNil(self.warrantiesList.tableView.tableFooterView);
}

- (void)testLoadMoreFailure {
    NSUInteger warrantiesCountBeforeLoadMore = self.warrantiesList.warranties.count;
    NSUInteger lastPageBeforeLoadMore = self.warrantiesList.lastPageNumber;
    
    [self.warrantiesList loadMoreFailure];
    
    XCTAssertFalse(self.warrantiesList.loadMoreLoader.isAnimating);
    XCTAssertFalse(self.warrantiesList.retryLoadMoreButton.hidden);
    XCTAssertFalse(self.warrantiesList.endOfWarrantiesReached);
    XCTAssertTrue(self.warrantiesList.warranties.count == warrantiesCountBeforeLoadMore);
    XCTAssertTrue(self.warrantiesList.lastPageNumber == lastPageBeforeLoadMore);
}

@end
