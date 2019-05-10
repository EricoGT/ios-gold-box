//
//  UIView+EmptyViewTests.m
//  Walmart
//
//  Created by Renan on 6/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIView+EmptyView.h"
#import "WMEmptyView.h"

@interface UIView_EmptyViewTests : XCTestCase

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *message;

@end

@implementation UIView_EmptyViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.view = [UIView new];
    
    self.message = @"Test message";
}

- (void)testShowEmptyView {
    [_view showEmptyViewWithMessage:_message];
    
    WMEmptyView *emptyView = _view.subviews.lastObject;
    XCTAssertTrue([emptyView isKindOfClass:[WMEmptyView class]]);
    XCTAssertEqual(emptyView.superview, _view);
    
    XCTAssertEqualObjects(emptyView.messageLabel.text, _message);
}

- (void)testShowEmptyViewWithAttributedMessage {
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:_message];
    [_view showEmptyViewWithAttributedMessage:attributedMessage];
    
    WMEmptyView *emptyView = _view.subviews.lastObject;
    XCTAssertTrue([emptyView isKindOfClass:[WMEmptyView class]]);
    XCTAssertEqual(emptyView.superview, _view);
    
    XCTAssertEqualObjects(emptyView.messageLabel.attributedText, attributedMessage);
}

- (void)testHideEmptyView {
    [self.view showEmptyViewWithMessage:_message];
    [self.view hideEmptyView];
    
    for (UIView *subview in _view.subviews) {
        XCTAssertFalse([subview isKindOfClass:[WMEmptyView class]]);
    }
}

@end
