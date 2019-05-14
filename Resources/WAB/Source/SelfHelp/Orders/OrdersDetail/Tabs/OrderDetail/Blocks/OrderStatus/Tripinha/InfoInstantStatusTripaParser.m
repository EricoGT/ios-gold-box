//
//  InfoInstantStatusTripaParser.m
//  TripaView
//
//  Created by Bruno Delgado on 5/20/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "InfoInstantStatusTripaParser.h"
#import "TrackingTimelineSubItem.h"
#import "DateTools.h"

@implementation InfoInstantStatusTripaParser

+ (NSArray *)parseTimelineItems:(NSArray *)items
{
    NSMutableArray *allStatus = [NSMutableArray new];
    
    //Grabbing all valid/possible dates
    NSMutableArray *dates = [NSMutableArray new];
    for (TrackingTimelineSubItem *substatusDetail in items)
    {
        NSDate *date = substatusDetail.eventDate;
        if (date)
        {
            [dates addObject:[date formattedDateWithFormat:@"dd/MM/YYYY"]];
        }
    }
    
    //Filtering unique dates and ordering
    NSArray *orderedUniqueDates = [[NSOrderedSet orderedSetWithArray:dates.copy] array];
    
    //Filling the array.
    //Structure to follow:
    //  NSArray
    //      NSDictionary
    //          Date formatted (NSString)
    //          NSArray
    //              Description (NSString)
    //              Time (NSString)
    
    for (NSString *dateString in orderedUniqueDates)
    {
        NSMutableDictionary *rootDictionary = [NSMutableDictionary new];
        NSMutableArray *detailsArray = [NSMutableArray new];
        
        [rootDictionary setObject:dateString forKey:@"date"];
        
        for (TrackingTimelineSubItem *substatusDetail in items)
        {
            NSDate *date = substatusDetail.eventDate;
            if (date)
            {
                NSString *dateToCompare = [date formattedDateWithFormat:@"dd/MM/YYYY"];
                if ([dateString isEqualToString:dateToCompare])
                {
                    //Same date, so we should group
                    NSString *aDescription = (substatusDetail.descriptionText) ?: @"";
                    NSString *theTime = [date formattedDateWithFormat:@"HH:mm"];
                    [detailsArray addObject:@{@"description" : aDescription,
                                              @"time"        : theTime }];
                    if (substatusDetail.alert.length > 0) {
                        [detailsArray addObject:@{@"alert" : substatusDetail.alert}];
                    }
                }
            }
        }
        
        [rootDictionary setObject:detailsArray.copy forKey:@"details"];
        [allStatus addObject:rootDictionary];
    }
    
    return allStatus.copy;
}

#pragma mark - Mock
+ (NSArray *)__mockTripaArray
{
  NSDictionary *detail11 = @{@"time" : @"05:18",
                             @"description" : @"Objeto saiu para entrega"};
  
  NSDictionary *detail12 = @{@"time" : @"05:19",
                             @"description" : @"Objeto saiu para entrega de verdade"};
  
  NSDictionary *detail13 = @{@"time" : @"05:20",
                             @"description" : @"Objeto saiu para entrega de verdade mesmo"};
  
  NSDictionary *detail14 = @{@"time" : @"06:20",
                             @"description" : @"Objeto saiu para entrega de verdade mesmo. Essa é uma linha realmente longa para ver como a interface se comporta."};
  
  NSDictionary *detail15 = @{@"time" : @"07:20",
                             @"description" : @"👍"};
  
  NSArray *details1 = @[detail11, detail12, detail13, detail14, detail15];
  NSDictionary *status1 = @{@"date" : @"01/02/2014",
                            @"details" : details1};
  
  
  NSDictionary *detail21 = @{@"time" : @"05:18",
                             @"description" : @"Objeto saiu para entrega"};
  
  NSDictionary *detail22 = @{@"time" : @"05:19",
                             @"description" : @"Objeto saiu para entrega de verdade"};
  
  NSDictionary *detail23 = @{@"time" : @"05:20",
                             @"description" : @"Objeto saiu para entrega de verdade mesmo"};
  
  NSDictionary *detail24 = @{@"time" : @"06:20",
                             @"description" : @"Objeto saiu para entrega de verdade mesmo. Essa é uma linha realmente longa para ver como a interface se comporta."};
  
  NSDictionary *detail25 = @{@"time" : @"07:20",
                             @"description" : @"👍"};
  
  NSArray *details2 = @[detail21, detail22, detail23, detail24, detail25];
  
  NSDictionary *status2 = @{@"date" : @"05/02/2014",
                            @"details" : details2};
  NSArray *testArray = @[status1, status2];
  return testArray;
}

@end
