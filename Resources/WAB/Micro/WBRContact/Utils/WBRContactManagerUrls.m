//
//  WBRContactManagerUrls.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactManagerUrls.h"

#define URL_CONTACT_TICKET_REASONS BASE_URL_TICKET_HUB @"reasons"
#define URL_CONTACT_TICKET BASE_URL_TICKET_HUB @"tickets"

@implementation WBRContactManagerUrls

+ (NSString *)urlContactTicketSubjects {
    return [NSString stringWithFormat:@"%@/contact/subjects", URL_CONTACT_TICKET_REASONS];
}

+ (NSString *)urlContactRequestOrders {
    return [NSString stringWithFormat:@"%@%@/contact/form/order", BASE_URL, APP_VERSION];
}

+ (NSString *)urlContactRequestDelivery {
    return [NSString stringWithFormat:@"%@%@/contact/delivery/", BASE_URL, APP_VERSION];
}

+ (NSString *)urlContactRequestExchange {
    return [NSString stringWithFormat:@"%@%@/contact/exchange/", BASE_URL, APP_VERSION];
}

+ (NSString *)urlContactRequestBanks {
    return [NSString stringWithFormat:@"%@%@/payment/bank/list", BASE_URL_WEBSTORE, APP_VERSION];
}

+ (NSString *)urlContactRequestOrderDetail {
    return [[OFUrls new] getURLOrdersDetail];
}

+ (NSString *)urlContactRequestOpenTicket {
    return URL_CONTACT_TICKET;
}

@end
