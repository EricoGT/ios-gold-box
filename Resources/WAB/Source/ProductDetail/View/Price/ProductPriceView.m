//
//  ProductPriceView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductPriceView.h"

#import "SellerOptionModel.h"
#import "NSNumber+Currency.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProductPriceView ()

@property (weak, nonatomic) IBOutlet UILabel *lblPriceDe;
@property (weak, nonatomic) IBOutlet UILabel *lblPricePor;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceInstallments;

@end

@implementation ProductPriceView

- (ProductPriceView *)initWithSellerOption:(SellerOptionModel *)sellerOption {
    if (self = [super init]) {
        [self setupWithSellerOption:sellerOption];
    }
    return self;
}

- (void)layoutSubviews {
    _lblPriceDe.preferredMaxLayoutWidth = _lblPriceDe.bounds.size.width;
    _lblPricePor.preferredMaxLayoutWidth = _lblPricePor.bounds.size.width;
    _lblPriceInstallments.preferredMaxLayoutWidth = _lblPriceInstallments.bounds.size.width;
    
    [super layoutSubviews];
}

- (void)setupWithSellerOption:(SellerOptionModel *)sellerOption {
    
    NSString *currency = @"R$ ";
    NSNumber *originalPrice = sellerOption.originalPrice;
    NSNumber *discountPrice = sellerOption.discountPrice;
    NSUInteger installmentsCount = sellerOption.instalment.integerValue;
    NSNumber *installmentValue = sellerOption.instalmentValue;
    
    if (originalPrice.floatValue > discountPrice.floatValue) {
        NSString *strValueOfStrike = originalPrice.integerValue > 0 ? [NSString stringWithFormat:@"%@", [originalPrice currencyFormatWithCurrencySymbol:currency]] : @"";
        
        NSMutableAttributedString *attributedValueOf = [[NSMutableAttributedString alloc] initWithString:strValueOfStrike];
        
        [attributedValueOf addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(0, strValueOfStrike.length)];

        _lblPriceDe.attributedText = attributedValueOf;
        
    }
    else {
        _lblPriceDe.text = @"";
    }
    
    UIFont *symbolFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
    UIFont *currencyFont = [UIFont fontWithName:@"Roboto-Regular" size:37];
    UIFont *centsFont = [UIFont fontWithName:@"Roboto-Regular" size:25];
    
    NSString *strValueComplete = [NSString stringWithFormat:@"%@", [discountPrice currencyFormatWithCurrencySymbol:currency]];
    
    NSMutableAttributedString *attributedTotal = [[NSMutableAttributedString alloc] initWithString:strValueComplete];
    [attributedTotal addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 1) range:NSMakeRange(0, strValueComplete.length)];
    
    [attributedTotal addAttribute:NSFontAttributeName value:currencyFont range:NSMakeRange(0, strValueComplete.length)];
    [attributedTotal addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, currency.length)];
    [attributedTotal addAttribute:NSFontAttributeName value:centsFont range:NSMakeRange(strValueComplete.length - 2, 2)];
    
    _lblPricePor.attributedText = attributedTotal.copy;
    
    //If not global, hide installments
    if (installmentsCount > 0)
    {
        
        UIColor *installmentDefaultColor = RGB(153, 153, 153);
        NSString *fontName = @"Roboto-Regular";
        int fontSize = 13;
        
        NSAttributedString *installmentValueAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldx de ", (unsigned long) installmentsCount] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSAttributedString *intallmentPrice = [[NSAttributedString alloc] initWithString:[installmentValue currencyFormatWithCurrencySymbol:currency] attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size: fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : RGB(102,102,102)}];
        
        NSAttributedString *interestFree = [[NSAttributedString alloc] initWithString:@" sem juros" attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize], NSUnderlineStyleAttributeName : @0 , NSForegroundColorAttributeName : installmentDefaultColor}];
        
        NSMutableAttributedString *installmentMutableAttString = [[NSMutableAttributedString alloc] init];
        
        [installmentMutableAttString appendAttributedString:installmentValueAttr];
        [installmentMutableAttString appendAttributedString:intallmentPrice];
        [installmentMutableAttString appendAttributedString:interestFree];
        
        self.lblPriceInstallments.attributedText = installmentMutableAttString;
        self.lblPriceInstallments.hidden = NO;
    }
    else
    {
        _lblPriceInstallments.text = @"";
        _lblPriceInstallments.hidden = YES;
    }
}

#pragma mark - Facebook Analytics

- (void)logViewedContentEvent:(NSString*)contentType
                    contentId:(NSString*)contentId
                     currency:(NSString*)currency
                    valToSum :(double)price {
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentType, FBSDKAppEventParameterNameContentType,
     contentId, FBSDKAppEventParameterNameContentID,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    [FBSDKAppEvents logEvent: FBSDKAppEventNameViewedContent
                  valueToSum: price
                  parameters: params];
}


@end
