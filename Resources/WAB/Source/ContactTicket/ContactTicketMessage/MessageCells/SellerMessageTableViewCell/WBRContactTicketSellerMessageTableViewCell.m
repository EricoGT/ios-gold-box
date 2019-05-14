//
//  WBRSellerTableViewCell.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketSellerMessageTableViewCell.h"
#import "WBRContactTicketMessageAttachmentFileView.h"
#import "UIView+Radius.h"

static NSString *kWBRSellerTableViewCellIdentifier = @"WBRSellerTableViewCellIdentifier";

@interface WBRContactTicketSellerMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;

@end

@implementation WBRContactTicketSellerMessageTableViewCell

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
    self.sellerLabel.text = message.author;
    [self layoutIfNeeded];
    
    //    Borders radius are set after the set message because it's necessary to have the final bounds of self.coloredView to use bezierPathWithRoundedRect:
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.coloredView setCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:10];
    }];
}

+ (NSString *)identifier {
    return kWBRSellerTableViewCellIdentifier;
}

@end
