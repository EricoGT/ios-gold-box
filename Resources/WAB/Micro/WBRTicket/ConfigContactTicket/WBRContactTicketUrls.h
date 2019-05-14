//
//  WBRContactTicketUrls.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL_TICKET_HUB_LIST BASE_URL_TICKET_HUB @"tickets"
#define URL_TICKET_HUB_REOPEN URL_TICKET_HUB_LIST @"/" @"%@" @"/" @"reopen"
#define URL_CONTACT_TICKET_CANCEL BASE_URL_TICKET_HUB @"/" @"tickets/%@/status"

@interface WBRContactTicketUrls : NSObject

@end
