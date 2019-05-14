//
//  WBRDateTest.m
//  WalmartTests
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WBRDateTest : XCTestCase

@end

@implementation WBRDateTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)DISABLED_testDate {
    
    BOOL shouldContinue = YES;
    NSString *dateString = @"04/07/2018";
    
    while (shouldContinue) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDate *testDate = [dateFormatter dateFromString:dateString];
      
        BOOL isToday = [self isTodayDate:testDate];
        BOOL isYesterday = [self isYesterdayDate:testDate];
        BOOL isCurrentYear = [self isCurrentYearDate:testDate];
        BOOL isLastYear = [self isLastYearDate:testDate];
        
        NSLog(@"%d", isYesterday);
    }
}

- (BOOL)isTodayDate:(NSDate *)date {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendarGregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendarGregorian compareDate:date toDate:now toUnitGranularity:NSCalendarUnitDay] == NSOrderedSame ? YES : NO;
}

- (BOOL)isYesterdayDate:(NSDate *)date {

    NSDate *now = [NSDate date];
    
    NSDateComponents *componentes = [[NSDateComponents alloc] init];
    [componentes setDay:-1];
    
    NSCalendar *calendarGregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *yesterdayDate = [calendarGregorian dateByAddingComponents:componentes toDate:now options:0];
    
    NSComparisonResult result = [calendarGregorian compareDate:date toDate:yesterdayDate toUnitGranularity:NSCalendarUnitDay];
    
    return result == NSOrderedSame ? YES : NO;
}

- (BOOL)isCurrentYearDate:(NSDate *)date {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendarGregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendarGregorian compareDate:date toDate:now toUnitGranularity:NSCalendarUnitYear] == NSOrderedSame ? YES : NO;
}

- (BOOL)isLastYearDate:(NSDate *)date {
    
    NSDateComponents *componentes = [[NSDateComponents alloc] init];
    [componentes setYear:-1];
    
    NSCalendar *calendarGregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *now = [NSDate date];
    NSDate *lastYearDate = [calendarGregorian dateByAddingComponents:componentes toDate:now options:0];
    
    return [calendarGregorian compareDate:date toDate:lastYearDate toUnitGranularity:NSCalendarUnitYear] == NSOrderedSame ? YES : NO;
}

@end
