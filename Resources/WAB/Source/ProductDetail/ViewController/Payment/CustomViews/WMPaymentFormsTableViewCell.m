//
//  WMPaymentFormsTableViewCell.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/13/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMPaymentFormsTableViewCell.h"
#import "PaymentItem.h"
#import "Installment.h"
#import "OFFormatter.h"

@interface WMPaymentFormsTableViewCell ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end

@implementation WMPaymentFormsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.formatter = [[OFFormatter sharedInstance] currencyFormatter];
}

- (NSAttributedString *)setQuantityInstallmentsColorAttribute:(UIColor *)installmentsColorAttribute installmentValueColorAttribute:(UIColor *)installmentValueColorAttribute rateTextColorAttribute:(UIColor *)rateTextColorAttribute withInstallment:(Installment *)installment {
    
    NSString *installments = [installment getInstallments];
    NSString *installmentValue = [installment getInstallmentValue];
    NSString *rateText = [installment getRateText];
    
    NSString *completeString = [NSString stringWithFormat:@"%@%@\n%@", installments, installmentValue, rateText];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:completeString];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:installmentsColorAttribute range:NSMakeRange(0, installments.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:installmentValueColorAttribute range:NSMakeRange(installments.length, installmentValue.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:rateTextColorAttribute range:NSMakeRange(installments.length + installmentValue.length, rateText.length + 1)];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:11.0] range:NSMakeRange(installments.length + installmentValue.length, rateText.length + 1)];
    
    return attributedString;
}


- (void)setSelectedWithInstallment:(Installment *)installment {
    self.quantityLabel.attributedText = [self setQuantityInstallmentsColorAttribute:[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] installmentValueColorAttribute:[UIColor colorWithRed:76.0f / 255.0f green:175.0f / 255.0f blue:80.0f / 255.0f alpha:1.0f] rateTextColorAttribute:[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] withInstallment:installment];
    
}

- (void)setDeselectedWithInstallment:(Installment *)installment {
    self.quantityLabel.attributedText = [self setQuantityInstallmentsColorAttribute:[UIColor colorWithWhite:153.0f / 255.0f alpha:1.0f] installmentValueColorAttribute:[UIColor colorWithRed:76.0f / 255.0f green:175.0f / 255.0f blue:80.0f / 255.0f alpha:1.0f] rateTextColorAttribute:[UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f] withInstallment:installment];
}

- (void)setupWithInstallment:(Installment *)installment
{
    //Used in payment forms
    NSString *quantity = @"";
    NSString *price = @"";
    
    if ([OFSetup enableInstallmentsWithRateInPaymentForms]) {
        quantity = installment.formattedMessageWithRate;
        price = (installment.price) ? [self.formatter stringFromNumber:installment.price] : @"";
    } else {
        quantity = (installment.instalment) ? [NSString stringWithFormat:@"%@x sem juros", [installment.instalment stringValue]] : @"";
        price = (installment.instalmentValue) ? [self.formatter stringFromNumber:installment.instalmentValue] : @"";
    }
    
    self.quantityLabel.text = quantity;
    self.priceLabel.text = price;
}

- (void)setupInCheckoutWithInstallment:(Installment *)installment
{
    //Used in checkout
    NSString *price = (installment.priceWithRate) ? [self.formatter stringFromNumber:installment.priceWithRate] : @"";
    
    [self setDeselectedWithInstallment:installment];
    self.priceLabel.text = price;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
