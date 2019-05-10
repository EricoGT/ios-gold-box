//
//  ThemesTests.m
//  Walmart
//
//  Created by Bruno on 10/28/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ThemeManager.h"
#import "WalmartTheme.h"

@interface ThemesTests : XCTestCase

@property (nonatomic, strong) WalmartTheme *customTheme;
@property (nonatomic, strong) WalmartTheme *uncompleteTheme;

@end

@implementation ThemesTests

- (void)setUp {
    [super setUp];
    
    self.customTheme = [WalmartTheme new];
    _customTheme.backgroundColor = [UIColor redColor];
    _customTheme.headerColor = [UIColor blackColor];
    
    self.uncompleteTheme = [WalmartTheme new];
    _uncompleteTheme.backgroundColor = [UIColor redColor];
    _uncompleteTheme.headerColor = nil;
}

- (void)tearDown {
    _customTheme = nil;
    [super tearDown];
}

- (void)testSettingNewTheme {
    [ThemeManager clearTheme];
    [ThemeManager setTheme:_customTheme];
    NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager theme]];
    NSData *customThemeData = [NSKeyedArchiver archivedDataWithRootObject:_customTheme];
    
    XCTAssertTrue([themeData isEqualToData:customThemeData]);
}

- (void)testDefaultTheme {
    [ThemeManager clearTheme];
    NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager theme]];
    NSData *defaultThemeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager defaultTheme]];
    
    XCTAssertTrue([themeData isEqualToData:defaultThemeData]);
}

- (void)testClearTheme {
    [ThemeManager setTheme:_customTheme];
    NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager theme]];
    NSData *defaultThemeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager defaultTheme]];
    NSData *customThemeData = [NSKeyedArchiver archivedDataWithRootObject:_customTheme];
    
    XCTAssertFalse([customThemeData isEqualToData:defaultThemeData]);
    
    [ThemeManager clearTheme];
    themeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager theme]];
    
    XCTAssertTrue([themeData isEqualToData:defaultThemeData]);
}

- (void)testUncompleteTheme {
    [ThemeManager clearTheme];
    [ThemeManager setTheme:_uncompleteTheme];
    
    NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:[ThemeManager theme]];
    NSData *uncompleteThemeData = [NSKeyedArchiver archivedDataWithRootObject:_uncompleteTheme];
    
    XCTAssertTrue([themeData isEqualToData:uncompleteThemeData]);
}

@end
