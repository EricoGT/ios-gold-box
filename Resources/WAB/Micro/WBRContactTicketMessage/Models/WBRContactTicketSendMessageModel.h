//
//  WBRContactTicketSendMessageModel.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 10/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface WBRContactTicketSendMessageModel : JSONModel

- (instancetype)initWithMessage:(NSString *)message AndAttachmentIds:(nullable NSString *)attachmentId;

@end
