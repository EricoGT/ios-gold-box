//
//  WalmartTests.m
//  WalmartTests
//
//  Created by Marcelo Santos on 05/12/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OFAppDelegate.h"

@interface WalmartTests : XCTestCase {
@private
    OFAppDelegate *app_delegate;
//    UIView *_window;
}
@end

@implementation WalmartTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    app_delegate = [[UIApplication sharedApplication] delegate];
//    splash_view = app_delegate.viewController;
//    home_view = [[OFNewHomeViewController alloc] init];
//    [home_view updateStrCollection:@"Teste de string"];
//    banner = [[BannerSkin alloc] init];
//    
//    // Load the window, but don't show it.
////    _window = [banner window];
//    _window = [banner view];
    app_delegate = [[OFAppDelegate alloc] init];
}

//- (void)testAppDelegate {
////    XCTAssertNotNil(app_delegate, @"Cannot find the application delegate");
////    XCTAssertNotNil(home_view, @"Cannot create Home instance");
//}
//
//- (void)testNibNameBannerSkin {
////    NSLog(@"Nib name: %@", [banner nibName]);
////    XCTAssertEqualObjects([banner nibName], @"BannerSkin",
////                         @"The nib for this window should be BannerSkin.xib");
//}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    app_delegate = nil;
}

//- (void) testImageSplashDimensions{
//
////    float w = splash_view.imgPromotion.frame.size.width;
////    float h = splash_view.imgPromotion.frame.size.height;
////    
////    NSString *widthImg = [NSString stringWithFormat:@"%.0f", w];
////    NSString *heightImg = [NSString stringWithFormat:@"%.0f", h];
////    NSLog(@"Testing Image width : %@", widthImg);
////    NSLog(@"Testing Image height: %@", heightImg);
////    
////    XCTAssertEqualObjects(widthImg, @"225", @"Width Splash image is wrong");
////    XCTAssertEqualObjects(heightImg, @"190", @"Height Splash image is wrong");
////    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//    
//    XCTAssertEqualObjects([app_delegate testExample], @"Marcelo",
//                          @"O nome deve ser Marcelo");
//
//}
//
//- (void) testHome {
//    
////    XCTAssertTrue([[home_view strCollectionId] isEqualToString:@"Teste de string"], @"");
////    NSLog(@"strCollection: %@", [home_view strCollectionId]);
////    
////    NSLog(@"strCollection: %@", home_view.strCollectionId);
////    XCTAssertTrue([OFNewHomeViewController instancesRespondToSelector:@selector(removeViewsFromAddress)], @"removeViews fail");
//}
//
//- (void) testImageCard {
//    
////    float w = banner.imgBanner.frame.size.width;
////    float h = banner.imgBanner.frame.size.height;
////    
////    NSString *widthImg = [NSString stringWithFormat:@"%.0f", w];
////    NSString *heightImg = [NSString stringWithFormat:@"%.0f", h];
////    NSLog(@"Testing Banner Image width : %@", widthImg);
////    NSLog(@"Testing Banner Image height: %@", heightImg);
//}
//
//- (void) testPaths {
//    
////    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
////    NSString *directBundlePath = [[NSBundle bundleForClass:[self class]] resourcePath];
////    NSLog(@"Main Bundle Path: %@", mainBundlePath);
////    NSLog(@"Direct Path: %@", directBundlePath);
////    NSString *mainBundleResourcePath = [[NSBundle mainBundle] pathForResource:@"AppIcon58x58.png" ofType:nil];
////    NSString *directBundleResourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"AppIcon58x58.png" ofType:nil];
////    NSLog(@"Main Bundle Path: %@", mainBundleResourcePath);
////    NSLog(@"Direct Path: %@", directBundleResourcePath);
//}

@end
