//
//  WBRUTMTests.m
//  WalmartTests
//
//  Created by Guilherme Nunes Ferreira on 10/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FXKeychain.h"
#import "WBRUTM.h"
#import "TimeManager.h"

static NSString * const kUTMDeepLinkParameterSource = @"utm_source";
static NSString * const kUTMDeepLinkParameterMedium = @"utm_medium";
static NSString * const kUTMDeepLinkParameterCampaign = @"utm_campaign";

@interface WBRUTMTests : XCTestCase

@end

@interface WBRUTM (Tests)

+ (FXKeychain *)keychain;
+ (BOOL)URLShouldAddUTMParameters:(NSURL *)url;
+ (NSString *)getUTMQueryStringByKey:(NSString *)utmKey withURLParameter:(NSString *)urlParameter;
+ (WBRUTMModel *)UTMForKey:(NSString *)key;
+ (NSString *)getFormattedURLWithQueryStringWithURL:(NSString *)url andUTM:(NSString *)utm;
+ (BOOL)HeaderShouldAddUTMParameters:(NSURL *)url;

@end

@implementation WBRUTMTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHandleDeepLinkSource {
    
    NSString *deepLink = @"walmartbrqa://fq=H:34857&utm_source=google-dsa";
    [WBRUTM handleDeepLink:deepLink];
    WBRUTMModel *UTMSaved = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainSource];
    XCTAssertTrue([UTMSaved.UTMValue isEqualToString:@"google-dsa"]);
}

- (void)testHandleDeepLinkMedium {
    
    NSString *deepLink = @"walmartbrqa://utm_medium=retargeting";
    [WBRUTM handleDeepLink:deepLink];
    WBRUTMModel *UTMSaved = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainMedium];
    XCTAssertTrue([UTMSaved.UTMValue isEqualToString:@"retargeting"]);
}

- (void)testHandleDeepLinkCampaign {
    
    NSString *deepLink = @"walmartbrqa://utm_campaign=lwf";
    [WBRUTM handleDeepLink:deepLink];
    WBRUTMModel *UTMSaved = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainCampaign];
    XCTAssertTrue([UTMSaved.UTMValue isEqualToString:@"lwf"]);
}

- (void)testHandleDeepLinkComplete {
    
    NSString *deepLink = @"walmartbrqa://utm_source=google-pla&adtype=pla&utm_medium=ppc&utm_term=1838419&utm_campaign=eletronicos+1838419";
    [WBRUTM handleDeepLink:deepLink];
    
    WBRUTMModel *UTMSource = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainSource];
    WBRUTMModel *UTMMedium = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainMedium];
    WBRUTMModel *UTMCampaign = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainCampaign];
    
    XCTAssertTrue([UTMSource.UTMValue isEqualToString:@"google-pla"]);
    XCTAssertTrue([UTMMedium.UTMValue isEqualToString:@"ppc"]);
    XCTAssertTrue([UTMCampaign.UTMValue isEqualToString:@"eletronicos+1838419"]);
}

- (void)testUpdateHourIfNeeded {
    
    NSString *deepLink = @"walmartbrqa://utm_source=google-pla&adtype=pla&utm_medium=ppc&utm_term=1838419&utm_campaign=eletronicos+1838419";
    [WBRUTM handleDeepLink:deepLink];
    
    NSDate *currentDate = [NSDate date];
    [WBRUTM updateHourIfNeeded:currentDate];
    
    WBRUTMModel *UTMSource = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainSource];
    WBRUTMModel *UTMMedium = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainMedium];
    WBRUTMModel *UTMCampaign = (WBRUTMModel *)[WBRUTM.keychain objectForKey:kUTMKeychainCampaign];
    
    XCTAssertTrue([UTMSource.savedDate isEqualToDate:currentDate]);
    XCTAssertTrue([UTMMedium.savedDate isEqualToDate:currentDate]);
    XCTAssertTrue([UTMCampaign.savedDate isEqualToDate:currentDate]);
}

