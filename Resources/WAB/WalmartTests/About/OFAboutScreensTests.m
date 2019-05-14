//
//  OFAboutScreensTests.m
//  Walmart
//
//  Created by Marcelo Santos on 2/22/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "OFAboutScreensViewController.h"

@interface OFAboutScreensTests : XCTestCase
@property (nonatomic, strong) OFAboutScreensViewController *ofa;
@property (nonatomic, assign) NSString *nibNameFake;
@property (nonatomic, assign) NSBundle *bundleFake;
@property (nonatomic, assign) NSString *fileHtml;
@property (nonatomic, assign) NSString *titleFake;
@property BOOL isFromConfirmFake;
@end

@interface OFAboutScreensViewController (Tests)
@property (assign, nonatomic) BOOL isFromConfirm;
@property (weak, nonatomic) UIButton *btBack;
@property (weak, nonatomic) UIButton *btBackModal;
@property (weak, nonatomic) UILabel *lblTitle;
@property (weak, nonatomic) UIWebView *webContent;
@property (strong, nonatomic) NSURL *urlOut;
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType;
- (void) back;
- (void) backModal;
- (void)handleEnteredBackground:(NSNotification *)notification;
@end

@implementation OFAboutScreensTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _nibNameFake = @"FakeNib";
    _bundleFake = [NSBundle mainBundle];
    _fileHtml = @"termosUsoIOS";
    _titleFake = @"Fake Title";
    _isFromConfirmFake = YES;
    
    self.ofa = [[OFAboutScreensViewController alloc] initWithNibName:_nibNameFake bundle:_bundleFake andHtmlFile:_fileHtml andTitle:_titleFake isFromConfirm:_isFromConfirmFake];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    self.ofa = nil;
    
    [super tearDown];
}

- (void)testInitWithNibName {

    XCTAssertNotNil(self.ofa);
    XCTAssertEqual(self.ofa.nibName, _nibNameFake, @"Fail: %@", self.ofa.nibName);
    XCTAssertEqual(self.ofa.nibBundle, _bundleFake, @"Fail: %@", self.ofa.nibBundle);
    XCTAssertEqual(self.ofa.fileHtml, _fileHtml, @"Fail: %@", self.ofa.fileHtml);
    XCTAssertEqual(self.ofa.strTitle, _titleFake, @"Fail: %@", self.ofa.strTitle);
    XCTAssertTrue(self.ofa.isFromConfirm, @"Fail: %i", self.ofa.isFromConfirm);
}

- (void) testVariables {
    
    XCTAssertEqual(self.ofa.strTitle, _titleFake, @"Fail: %@", self.ofa.strTitle);
    XCTAssertEqual(self.ofa.fileHtml, _fileHtml, @"Fail: %@", self.ofa.fileHtml);
    XCTAssertTrue(self.ofa.isFromConfirm, @"Fail: %i", self.ofa.isFromConfirm);
    
    
    _isFromConfirmFake = NO;
    self.ofa = nil;
    self.ofa = [[OFAboutScreensViewController alloc] initWithNibName:_nibNameFake bundle:_bundleFake andHtmlFile:_fileHtml andTitle:_titleFake isFromConfirm:_isFromConfirmFake];
    
    XCTAssertFalse(self.ofa.isFromConfirm, @"Fail: %i", self.ofa.isFromConfirm);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
