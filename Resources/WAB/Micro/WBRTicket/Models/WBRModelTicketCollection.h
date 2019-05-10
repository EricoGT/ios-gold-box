//
//  WBRModelTicketCollection.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRModelTicket.h"

@interface WBRModelTicketCollection : JSONModel

@property (strong, nonatomic) NSArray<WBRModelTicket, Optional> *tickets;

@end
