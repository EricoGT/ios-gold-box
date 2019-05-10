//
//  OrderResumeBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "OrderResumeBlock.h"
#import "NSDate+DateTools.h"
#import "OFFormatter.h"

@interface OrderResumeBlock ()

@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet UILabel *orderDate;
@property (nonatomic, strong) IBOutlet UILabel *totalValue;


@end

@implementation OrderResumeBlock

- (void)setupWithOrderDetail:(TrackingOrderDetail *)detail
{
    [self setLayout];
    
    self.orderNumber.text = detail.orderID;
    self.orderDate.text = [detail.creationDate formattedDateWithFormat:@"dd/MM/YYYY"];
    
    if (detail.payment.orderTotal.currencyAmount)
    {
        self.totalValue.hidden = NO;
        NSNumber *total = detail.payment.orderTotal.currencyAmount;
        self.totalValue.text = [NSString stringWithFormat:@"%@", [[OFFormatter sharedInstance].currencyFormatter stringFromNumber:total]];
    }
    else
    {
        self.totalValue.hidden = YES;
    }
}

- (void)setLayout
{
    self.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 0;
}

@end
