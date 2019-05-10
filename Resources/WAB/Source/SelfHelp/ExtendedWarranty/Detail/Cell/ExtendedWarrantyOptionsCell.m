//
//  ExtendedWarrantyOptionsCell.m
//  Walmart
//
//  Created by Bruno on 6/1/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyOptionsCell.h"
#import "OFMessages.h"

@interface ExtendedWarrantyOptionsCell ()

@end

@implementation ExtendedWarrantyOptionsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setupWithOptionType:(OptionType)theType
{
    self.type = theType;
    switch (self.type)
    {
        case OptionTypeTicket:
            self.optionImageView.image = [UIImage imageNamed:@"ico_pdf.png"];
            self.optionNameLabel.text = EXTENDED_WARRANTY_DETAIL_OPTION_SEE_TICKET;
            break;
        case OptionTypeAuthorizationTerm:
            self.optionImageView.image = [UIImage imageNamed:@"ico_pdf.png"];
            self.optionNameLabel.text = EXTENDED_WARRANTY_DETAIL_OPTION_AUTORIZATION;
            break;
        case OptionTypeCancel:
            self.optionImageView.image = [UIImage imageNamed:@"ico_cancel.png"];
            self.optionNameLabel.text = EXTENDED_WARRANTY_DETAIL_OPTION_CANCEL;
            break;
        case OptionTypeCancelled:
            self.optionImageView.image = [UIImage imageNamed:@"ico_pdf.png"];
            self.optionNameLabel.text = EXTENDED_WARRANTY_DETAIL_OPTION_CANCELLED;
            break;
            
        default:
            self.optionImageView.image = nil;
            self.optionNameLabel.text = @"";
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setupForState:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setupForState:selected];
}

- (void)setupForState:(BOOL)active
{
    UIColor *customBlue = RGBA(26, 117, 207, 1);
    UIColor *customOrange = RGBA(244, 123, 32, 1);
    self.optionNameLabel.textColor = (active) ? customOrange : customBlue;
    if (self.type == OptionTypeCancel)
    {
        self.optionImageView.image = (active) ? [UIImage imageNamed:@"ic_cancel_blue_over.png"] : [UIImage imageNamed:@"ico_cancel.png"];
    }
    else
    {
        self.optionImageView.image = (active) ? [UIImage imageNamed:@"ic_pdf_blue_over.png"] : [UIImage imageNamed:@"ico_pdf.png"];
    }
}

@end