- (void)testURLWithoutUTMParameters {
    
    NSString *url = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_source=teste"];
    XCTAssertTrue([url isEqualToString:@"walmartbrqa://"]);
    
    NSString *url1 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_medium=Teste"];
    XCTAssertTrue([url1 isEqualToString:@"walmartbrqa://"]);
    
    NSString *url2 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_campaign=teste"];
    XCTAssertTrue([url2 isEqualToString:@"walmartbrqa://"]);
    
    NSString *url3 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_source=teste&utm_medium=Teste"];
    XCTAssertTrue([url3 isEqualToString:@"walmartbrqa://"]);
    
    NSString *url4 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://productId=teste&utm_source=teste"];
    XCTAssertTrue([url4 isEqualToString:@"walmartbrqa://productId=teste"]);
    
    NSString *url5 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://productId=teste&utm_source=teste&utm_medium=Teste"];
    XCTAssertTrue([url5 isEqualToString:@"walmartbrqa://productId=teste"]);
    
    NSString *url6 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://productId=teste&utm_source=teste&utm_medium=Teste&utm_campaign=teste"];
    XCTAssertTrue([url6 isEqualToString:@"walmartbrqa://productId=teste"]);
    
    NSString *url7 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_source=teste&utm_medium=Teste&productId=teste"];
    XCTAssertTrue([url7 isEqualToString:@"walmartbrqa://productId=teste"]);
    
    NSString *url8 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://searchQuery=teste&teste=123&utm_source=teste&utm_medium=Teste"];
    XCTAssertTrue([url8 isEqualToString:@"walmartbrqa://searchQuery=teste&teste=123"]);
    
    NSString *url9 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://utm_source=teste&productId=1231&utm_medium=Teste&searchQuery=teste&teste=123"];
    XCTAssertTrue([url9 isEqualToString:@"walmartbrqa://productId=1231&searchQuery=teste&teste=123"]);
    
    NSString *url10 = [WBRUTM urlWithoutUTMParameters:@"walmartbrqa://productSku=12311&utm_source=teste"];
    XCTAssertTrue([url10 isEqualToString:@"walmartbrqa://productSku=12311"]);
}

- (void)testURLShouldAddUTMParameters {
    
    NSArray *urlsToCheck = @[@"/navigation/home/dynamic",
                              @"/navigation/home/static",
                              @"/wishList/skus",
                              @"/list/wishlist",
                              @"/navigation/product/",
                              @"/navigation/sku/",
                              @"/cart/addAllProducts/seller",
                              @"/checkout/track",
                              @"/cart/updateCart",
                              @"/checkout/freight",
                              @"/cart/loadCart/",
                              @"/cart/findGroupedCart/",
                              @"/cart/selectDeliveryPaymentWithCompleteCart",
                              @"/checkout/installments",
                              @"/order",
                              @"/navigation/sku/",
                             @"/cart/removeProduct"];
    
    for (NSString *urlToCheck in urlsToCheck) {
        NSURL *urlNeedUTM = [NSURL URLWithString:[NSString stringWithFormat:@"www.testeurl.com%@", urlToCheck]];
        NSLog(@"urlToCheck = %@", urlNeedUTM);
        XCTAssertTrue([WBRUTM URLShouldAddUTMParameters:urlNeedUTM]);
    }
    
    NSURL *urlNoNeedUTM = [NSURL URLWithString:@"www.testurl.com"];
    XCTAssertFalse([WBRUTM URLShouldAddUTMParameters:urlNoNeedUTM]);
}

- (void)testGetFormattedURLWithQueryString {
    NSString *url = @"www.testeurl.com";
    NSString *utm = @"utmtest=123";
    
    NSString *formattedUrl = [WBRUTM getFormattedURLWithQueryStringWithURL:url andUTM:utm];
    NSString *test = [NSString stringWithFormat:@"%@?%@", url, utm];
    XCTAssertTrue([formattedUrl isEqualToString:test]);
    
    NSString *url2 = @"www.testeurl.com?queryString=other";
    NSString *utm2 = @"utmtest=123";
    
    NSString *formattedUrl2 = [WBRUTM getFormattedURLWithQueryStringWithURL:url2 andUTM:utm2];
    NSString *test2 = [NSString stringWithFormat:@"%@&%@", url2, utm2];
    XCTAssertTrue([formattedUrl2 isEqualToString:test2]);
}

- (void)testGetUTMQueryStringByKey {
    
    NSString *utmSourceQueryString = [WBRUTM getUTMQueryStringByKey:kUTMKeychainSource withURLParameter:kUTMDeepLinkParameterSource];
    
    WBRUTMModel *utmSource = [WBRUTM UTMForKey:kUTMKeychainSource];
    NSString *utmQueryString = @"";
    if (utmSource && [TimeManager UTMDateStillValid:utmSource.savedDate]) {
        utmQueryString = [NSString stringWithFormat:@"utm_source=%@", utmSource.UTMValue];
    }
    
    XCTAssertTrue([utmSourceQueryString isEqualToString:utmQueryString]);
}

