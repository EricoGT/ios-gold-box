//
//  WBRContactTicketSendMessageModel.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 10/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketSendMessageModel.h"
#import "NSString+HTTPEscape.h"

@interface WBRContactTicketSendMessageModel()

@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSArray<NSString *> *attachmentIds;

@end

@implementation WBRContactTicketSendMessageModel

- (instancetype)initWithMessage:(NSString *)message AndAttachmentIds:(nullable NSString *)attachmentId {
    
    self = [super init];
    if (self) {
        self.comment = [message escapeFromBreakLine];
        
        if (attachmentId) {
            self.attachmentIds = @[attachmentId];
        }
    }
    
    return self;
}

@end
