//
//  WBRContactTicketOrderedMessagesModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/8/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

#import "WBRContactTicketMessageModel.h"

@interface WBRContactTicketOrderedMessagesModel : JSONModel

@property (strong, nonatomic) NSArray<NSDate *> *orderedDates;

- (instancetype)initWithMessages:(NSArray<WBRContactTicketMessageModel *> *)messages;
- (NSArray<WBRContactTicketMessageModel *> *)messagesForOrderedDay:(NSDate *)day;
- (NSArray<WBRContactTicketMessageModel *> *)getAllMessages;

@end
