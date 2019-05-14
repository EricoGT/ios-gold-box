//
//  WMPDFViewerTests.m
//  Walmart
//
//  Created by Renan on 6/5/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WMPDFViewerViewController.h"
//#import "OFInfoTemp.h"
#import "RetryErrorView.h"


@interface WMPDFViewerTests : XCTestCase

@property (strong, nonatomic) WMPDFViewerViewController *pdfViewer;
@property (strong, nonatomic) NSString *pdfURLStr;

@end

@implementation WMPDFViewerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.pdfURLStr = @"test.pdf";
    
    self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.pdfURLStr];
    [self.pdfViewer view];
}

- (void)testInitWithoutTitle {
    self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.pdfURLStr];
    XCTAssertTrue([self.pdfViewer.pdfURLStr isEqualToString:self.pdfURLStr]);
    XCTAssertNil(self.pdfViewer.title);
}

- (void)testInitWithTitle {
    NSString *title = @"Test Title";
    self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.pdfURLStr title:title];
    XCTAssertTrue([self.pdfViewer.title isEqualToString:title]);
    XCTAssertTrue([self.pdfViewer.pdfURLStr isEqualToString:self.pdfURLStr]);
}

- (void)testInitialization {
    XCTAssertTrue(self.pdfViewer.isFirstRequest);
    
    XCTAssertEqualObjects(self.pdfViewer, self.pdfViewer.webView.delegate);
    XCTAssertTrue(self.pdfViewer.webView.scrollView.decelerationRate == UIScrollViewDecelerationRateNormal);
    for (UIView *subView in [self.pdfViewer.webView.scrollView subviews])
    {
        if ([subView isKindOfClass:[UIImageView class]]) {
            XCTAssertTrue(subView.hidden);
        }
    }
}

- (void)testLoadPDF {
    [self.pdfViewer loadPDF];
    XCTAssertTrue(self.pdfViewer.loader.isAnimating);
}

- (void)testLoadPDFSuccess {
    [self.pdfViewer loadPDFSuccessWithData:[NSData new]];
    XCTAssertFalse(self.pdfViewer.loader.isAnimating);
}

- (void)testLoadPDFFailure {
    [self.pdfViewer loadPDFFailure];
    XCTAssertFalse(self.pdfViewer.loader.isAnimating);
    
    XCTAssertNotNil(self.pdfViewer.retryErrorView);
    XCTAssertEqualObjects(self.pdfViewer.retryErrorView.delegate, self.pdfViewer);
    XCTAssertEqualObjects(self.pdfViewer.retryErrorView.superview, self.pdfViewer.view);
    XCTAssertTrue([self.pdfViewer.retryErrorView.delegate respondsToSelector:@selector(retry)]);
    
    [self.pdfViewer.retryErrorView.delegate retry];
    
    XCTAssertNil(self.pdfViewer.retryErrorView.superview);
}

@end
