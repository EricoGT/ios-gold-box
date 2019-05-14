//
//  WBRModelTicket.m
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRModelTicket.h"
#import "WBRContactTicketUtils.h"

@implementation WBRModelTicket

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ticketId"            : @"id",
                                                                  @"ticketDescription"   : @"description",
                                                                  @"dueDate"             : @"slaDate",
                                                                  @"orderId"             : @"walmartOrderId",
                                                                  @"orderImages"         : @"items"}];
}

- (BOOL)isTicketOpen {
    if ([self.status isEqualToString:kTicketClosedStatus] || [self.status isEqualToString:kTicketCanceledStatus]){
        return NO;
    }
    return YES;
}

@end
