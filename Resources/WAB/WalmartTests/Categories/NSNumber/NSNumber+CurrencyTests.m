//
//  NSNumber+CurrencyTests.m
//  Walmart
//
//  Created by Renan on 6/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSNumber+Currency.h"

@interface NSNumber ()

+ (NSString *)defaultCurrencySymbol;

@end

@interface NSNumber_CurrencyTests : XCTestCase
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *decimalSeparator;
@end

@implementation NSNumber_CurrencyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSLocale *locale = [NSLocale currentLocale];
    _countryCode = [locale objectForKey: NSLocaleCountryCode];
    _decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
}

- (void)testCurrencyFormatWithInt {
    if ([_decimalSeparator isEqualToString:@","]) {
        XCTAssertEqualObjects(@"R$ 15,00", [NSNumber currencyFormatWithIntValue:(int) 15]);
    } else {
        XCTAssertEqualObjects(@"R$ 15.00", [NSNumber currencyFormatWithIntValue:(int) 15]);
    }
    
}

- (void)testCurrencyFormatWithInteger {
    if ([_decimalSeparator isEqualToString:@","]) {
        XCTAssertEqualObjects(@"R$ 15,00", [NSNumber currencyFormatWithIntegerValue:15]);
    } else {
        XCTAssertEqualObjects(@"R$ 15.00", [NSNumber currencyFormatWithIntegerValue:15]);
    }
    
}

- (void)testCurrencyFormatWithFloat {
    if ([_decimalSeparator isEqualToString:@","]) {
        XCTAssertEqualObjects(@"R$ 15,00", [NSNumber currencyFormatWithFloatValue:15.0f]);
    } else {
        XCTAssertEqualObjects(@"R$ 15.00", [NSNumber currencyFormatWithFloatValue:15.0f]);
    }
    
}

- (void)testCurrencyFormatWithDouble {
    if ([_decimalSeparator isEqualToString:@","]) {
        XCTAssertEqualObjects(@"R$ 15,00", [NSNumber currencyFormatWithDoubleValue:15.0]);
    } else {
        XCTAssertEqualObjects(@"R$ 15.00", [NSNumber currencyFormatWithDoubleValue:15.0]);
    }
    
}

- (void)testCurrencyFormatWithCurrencySymbol {
    NSString *currencySymbol = @"US ";
    NSNumber *number = @15;
    
    NSString *desiredCurrencyFormat = [NSString stringWithFormat:@"%@15.00", currencySymbol];
    
    if ([_decimalSeparator isEqualToString:@","]) {
        desiredCurrencyFormat = [NSString stringWithFormat:@"%@15,00", currencySymbol];
    }
    XCTAssertEqualObjects(desiredCurrencyFormat, [number currencyFormatWithCurrencySymbol:currencySymbol]);
}

- (void)testCurrencyFormat {
    NSNumber *number = @15;
    
    NSString *desiredCurrencyFormat = [NSString stringWithFormat:@"%@15.00", [NSNumber defaultCurrencySymbol]];
    
    if ([_decimalSeparator isEqualToString:@","]) {
        desiredCurrencyFormat = [NSString stringWithFormat:@"%@15,00", [NSNumber defaultCurrencySymbol]];
    }
    XCTAssertEqualObjects(desiredCurrencyFormat, [number currencyFormat]);
}

@end
