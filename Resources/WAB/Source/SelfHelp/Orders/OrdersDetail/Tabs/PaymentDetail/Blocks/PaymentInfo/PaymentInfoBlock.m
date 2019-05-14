//
//  PaymentInfoBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 29/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "PaymentInfoBlock.h"
#import "NSString+Additions.h"
#import "OFFormatter.h"
#import "NSString+HTML.h"

@interface PaymentInfoBlock ()

@property (nonatomic, weak) IBOutlet UILabel *receiverNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentInfo;
@property (nonatomic, weak) IBOutlet UILabel *paymentDescription;
@property (nonatomic, weak) IBOutlet UILabel *totalPaymentWithRate;
@property (nonatomic, weak) IBOutlet UIImageView *paymentIconImageView;
@property (weak, nonatomic) IBOutlet UIView *footer;

#define BORDER_TOP 15
#define BORDER_BOTTON 15

@end

@implementation PaymentInfoBlock

- (void)setupWithPaymentInfo:(TrackingPaymentMethod *)paymentMethod total:(TrackingOrderTotal *)total paymentIndex:(NSUInteger)index
{
    [self setLayout];
    
    self.paymentIconImageView.image = [paymentMethod imageForCurrentPayment];
    
    CGRect iconImageFrame = self.paymentIconImageView.frame;
    iconImageFrame.origin.x = (self.frame.size.width/2) - (iconImageFrame.size.width/2);
    self.paymentIconImageView.frame = iconImageFrame;
    
    OFFormatter *formatter = [OFFormatter sharedInstance];
    if ([paymentMethod.method isEqualToString:paymentTypeBarcode])
    {
        self.receiverNameLabel.text = @"Boleto bancário";
        self.paymentInfo.text = [NSString stringWithFormat:@"Valor: %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
        self.paymentDescription.text = @"";
        self.totalPaymentWithRate.text = @"";
    }
    else if (([paymentMethod.method isEqualToString:paymentTypeCredit]) || ([paymentMethod.method isEqualToString:paymentTypeCreditCard]))
    {
        if (([paymentMethod.brand isEqualToString:paymentTypeCreditHipercard]) || ([paymentMethod.brand isEqualToString:paymentTypeCreditHiper]))
        {
            CGRect paymentIconFrame = self.paymentIconImageView.frame;
            paymentIconFrame.origin.x = self.bounds.size.width / 2.0f - 92.0f / 2.0f;
            paymentIconFrame.size.width = 92;
            paymentIconFrame.size.height = 29;
            self.paymentIconImageView.frame = paymentIconFrame;
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.decimalSeparator = @".";
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSNumber *rate = paymentMethod.interestRate.length > 0 ? [numberFormatter numberFromString:paymentMethod.interestRate] : nil;
        
        if (rate && rate.floatValue > 0)
        {
            self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
            self.paymentInfo.text = [NSString stringWithFormat:@"**** **** **** %@", paymentMethod.lastDigitsOfCard];
            NSString *parcels = paymentMethod.parcelAmount ? paymentMethod.parcelAmount.stringValue : @"";
            NSString *amount = [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue];
            
            self.paymentDescription.text = [NSString stringWithFormat:@"%@x de %@ com juros (%.2f%% a.m.)", parcels, amount, rate.floatValue];
    
            NSNumber *valueWithRate = paymentMethod.valueWithInterest.length > 0 ? [numberFormatter numberFromString:paymentMethod.valueWithInterest] : nil;
            NSMutableString *totalValue = valueWithRate ? [NSString stringWithFormat:@"Valor total: %@", [formatter.currencyFormatter stringFromNumber:valueWithRate]].mutableCopy : @"".mutableCopy;
            if (totalValue.length > 0) {
                for (NSUInteger i = 0; i < index + 1; i++) [totalValue appendString:@"*"];
            }
            self.totalPaymentWithRate.text = totalValue.copy;
        }
        else
        {
            self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
            self.paymentInfo.text = [NSString stringWithFormat:@"**** **** **** %@", paymentMethod.lastDigitsOfCard];
            self.paymentDescription.text = [NSString stringWithFormat:@"%ldx de %@", (long)paymentMethod.parcelAmount.integerValue, [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
            self.totalPaymentWithRate.text = @"";
        }
    }
    else if ([paymentMethod.method isEqualToString:paymentTypeDebit])
    {
        
        if (paymentMethod.brand.length > 0 && paymentMethod.completeName.length > 0 && paymentMethod.parcelValue > 0 && paymentMethod.lastDigitsOfCard.length > 0) {
            NSString *strBrand = paymentMethod.brand.uppercaseString;
            self.receiverNameLabel.text = [NSString stringWithFormat:@"Cartão de débito %@", strBrand];
            self.paymentInfo.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
            self.paymentDescription.text = [NSString stringWithFormat:@"**** **** **** %@", paymentMethod.lastDigitsOfCard];
            self.totalPaymentWithRate.text = [NSString stringWithFormat:@"%@ à vista", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
        }
        else{
            
            if ((paymentMethod.completeName) && (![paymentMethod.completeName isEqualToString:@""]))
            {
                self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
                
                self.paymentInfo.text = @"Débito em conta";
                self.paymentDescription.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
                self.totalPaymentWithRate.text = @"";
            }
            else
            {
                self.receiverNameLabel.text = @"Débito em conta";
                self.paymentInfo.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
                self.paymentDescription.text = @"";
                self.totalPaymentWithRate.text = @"";
            }
        }
        
        
// **** original
        
//        if ((paymentMethod.completeName) && (![paymentMethod.completeName isEqualToString:@""]))
//        {
//            self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
//            
//            self.paymentInfo.text = @"Débito em conta";
//            self.paymentDescription.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
//            self.totalPaymentWithRate.text = @"";
//        }
//        else
//        {
//            self.receiverNameLabel.text = @"Débito em conta";
//            self.paymentInfo.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
//            self.paymentDescription.text = @"";
//            self.totalPaymentWithRate.text = @"";
//        }
        
    }
    else if ([paymentMethod.method isEqualToString:paymentTypeGiftVoucher])
    {
        self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
        self.paymentInfo.text = @"Vale Presente";
        self.paymentDescription.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
        self.totalPaymentWithRate.text = @"";
    }
    else if ([paymentMethod.method isEqualToString:paymentTypeOnlineCredit])
    {
        self.receiverNameLabel.text = @"Crédito online";
        self.paymentInfo.text = [NSString stringWithFormat:@"Valor: %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
        self.paymentDescription.text = @"";
        self.totalPaymentWithRate.text = @"";
    }
    else
    {
        self.receiverNameLabel.text = paymentMethod.completeName.kv_decodeHTMLCharacterEntities;
        self.paymentInfo.text = @"Pagamento";
        self.paymentDescription.text = [NSString stringWithFormat:@"1x de %@", [formatter.currencyFormatter stringFromNumber:paymentMethod.parcelValue]];
        self.totalPaymentWithRate.text = @"";
    }
    
    CGFloat lastPosition = self.paymentIconImageView.frame.origin.y + self.paymentIconImageView.frame.size.height;
    if (self.receiverNameLabel.text.length > 0) {
        CGRect frame = self.receiverNameLabel.frame;
        CGSize size = [self.receiverNameLabel.text sizeForTextWithFont:self.receiverNameLabel.font constrainedToSize:CGSizeMake(self.receiverNameLabel.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.receiverNameLabel.frame = frame;
        lastPosition = self.receiverNameLabel.frame.origin.y + self.receiverNameLabel.frame.size.height;
    }
    if (self.paymentInfo.text.length > 0) {
        CGRect frame = self.paymentInfo.frame;
        CGSize size = [self.paymentInfo.text sizeForTextWithFont:self.paymentInfo.font constrainedToSize:CGSizeMake(self.paymentInfo.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.paymentInfo.frame = frame;
        lastPosition = self.paymentInfo.frame.origin.y + self.paymentInfo.frame.size.height;
    }
    if (self.paymentDescription.text.length > 0) {
        CGRect frame = self.paymentDescription.frame;
        CGSize size = [self.paymentDescription.text sizeForTextWithFont:self.paymentDescription.font constrainedToSize:CGSizeMake(self.paymentDescription.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.paymentDescription.frame = frame;
        lastPosition = self.paymentDescription.frame.origin.y + self.paymentDescription.frame.size.height;
    }
    if (self.totalPaymentWithRate.text.length > 0) {
        CGRect frame = self.totalPaymentWithRate.frame;
        CGSize size = [self.totalPaymentWithRate.text sizeForTextWithFont:self.totalPaymentWithRate.font constrainedToSize:CGSizeMake(self.totalPaymentWithRate.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.totalPaymentWithRate.frame = frame;
        lastPosition = self.totalPaymentWithRate.frame.origin.y + self.totalPaymentWithRate.frame.size.height;
    }
    
    CGRect frame = self.frame;
    frame.size.height = lastPosition + 20.0f + self.footer.frame.size.height;
    self.frame = frame;
}

- (void)setLayout
{
    self.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.layer.borderWidth = 1.0f;
    self.clipsToBounds = YES;
}

@end
