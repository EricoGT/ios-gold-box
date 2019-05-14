//
//  WBRFloatingBuyView.m
//  Walmart
//
//  Created by Accurate Rio Preto on 19/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRFloatingBuyView.h"
#import "NSNumber+Currency.h"

@interface WBRFloatingBuyView()
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerPrice;
@property (weak, nonatomic) IBOutlet UILabel *installmentsLabel;

@property (nonatomic, assign) NSNumber *price;
@property (nonatomic, assign) NSNumber *installmentValue;
@property (nonatomic, assign) NSNumber *installmentCounts;

@property (nonatomic, assign) WBRPaymentSuggestion *paymentSuggestion;

@end

@implementation WBRFloatingBuyView

-(void)setupWithSellerOption:(SellerOptionModel *)sellerOption
{
    self.sellerOption = sellerOption;
    self.sellerLabel.text = sellerOption.name;
    self.price = sellerOption.discountPrice;
    self.installmentValue = sellerOption.instalmentValue;
    self.installmentCounts = sellerOption.instalment;
    self.paymentSuggestion = sellerOption.paymentSuggestion;
    
    [self setupPriceLabel];
    [self setupInstallmentsLabel];
}

-(void) setupPriceLabel
{
    NSMutableAttributedString *attributedTotal;
    UIColor *midGreen = RGBA(76, 175, 80, 1);
    
    if (self.paymentSuggestion && [self.paymentSuggestion isBankSlip] && self.paymentSuggestion.discountedPrice && [OFSetup enableBankSlipDiscount]) {
        
        UIFont *symbolFont = [UIFont fontWithName:@"Roboto-Medium" size:11];
        UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Medium" size:15];
        UIFont *bankslipTextFont = [UIFont fontWithName:@"Roboto-Medium" size:11];
        NSString *currency = @"R$ ";
        NSString *bankslipText = self.paymentSuggestion.paymentMethodString;
        
        NSString *strValueComplete = [NSString stringWithFormat:@"%@%@", [self.paymentSuggestion.discountedPrice currencyFormatWithCurrencySymbol:currency], bankslipText];
        
        attributedTotal = [[NSMutableAttributedString alloc] initWithString:strValueComplete];
        [attributedTotal addAttribute:NSForegroundColorAttributeName value:midGreen range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, currency.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:bankslipTextFont range:NSMakeRange(strValueComplete.length - bankslipText.length, bankslipText.length)];
        
    } else {
    
        NSNumber *price = self.price;
        NSString *currency = @"R$ ";
        
        UIFont *currencySymbolFont = [UIFont fontWithName:@"Roboto-Medium" size:11];
        UIFont *priceFont = [UIFont fontWithName:@"Roboto-Medium" size:15];
        NSString *strValueComplete = [NSString stringWithFormat:@"%@", [price currencyFormatWithCurrencySymbol:currency]];
        
        attributedTotal = [[NSMutableAttributedString alloc] initWithString:strValueComplete];
        [attributedTotal addAttribute:NSForegroundColorAttributeName value:midGreen range:NSMakeRange(0, strValueComplete.length)];
        
        [attributedTotal addAttribute:NSFontAttributeName value:priceFont range:NSMakeRange(0, strValueComplete.length)];
        [attributedTotal addAttribute:NSFontAttributeName value:currencySymbolFont range:NSMakeRange(0, currency.length)];
    
    }
    
    self.sellerPrice.attributedText = attributedTotal.copy;
}


-(void) setupInstallmentsLabel
{
    NSNumber *installmentsCount = self.installmentCounts;
    NSNumber *installmentValue = self.installmentValue;
    NSString *currency = @"R$ ";
    
    if (installmentsCount > 0)
    {

        UIColor *numberColor = RGB(102,102,102);
        UIColor *textColor = RGB(153,153,153);
        NSString *fontName = @"Roboto-Regular";
        int fontSize = 11;
        
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        if (self.paymentSuggestion && self.paymentSuggestion.discountedPrice && [self.paymentSuggestion isBankSlip] && [OFSetup enableBankSlipDiscount]) {
            
            
            
            NSString *fullPriceAndInstallmentString = [NSString stringWithFormat:@"ou %@ em %@x sem juros",  [self.price currencyFormatWithCurrencySymbol:currency], installmentsCount];
            installmentMutableAttString = [[NSMutableAttributedString alloc] initWithString:fullPriceAndInstallmentString
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
                                                                                              NSUnderlineStyleAttributeName : @0 ,
                                                                                              NSForegroundColorAttributeName : numberColor
                                                                                              }];
            NSRange orRange = [fullPriceAndInstallmentString rangeOfString:@"ou"];
            NSRange inRange = [fullPriceAndInstallmentString rangeOfString:@"em"];
            NSRange interestRange = [fullPriceAndInstallmentString rangeOfString:@"sem juros"];
            
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:orRange];
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:inRange];
            [installmentMutableAttString addAttribute:NSForegroundColorAttributeName value:textColor range:interestRange];
            
        } else {
        
            NSAttributedString *installmentValueAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x de ", installmentsCount] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : textColor}];
        
            NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:[installmentValue currencyFormatWithCurrencySymbol:currency] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : numberColor}];
            
            NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@" sem juros" attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : textColor}];
        
            [installmentMutableAttString appendAttributedString:installmentValueAttr];
            [installmentMutableAttString appendAttributedString:intallmentPrice];
            [installmentMutableAttString appendAttributedString:interestFree];
        
        }
        
        self.installmentsLabel.attributedText = installmentMutableAttString.copy;
    }else
    {
        self.installmentsLabel.text = @"";
        self.installmentsLabel.hidden = YES;
    }
}

-(IBAction)tapBuyButton
{
    if([self.delegate respondsToSelector:@selector(floatingProductBuyPressedBuyButton:)]){
        [self.delegate floatingProductBuyPressedBuyButton:self.sellerOption.sellerId];
    }
}
@end
