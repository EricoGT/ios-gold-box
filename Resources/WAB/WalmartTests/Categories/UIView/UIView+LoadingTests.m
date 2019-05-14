//
//  UIView+LoadingTests.m
//  Walmart
//
//  Created by Renan on 6/9/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIView+Loading.h"

#import "WMLoadingView.h"
#import "WMModalLoadingView.h"

@interface UIView_LoadingTests : XCTestCase

@property (strong, nonatomic) UIView *view;

@end

@implementation UIView_LoadingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.view = [UIView new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShowLoading {
    [self.view showLoading];
    
    WMLoadingView *loadingView = self.view.subviews.lastObject;
    XCTAssertNotNil(loadingView);
}

- (void)testShowLoadingWithBackgroundColor {
    UIColor *color = RGBA(0, 0, 0, 1);
    [self.view showLoadingWithBackgroundColor:color];
    
    WMLoadingView *loadingView = self.view.subviews.lastObject;
    XCTAssertEqualObjects(color, loadingView.backgroundColor);
}

- (void)testShowLoadingWithLoaderColor {
    UIColor *color = RGBA(0, 0, 0, 1);
    [self.view showLoadingWithLoaderColor:color];
    
    WMLoadingView *loadingView = self.view.subviews.lastObject;
    XCTAssertEqualObjects(color, loadingView.loader.color);
}

- (void)testShowLoadingWithBackgroundColorAndLoaderColor {
    UIColor *backgroundColor = RGBA(0, 0, 0, 1);
    UIColor *loaderColor = RGBA(26, 117, 207, 1);
    [self.view showLoadingWithBackgroundColor:backgroundColor loaderColor:loaderColor];
    
    WMLoadingView *loadingView = self.view.subviews.lastObject;
    XCTAssertEqualObjects(backgroundColor, loadingView.backgroundColor);
    XCTAssertEqualObjects(loaderColor, loadingView.loader.color);
}

- (void)testHideLoading {
    [self.view showLoading];
    [self.view hideLoading];
    
    for (UIView *subview in _view.subviews) {
        XCTAssertFalse([subview isKindOfClass:[WMLoadingView class]]);
    }
}

#pragma mark - Modal Loading
- (void)testShowModalLoading {
    [self.view showLoading];
    
    WMModalLoadingView *loadingView = self.view.subviews.lastObject;
    XCTAssertNotNil(loadingView);
}

- (void)testHideModalLoading {
    [self.view showLoading];
    
    for (UIView *subview in _view.subviews) {
        XCTAssertFalse([subview isKindOfClass:[WMModalLoadingView class]]);
    }
}

@end