- (void)DISABLED_testAddUTMQueryParameterToUrl {
    [WBRUTM invalidateUTMs];
    
    NSString *sourceValue = [NSString stringWithFormat:@"%@=123", kUTMDeepLinkParameterSource];
    NSString *mediumValue = [NSString stringWithFormat:@"%@=456", kUTMDeepLinkParameterMedium];
    NSString *campaignValue = [NSString stringWithFormat:@"%@=789", kUTMDeepLinkParameterCampaign];
    
    NSString *deepLink = [NSString stringWithFormat:@"walmartbrqa://fq=H:34857&%@&%@&%@", sourceValue, mediumValue, campaignValue];
    [WBRUTM handleDeepLink:deepLink];
    NSDate *currentDate = [NSDate date];
    [WBRUTM updateHourIfNeeded:currentDate];
    
    NSURL *url = [NSURL URLWithString:@"www.test.com"];
    NSURL *urlWithUTM = [WBRUTM addUTMQueryParameterTo:url];
    NSString *test = [NSString stringWithFormat:@"%@?%@&%@&%@", url, sourceValue, mediumValue, campaignValue];
    XCTAssertFalse([urlWithUTM.absoluteString isEqualToString:test]);
    
    url = [NSURL URLWithString:@"www.test.com/navigation/sku/"];
    urlWithUTM = [WBRUTM addUTMQueryParameterTo:url];
    test = [NSString stringWithFormat:@"%@?%@&%@&%@", url, sourceValue, mediumValue, campaignValue];
    XCTAssertTrue([urlWithUTM.absoluteString isEqualToString:test]);
}

- (void)testHeaderShouldAddUTMParameters {
    
    NSArray *urlsToCheck = @[@"/navigation/search/"];
    
    for (NSString *urlToCheck in urlsToCheck) {
        NSURL *urlNeedUTM = [NSURL URLWithString:[NSString stringWithFormat:@"www.testeurl.com%@", urlToCheck]];
        NSLog(@"urlToCheck = %@", urlNeedUTM);
        XCTAssertTrue([WBRUTM HeaderShouldAddUTMParameters:urlNeedUTM]);
    }
    
    NSURL *urlNoNeedUTM = [NSURL URLWithString:@"www.testurl.com"];
    XCTAssertFalse([WBRUTM HeaderShouldAddUTMParameters:urlNoNeedUTM]);
}

- (void)testAddUTMInHeader {
    [WBRUTM invalidateUTMs];
    
    NSString *sourceValue = [NSString stringWithFormat:@"%@=123", kUTMDeepLinkParameterSource];
    NSString *mediumValue = [NSString stringWithFormat:@"%@=456", kUTMDeepLinkParameterMedium];
    NSString *campaignValue = [NSString stringWithFormat:@"%@=789", kUTMDeepLinkParameterCampaign];
    
    NSString *deepLink = [NSString stringWithFormat:@"walmartbrqa://fq=H:34857&%@&%@&%@", sourceValue, mediumValue, campaignValue];
    [WBRUTM handleDeepLink:deepLink];
    NSDate *currentDate = [NSDate date];
    [WBRUTM updateHourIfNeeded:currentDate];
    
    NSURL *url = [NSURL URLWithString:@"www.test.com"];
    NSDictionary *utmHeader = [WBRUTM addUTMHeaderTo:url];
    XCTAssertTrue([utmHeader count] == 0);
    
    url = [NSURL URLWithString:@"www.test.com/navigation/search/"];
    utmHeader = [WBRUTM addUTMHeaderTo:url];
    NSDictionary *testUTMHeader = @{
                                    kUTMDeepLinkParameterSource: @"123",
                                    kUTMDeepLinkParameterMedium: @"456",
                                    kUTMDeepLinkParameterCampaign: @"789",
                                    };
    
    for (NSString *utmHeaderKey in [utmHeader allKeys]) {
        XCTAssertTrue([utmHeader[utmHeaderKey] isEqualToString:testUTMHeader[utmHeaderKey]]);
    }
}

@end
