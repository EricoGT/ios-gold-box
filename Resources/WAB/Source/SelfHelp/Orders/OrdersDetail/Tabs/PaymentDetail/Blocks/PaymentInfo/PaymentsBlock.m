//
//  PaymentsBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 5/2/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "PaymentsBlock.h"
#import "PaymentInfoBlock.h"
#import "TrackingPaymentMethod.h"

@interface PaymentsBlock ()

@property (nonatomic, weak) IBOutlet UILabel *paymentTitleLabel;

@end

@implementation PaymentsBlock

- (void)setupWithOrderDetail:(TrackingOrderDetail *)detail
{
    CGFloat total = 35.0f;
    NSMutableArray *rateMessageLabels = [NSMutableArray new];
    NSUInteger index = 0;
    
    for (TrackingPaymentMethod *payment in detail.payment.paymentMethods)
    {
        PaymentInfoBlock *block = (PaymentInfoBlock *)[PaymentInfoBlock viewWithXibName:@"PaymentInfoBlock"];
        
        CGRect viewFrame = self.frame;
        viewFrame.size.height += block.frame.size.height + 15;
        self.frame = viewFrame;
        
        CGRect blockFrame = block.frame;
        blockFrame.origin.y = total;
        blockFrame.size.width = viewFrame.size.width;
        block.frame = blockFrame;
        
        [block setupWithPaymentInfo:payment total:detail.payment.orderTotal paymentIndex:index];
        [self addSubview:block];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.decimalSeparator = @".";
        NSNumber *rate = payment.interestRate.length > 0 ? [numberFormatter numberFromString:payment.interestRate] : nil;
        NSNumber *maxCET = payment.maxCET.length > 0 ? [numberFormatter numberFromString:payment.maxCET] : nil;
        
        if (rate && rate.floatValue > 0)
        {
            UILabel *rateInformationLabel = [[UILabel alloc] initWithFrame:CGRectMake(blockFrame.origin.x, 0, blockFrame.size.width, 0)];
            rateInformationLabel.numberOfLines = 0;
            rateInformationLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
            rateInformationLabel.textColor = RGBA(153, 153, 153, 1);
            
            NSString *rateString = (payment.interestRate.length > 0) ? [NSString stringWithFormat:@"%.2f%% a.m.", rate.doubleValue] : @"";
            NSString *maxCETString = (payment.maxCET.length > 0) ? [NSString stringWithFormat:@"%.2f%% a.a.", maxCET.doubleValue] : @"";
            NSMutableString *rateMessage = [NSString stringWithFormat:[[OFMessages new] installmentsRateMessage], rateString, maxCETString].mutableCopy;
            for (NSUInteger i = 0; i < index + 1; i++) [rateMessage insertString:@"*" atIndex:0];
            
            CGSize size = [rateMessage.copy sizeForTextWithFont:rateInformationLabel.font constrainedToSize:CGSizeMake(rateInformationLabel.frame.size.width, CGFLOAT_MAX)];
            rateInformationLabel.frame = CGRectMake(rateInformationLabel.frame.origin.x, 0, size.width, size.height);
            rateInformationLabel.text = rateMessage.copy;
            [rateMessageLabels addObject:rateInformationLabel];
        }
        
        total += block.frame.size.height + 15;
        index ++;
    }
    
    if (rateMessageLabels.count > 0)
    {
        for (UILabel *rateLabel in rateMessageLabels)
        {
            CGRect labelFrame = rateLabel.frame;
            labelFrame.origin.y = total;
            rateLabel.frame = labelFrame;
            
            [self addSubview:rateLabel];
            total += labelFrame.size.height;
            total += 10;
        }
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = total;
    self.frame = viewFrame;
}

@end
