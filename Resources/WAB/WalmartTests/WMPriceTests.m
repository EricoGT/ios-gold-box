//
//  WMPriceTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//#import "WMPrice.h"

@interface WMPriceTests : XCTestCase {
    
//    WMPrice *pc;
}

@end

@implementation WMPriceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
//    pc = [[WMPrice alloc] init];
//    [pc view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    pc = nil;
    [super tearDown];
}

- (void) testPriceDeAndPorMinorValueThanOriginalPrice {
    
//    NSDictionary *testPrice = @{@"dePrice"          : @"10",
//                                @"porPrice"         : @"5",
//                                @"globalProduct"    : [NSNumber numberWithFloat:NO],
//                                @"priceInstallments": @"1x de R$  34.11 sem juros",
//                                @"available"        : [NSNumber numberWithFloat:YES],
//                                @"currency"         : @"R$",
//                                @"hasVariations"    : [NSNumber numberWithFloat:NO],
//                                @"importTax"        : [NSNumber numberWithInt:0],
//                                @"priceDe"          : @"De R$  10.00",
//                                @"pricePor"         : @"Por R$  5.00",
//                                @"priceSeller"      : @"Fornecido por Walmart:",
//                                @"priceStatus"      : @"Em estoque",
//                                @"priceVariations"  : [NSNumber numberWithInt:0],
//                                @"selectedCariation": [NSNumber numberWithInt:0],
//                                @"stampUrl"         : @"http://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/62x62/walmartv5/stamp/aab3fc0d-6-9c374edb-c-WMSELO.png"
//                                };
//    
//    [pc feedPriceWith:testPrice];
//    
//    NSString *strPriceDeCorrect = @"De R$ 10.00 por";
//    
//    XCTAssertTrue([pc.lblPriceDe.text isEqualToString:strPriceDeCorrect]);
}

- (void) testPriceDeAndPorMajorOrEqualValueThanOriginalPrice {
    
//    NSDictionary *testPrice = @{@"dePrice"          : @"10",
//                                @"porPrice"         : @"10",
//                                @"globalProduct"    : [NSNumber numberWithFloat:NO],
//                                @"priceInstallments": @"1x de R$  34.11 sem juros",
//                                @"available"        : [NSNumber numberWithFloat:YES],
//                                @"currency"         : @"R$",
//                                @"hasVariations"    : [NSNumber numberWithFloat:NO],
//                                @"importTax"        : [NSNumber numberWithInt:0],
//                                @"priceDe"          : @"De R$  10.00",
//                                @"pricePor"         : @"Por R$  10.00",
//                                @"priceSeller"      : @"Fornecido por Walmart:",
//                                @"priceStatus"      : @"Em estoque",
//                                @"priceVariations"  : [NSNumber numberWithInt:0],
//                                @"selectedCariation": [NSNumber numberWithInt:0],
//                                @"stampUrl"         : @"http://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/62x62/walmartv5/stamp/aab3fc0d-6-9c374edb-c-WMSELO.png"
//                                };
//    
//    [pc feedPriceWith:testPrice];
//    
//    NSString *strPriceDeCorrect = @"";
//    
//    XCTAssertTrue([pc.lblPriceDe.text isEqualToString:strPriceDeCorrect]);
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
