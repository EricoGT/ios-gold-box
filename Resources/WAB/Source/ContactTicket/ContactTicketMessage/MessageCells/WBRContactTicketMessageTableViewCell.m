//
//  WBRMessageTableViewCell.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageTableViewCell.h"
#import "WBRContactTicketMessageAttachmentFileView.h"

#import "NSDate+DateTools.h"
#import "UIView+Radius.h"

@interface WBRContactTicketMessageTableViewCell() <WBRContactTicketMessageAttachmentDelegate>

@end

@implementation WBRContactTicketMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (self.attachmentContainer.subviews.count == 1) {
        [self.attachmentContainer.subviews[0] removeFromSuperview];
    }
    
    [self.attachmentContainer setHidden:YES];
}

- (void)setMessage:(WBRContactTicketMessageModel *)message ofTicket:(NSString *)ticketId WithCompletion:(kContactTicketSetMessagesCompletionBlock)completion {
    
    self.messageLabel.text = @"";
    [self layoutIfNeeded];
    self.messageLabel.text = message.text;
    self.timeLabel.text = [message.creationDateConverted formattedDateWithFormat:@"HH:mm" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    [self layoutIfNeeded];
    
    if (message.attachments.count > 0) {
        WBRContactTicketAttachmentModel *attachment = message.attachments.firstObject;
        
        WBRContactTicketMessageAttachmentFileView *attachmentFileView = [[WBRContactTicketMessageAttachmentFileView alloc] init];
        
        [self.attachmentContainer setHidden:NO];
        [self.attachmentContainer addSubview:attachmentFileView];
        
        [attachmentFileView setAttachmentCellName:attachment.fileName
                                         withSize:attachment.fileSize ? attachment.fileSize.stringValue : @""
                                            andId:attachment.identifier
                                     andCommentId:message.messageId
                                      andTicketId:ticketId];
        
        [attachmentFileView setDelegate:self];
        [self.messageLabel setText:@""];
        
    } else {
        [self.attachmentContainer setHidden:YES];
    }
    
    //    Borders radius are set after the set message because it's necessary to have the final bounds of self.coloredView to use bezierPathWithRoundedRect:
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.coloredView setCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:10];
    }];
}

#pragma mark - WBRContactTicketMessageAttachmentDelegate

- (void)downloadAttachment:(NSString *)attachmentId commentId:(NSString *)commentId ticketId:(NSString *)ticketId {
    
    if ([self.delegate respondsToSelector:@selector(cellDownloadAttachment:commentId:ticketId:)]) {
        [self.delegate cellDownloadAttachment:attachmentId commentId:commentId ticketId:ticketId];
    }
    
}

- (void)openAttachmentWithPath:(NSURL *)path {
    
    if ([self.delegate respondsToSelector:@selector(openAttachmentWithPath:)]) {
        [self.delegate openAttachmentWithPath:path];
    }
    
}

@end
