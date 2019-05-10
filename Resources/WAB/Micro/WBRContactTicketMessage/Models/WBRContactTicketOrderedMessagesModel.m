//
//  WBRContactTicketOrderedMessagesModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/8/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketOrderedMessagesModel.h"

#import "NSDate+DateTools.h"

@interface WBRContactTicketOrderedMessagesModel()

@property (strong, nonatomic) NSDictionary <NSDate *, NSArray<WBRContactTicketMessageModel *> *> *messages;

@end

@implementation WBRContactTicketOrderedMessagesModel

- (instancetype)initWithMessages:(NSArray<WBRContactTicketMessageModel *> *)messages {
    self = [super init];
    
    if (self) {
        [self setupMessagesWithArray:messages];
    }
    
    return self;
}

- (NSArray<WBRContactTicketMessageModel *> *)messagesForOrderedDay:(NSDate *)day {
    if ([self.messages objectForKey:day]) {
        return [self.messages objectForKey:day];
    }
    return nil;
}

- (NSArray<WBRContactTicketMessageModel *> *)getAllMessages {
    
    NSMutableArray *allMessages = [[NSMutableArray alloc] init];
    
    for (NSArray *messages in [self.messages allValues]) {
        [allMessages addObjectsFromArray:messages];
    }
    
    return allMessages;
}

- (void)setupMessagesWithArray:(NSArray <WBRContactTicketMessageModel *> *)messages {
    
    NSMutableArray <NSDate *> *sortedDates = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSDate *, NSMutableArray<WBRContactTicketMessageModel *> *> *sortedMessages = [[NSMutableDictionary alloc] init];
    
    [messages enumerateObjectsUsingBlock:^(WBRContactTicketMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSDate *simpleDate = [self simpleDateWithDate:obj.creationDateConverted];
        obj.creationDateConverted = [self convertedDateToTimezone:obj.creationDateConverted];
        NSMutableArray *sortedArrayForDate = [sortedMessages objectForKey:simpleDate];
        if (sortedArrayForDate) {
            [sortedArrayForDate addObject:obj];
        }
        else {
            NSMutableArray<WBRContactTicketMessageModel *> *mutableArray = [[NSMutableArray alloc] initWithArray:@[obj]];
            [sortedMessages setObject:mutableArray forKey:simpleDate];
            [sortedDates addObject:simpleDate];
        }
    }];
    
    self.orderedDates = [[NSArray alloc] initWithArray:sortedDates];
    self.messages = [[NSDictionary alloc] initWithDictionary:sortedMessages];
}

- (NSDate *)simpleDateWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSDateComponents *simpleDateDateComponents = [[NSDateComponents alloc] init];
    simpleDateDateComponents.year = year;
    simpleDateDateComponents.month = month;
    simpleDateDateComponents.day = day;
    
    NSDate *simplifiedDate = [calendar dateFromComponents:simpleDateDateComponents];
    
    return simplifiedDate;
}

- (NSDate *)convertedDateToTimezone:(NSDate *)date {
    
    NSInteger secondsFromGMT = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    return [NSDate dateWithTimeInterval:secondsFromGMT sinceDate:date];
}

@end
