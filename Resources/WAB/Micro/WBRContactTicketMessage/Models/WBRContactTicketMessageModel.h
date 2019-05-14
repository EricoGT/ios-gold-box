//
//  WBRMessageModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRContactTicketAttachmentModel.h"

@interface WBRContactTicketMessageModel : JSONModel

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic) NSDate *creationDateConverted;
@property (strong, nonatomic) NSString<Optional> *text;
@property (strong, nonatomic) NSString *authorType;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSArray<WBRContactTicketAttachmentModel, Optional> *attachments;

@end
