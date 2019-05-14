//
//  UIView+RetryViewTests.m
//  Walmart
//
//  Created by Renan on 6/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIView+RetryView.h"

#import "WMRetryView.h"

@interface UIView_RetryViewTests : XCTestCase

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *message;
@property (copy, nonatomic) void (^retryBlock)();

@end

@implementation UIView_RetryViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.view = [UIView new];
    
    self.message = @"Test message";
    self.retryBlock = ^{
        LogInfo(@"Retry Block");
    };
}

- (void)testShowRetryView {
    [_view showRetryViewWithMessage:_message retryBlock:_retryBlock];
    
    WMRetryView *retryView = _view.subviews.lastObject;
    XCTAssertTrue([retryView isKindOfClass:[WMRetryView class]]);
    XCTAssertEqual(retryView.superview, _view);
    
    XCTAssertEqualObjects(retryView.messageLabel.text, _message);
    XCTAssertEqualObjects(retryView.retryBlock, _retryBlock);
}

- (void)testRemoveRetryView {
    [_view showRetryViewWithMessage:_message retryBlock:_retryBlock];
    [self.view removeRetryView];
    
    for (UIView *subview in _view.subviews) {
        XCTAssertFalse([subview isKindOfClass:[WMRetryView class]]);
    }
}

@end
