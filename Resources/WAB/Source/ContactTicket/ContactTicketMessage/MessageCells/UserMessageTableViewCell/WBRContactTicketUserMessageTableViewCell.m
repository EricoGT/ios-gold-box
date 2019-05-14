//
//  WBRUserTableViewCell.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketUserMessageTableViewCell.h"
#import "WBRContactTicketMessageAttachmentFileView.h"

static NSString *kWBRUserTableViewCellIdentifier = @"WBRUserTableViewCellIdentifier";

@interface WBRContactTicketUserMessageTableViewCell()

@end

@implementation WBRContactTicketUserMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(WBRContactTicketMessageModel *)message ofTicket:(NSString *)ticketId WithCompletion:(kContactTicketSetMessagesCompletionBlock)completion {
    [super setMessage:message ofTicket:ticketId WithCompletion:completion];
    
    if (completion) {
        completion();
    }
}

+ (NSString *)identifier {
    return kWBRUserTableViewCellIdentifier;
}

@end
