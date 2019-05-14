//
//  InvoiceTrackingView.m
//  Walmart
//
//  Created by Bruno Delgado on 4/27/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "InvoiceTrackingView.h"
#import "WMButton.h"
#import "OFMessages.h"

@interface InvoiceTrackingView ()

@property (nonatomic, weak) IBOutlet UILabel *invoiceTitle;
@end

@implementation InvoiceTrackingView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    OFMessages *messagesInstance = [OFMessages new];
    [self.seeInvoiceButton setTitle:messagesInstance.seeInvoice forState:UIControlStateNormal];
    
    //[self.seeInvoiceButton setup];
    self.roundedView.layer.cornerRadius = self.roundedView.frame.size.width/2;
}

@end
