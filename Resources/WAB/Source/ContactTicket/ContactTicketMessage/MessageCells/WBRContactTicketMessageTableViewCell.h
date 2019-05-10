//
//  WBRMessageTableViewCell.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRContactTicketMessageModel.h"

typedef void(^kContactTicketSetMessagesCompletionBlock)(void);

@protocol WBRContactTicketMessageTableViewCellProtocol

- (void)setMessage:(WBRContactTicketMessageModel *)message ofTicket:(NSString *)ticketId WithCompletion:(kContactTicketSetMessagesCompletionBlock)completion;

@end

@protocol WBRContactTicketMessageTableViewCellDelegate <NSObject>

- (void)cellDownloadAttachment:(NSString *)attachmentId commentId:(NSString *)commentId ticketId:(NSString *)ticketId;

- (void)openAttachmentWithPath:(NSURL *)path;

@end

@interface WBRContactTicketMessageTableViewCell : UITableViewCell <WBRContactTicketMessageTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UIView *coloredView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *attachmentContainer;

@property (weak, nonatomic) id<WBRContactTicketMessageTableViewCellDelegate> delegate;

@end
