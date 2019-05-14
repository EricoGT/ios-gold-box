//
//  WBRContactTicketMessageAttachmentFileView.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 9/25/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBRContactTicketMessageAttachmentDelegate <NSObject>

- (void)downloadAttachment:(NSString *)attachmentId commentId:(NSString *)commentId ticketId:(NSString *)ticketId;

- (void)openAttachmentWithPath:(NSURL *)path;

@end

@interface WBRContactTicketMessageAttachmentFileView : WMView

@property (weak, nonatomic) id<WBRContactTicketMessageAttachmentDelegate> delegate;

- (void)setAttachmentCellName:(NSString *)name withSize:(NSString *)size andId:(NSString *)identifier andCommentId:(NSString *)commentId andTicketId:(NSString *)ticketId;

@end

NS_ASSUME_NONNULL_END
