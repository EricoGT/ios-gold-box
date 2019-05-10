//
//  TrackingTimeline.m
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OrdersDetailViewController.h"
#import "TrackingTimeline.h"
#import "TrackingTimelineItem.h"
#import "InfoInstantStatusTripaParser.h"
#import "InfoInstantStatusTripaView.h"
#import "InvoiceTrackingView.h"
#import "AlertInfoBlock.h"
#import "OFSetup.h"
#import "WMButton.h"
#import "TrackingOrderPayment.h"

@implementation TrackingTimeline

- (void)setupWithItems:(NSArray *)items payment:(TrackingOrderPayment *)payment
{
    CGFloat position = 0;
    BOOL showInvoice = ((self.hasInvoice) && (self.invoiceUrl.length > 0));
    
    //Feature toggle
    if (![OFSetup showNewInvoiceInTracking])
    {
        showInvoice = NO;
    }
    
    for (NSInteger i = 0; i < items.count; i++)
    {
        TrackingTimelineItem *timelineItem = items[i];
        UIImage *stripImage;
        if (i == 0)
        {
            //Primeiro item
            if (items.count > i+1)
            {
                TrackingTimelineItem *nextTimelineItem = items[i+1];
                if (timelineItem.checked)
                {
                    stripImage = (nextTimelineItem.checked) ? [UIImage imageNamed:@"UITimeline01a"] : [UIImage imageNamed:@"UITimeline01"];
                }
                else
                {
                    stripImage = [UIImage imageNamed:@"UITimeline02"];
                }
            }
            else
            {
                stripImage = (timelineItem.checked) ? [UIImage imageNamed:@"UITimeline01a"] : [UIImage imageNamed:@"UITimeline02"];
            }
        }
        else if (i == items.count - 1)
        {
            //Ultimo
            if (timelineItem.tracking.count > 0)
            {
                stripImage = (timelineItem.checked) ? [UIImage imageNamed:@"UITimeline03"] : [UIImage imageNamed:@"UITimeline04"];
            }
            else
            {
                stripImage = (timelineItem.checked) ? [UIImage imageNamed:@"UITimeline05"] : [UIImage imageNamed:@"UITimeline06"];
            }
        }
        else
        {
            //Meio
            
            //We only show invoice in step 1, so if it's not, we should disable invoice check
            if (i != 1) showInvoice = NO;
            
            if (items.count > i+1)
            {
                TrackingTimelineItem *nextTimelineItem = items[i+1];
                if (timelineItem.checked)
                {
                    stripImage = (nextTimelineItem.checked || showInvoice) ? [UIImage imageNamed:@"UITimeline03"] : [UIImage imageNamed:@"UITimeline07"];
                }
                else
                {
                    stripImage = [UIImage imageNamed:@"UITimeline04"];
                }
            }
            else
            {
                stripImage = (timelineItem.checked) ? [UIImage imageNamed:@"UITimeline03"] : [UIImage imageNamed:@"UITimeline04"];
            }
        }
        
        UIImageView *stripImageView = [[UIImageView alloc] initWithImage:stripImage];
        stripImageView.frame = CGRectMake(15, position, 25, 50);
        [self addSubview:stripImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.frame = CGRectMake(stripImageView.frame.origin.x + stripImageView.frame.size.width + 15, stripImageView.center.y - 20, 40, 40);
        iconImageView.image = [UIImage imageNamed:timelineItem.status];
        [self addSubview:iconImageView];
        
        CGFloat labelStart = iconImageView.frame.origin.x + iconImageView.frame.size.width + 15;
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStart, position, self.frame.size.width - 15 - labelStart, 50)];
        statusLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
        statusLabel.numberOfLines = 2;
        statusLabel.text = timelineItem.message;
        statusLabel.textColor = [self textColorForTimelineItem:timelineItem];
        [self addSubview:statusLabel];
        
        position += stripImageView.frame.size.height;
        
        BOOL showBarcodeAlert = NO;
        if ([timelineItem.eventId isEqualToString:@"PC"])
        {
            for (TrackingPaymentMethod *paymentMethod in payment.paymentMethods) {
                if ([[paymentMethod.method uppercaseString] isEqualToString:@"BARCODE"]) {
                    showBarcodeAlert = YES;
                    self.barcodeURL = paymentMethod.paymentUrl;
                }
            }
        }
        
        if ((timelineItem.tracking.count > 0) || (showInvoice) || timelineItem.alert.length > 0 || showBarcodeAlert)
        {
            //NSArray *tripaArray = [InfoInstantStatusTripaParser __mockTripaArray];
            NSArray *tripaArray = [InfoInstantStatusTripaParser parseTimelineItems:timelineItem.tracking];
            CGFloat positionBeforeInvoice = position;
            
            //These two variables are used to store height of invoice and alert when they appear
            CGFloat invoiceHeight = 0;
            CGFloat alertHeight = 0;
            
            //Guys from API told us we can hard code the invoice at this point
            if (i == 1)
            {
                if (showInvoice)
                {
                    InvoiceTrackingView *invoiceView = (InvoiceTrackingView *)[InvoiceTrackingView viewWithXibName:@"InvoiceTrackingView"];
                    CGRect invoiceViewFrame = invoiceView.frame;
                    invoiceViewFrame.origin.x = 0;
                    invoiceViewFrame.origin.y = position;
                    invoiceView.frame = invoiceViewFrame;
                    [invoiceView.seeInvoiceButton addTarget:self action:@selector(showInvoicePDF) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:invoiceView];
                    
                    position += invoiceView.frame.size.height;
                    
                    UIImage *verticalStripImage = (timelineItem.checked) ? [UIImage imageNamed:@"UIStatusMacroTimelineGreen"] : [UIImage imageNamed:@"UIStatusMacroTimeline"];
                    UIImageView *strip = [[UIImageView alloc] initWithImage:verticalStripImage];
                    strip.frame = CGRectMake(25, positionBeforeInvoice, 5, invoiceView.roundedView.frame.origin.y + 6);
                    [self addSubview:strip];
                    [self sendSubviewToBack:strip];
                    
                    positionBeforeInvoice += strip.frame.size.height;
                    invoiceHeight = invoiceView.frame.size.height - strip.frame.size.height;
                }
            }
            
            InfoInstantStatusTripaView *tripaView = [InfoInstantStatusTripaView new];
            [tripaView setStatuses:tripaArray];
            CGFloat tripaViewX = self.frame.size.width - tripaView.frame.size.width;
            CGFloat tripaViewY = position;
            [tripaView setFrame:CGRectMake(tripaViewX, tripaViewY, tripaView.frame.size.width, tripaView.frame.size.height)];
            [self addSubview:tripaView];
            
            position += tripaView.frame.size.height;
            
            if (timelineItem.alert.length > 0 || showBarcodeAlert)
            {
                CGFloat margin = 15;
                position -= (timelineItem.tracking.count > 0) ? 4 : 0;
                
                AlertInfoBlock *infoBlock = (AlertInfoBlock *)[AlertInfoBlock viewWithXibName:@"AlertInfoBlock"];
                TrackingAlertType blockType = TrackingAlertTypeNormal;
                NSString *alertMsg = timelineItem.alert;
                if ([timelineItem.eventId isEqualToString:@"OWSR"])
                {
                    blockType = TrackingAlertTypePayment;
                }
                
                if (showBarcodeAlert)
                {
                    if (self.barcodeURL.length > 0) {
                        blockType = TrackingAlertTypeBoleto;
                        [infoBlock.actionButton addTarget:self action:@selector(showBarcode) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else {
                        blockType = TrackingAlertTypeNormal;
                    }
                    alertMsg = TRACKING_WAITING_PAYMENT_BARCODE;
                }
                
                [infoBlock updateWithMessage:alertMsg alertType:blockType];
                infoBlock.frame = CGRectMake(50, position, infoBlock.frame.size.width, infoBlock.frame.size.height);
                
                [self addSubview:infoBlock];
                position += infoBlock.frame.size.height + margin;
                alertHeight = infoBlock.frame.size.height + margin;
            }
            
            BOOL nextStatusChecked = timelineItem.checked;
            if (items.count > i+1)
            {
                TrackingTimelineItem *nextTimelineItem = items[i+1];
                nextStatusChecked = nextTimelineItem.checked;
            }
            
            UIImage *verticalStripImage = (nextStatusChecked) ? [UIImage imageNamed:@"UIStatusMacroTimelineGreen"] : [UIImage imageNamed:@"UIStatusMacroTimeline"];
            UIImageView *strip = [[UIImageView alloc] initWithImage:verticalStripImage];
            strip.frame = CGRectMake(25, positionBeforeInvoice, 5, tripaView.frame.size.height + invoiceHeight + alertHeight);
            [self addSubview:strip];
            [self sendSubviewToBack:strip];
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = position;
    self.frame = frame;
}

- (UIColor *)textColorForTimelineItem:(TrackingTimelineItem *)item
{
    UIColor *textColor;
    NSString *status = item.status;
    if (([status isEqualToString:@"ic_delivery"]) ||
        ([status isEqualToString:@"ic_finished"]) ||
        ([status isEqualToString:@"ic_payment"]) ||
        ([status isEqualToString:@"ic_delivery_disabled"]))
    {
        textColor = RGBA(204, 204, 204, 1);
    }
    else
    {
        textColor = RGBA(102, 102, 102, 1);
    }
    
    return textColor;
}

#pragma mark - Invoice PDF
- (void)showInvoicePDF
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TimelineAlertActionNotification
                                                        object:nil
                                                      userInfo:@{kAlertURL : self.invoiceUrl ?: @"",
                                                                 kAlertType : kTypeAlertInvoicePDF}];
    [WMOmniture trackOrderInvoice];
}

- (void)sendEmailWithInvoice
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TimelineAlertActionNotification
                                                        object:nil
                                                      userInfo:@{kAlertURL : self.invoiceUrl ?: @"",
                                                                 kAlertType : kTypeEmail}];
}

- (void)showBarcode {
    [[NSNotificationCenter defaultCenter] postNotificationName:TimelineAlertActionNotification
                                                        object:nil
                                                      userInfo:@{kAlertURL : self.barcodeURL ?: @"",
                                                                 kAlertType : kTypeBarcode}];
    [WMOmniture trackOrderBarcode];
}

@end
