//
//  WBRMessageModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageModel.h"


@implementation WBRContactTicketMessageModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"messageId": @"id",
                                                                  @"creationDateConverted": @"creationDateTimestamp",
                                                                  @"authorType": @"origin",
                                                                  @"author": @"author.name",
                                                                  @"nickname": @"author.nickname"
                                                                  }];
}

- (void)setCreationDateConvertedWithNSString:(NSString *)string {
    
    if (string) {
        
        if (string.integerValue == 0) {
            self.creationDateConverted = nil;
        } else {
            double unixTimeEstimateDate = string.doubleValue;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeEstimateDate];
            self.creationDateConverted = date;
        }
        
    } else {
        self.creationDateConverted = nil;
    }
}

@end
