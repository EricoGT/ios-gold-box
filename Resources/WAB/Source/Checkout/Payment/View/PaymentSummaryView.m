//
//  PaymentSummaryView.m
//  Walmart
//
//  Created by Renan Cargnin on 04/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "PaymentSummaryView.h"

#import "PaymentSummaryValueView.h"
#import "CouponView.h"

#import "NSNumber+Currency.h"

@interface PaymentSummaryView ()

@property (weak, nonatomic) IBOutlet UIView *valuesContainerView;

@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentsLabel;

@end

@implementation PaymentSummaryView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPaymentSummaryview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPaymentSummaryview];
    }
    return self;
}

- (void)setupPaymentSummaryview {
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = RGB(201, 201, 201).CGColor;
}

- (void)setSummary:(NSDictionary *)summary {
    NSDictionary *dictResumeCard = [summary valueForKey:@"installment"];
    NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
    
    NSString *ttProductsOrder = [dictCartTotals objectForKey:@"productsAmount"] ?: @"0";
    NSString *ttServicesOrder = [dictCartTotals objectForKey:@"servicesAmount"] ?: @"0";
    NSString *ttShipmentsOrder = [dictCartTotals objectForKey:@"deliveriesAmount"] ?: @"";
    NSString *ttDiscountsOrder = [dictCartTotals objectForKey:@"totalNominalDiscount"] ?: @"0";
    NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    
    NSString *ttShipments = @"Grátis";
    if ([[NSString stringWithFormat:@"%@", ttShipmentsOrder] floatValue] > 0)
    {
        ttShipments = @(ttShipmentsOrder.floatValue/100).currencyFormat;
    }
    if ([[NSString stringWithFormat:@"%@", ttShipmentsOrder] isEqualToString:@""])
    {
        ttShipments = @"R$";
    }
    
    //Installments
    NSDictionary *dictJsonInstallments = [summary valueForKey:@"cart"];
    NSDictionary *dictInstallments = [dictJsonInstallments objectForKey:@"bestInstallment"];
    
    //Coupon
    NSDictionary *cart = [summary valueForKey:@"cart"];
    NSArray *giftCards = cart[@"giftCards"];
    NSDictionary *coupon = giftCards.count > 0 ? giftCards[0] : nil;
    
    NSMutableArray *arrOrderResume = [NSMutableArray new];
    if (ttProductsOrder.floatValue > 0) {
        NSDictionary *dictOrderLine = @{@"description" : @"Subtotal:", @"valueDescription" : @(ttProductsOrder.floatValue / 100.0f)};
        [arrOrderResume addObject:dictOrderLine];
    }
    if (ttDiscountsOrder.floatValue > 0) {
        NSDictionary *dictOrderLine = @{@"description" : @"Descontos:", @"valueDescription" : @(ttDiscountsOrder.floatValue / 100.0f)};
        [arrOrderResume addObject:dictOrderLine];
    }
    
    NSDictionary *dictOrderLine = @{@"description" : @"Valor do frete:",@"valueDescription" : @(ttShipmentsOrder.floatValue / 100.0f)};
    [arrOrderResume addObject:dictOrderLine];
    
    if (ttServicesOrder.floatValue > 0) {
        NSDictionary *dictOrderLine = @{@"description" : @"Seguro Garantia Estendida Original:", @"valueDescription": @(ttServicesOrder.floatValue / 100.0f)};
        [arrOrderResume addObject:dictOrderLine];
    }
    
    NSMutableArray *valuesViews = [NSMutableArray new];
    for (NSDictionary *valueDict in arrOrderResume) {
        PaymentSummaryValueView *valueView = [PaymentSummaryValueView new];
        valueView.translatesAutoresizingMaskIntoConstraints = NO;
        valueView.valueDescription = valueDict[@"description"];
        valueView.value = valueDict[@"valueDescription"];
        [valuesViews addObject:valueView];
    }
    
    if (coupon) {
        CouponView *couponView = [CouponView new];
        couponView.translatesAutoresizingMaskIntoConstraints = NO;
        couponView.redemptionCode = coupon[@"redemptionCode"];
        couponView.removeBlock = ^(NSString *redemptionCode) {
            if ([self->_delegate respondsToSelector:@selector(paymentSummaryViewPressedRemoveCouponWithRedemptionCode:)]) {
                [self->_delegate paymentSummaryViewPressedRemoveCouponWithRedemptionCode:redemptionCode];
            }
        };
        [valuesViews addObject:couponView];
    }
    
    [_valuesContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIView *valueView in valuesViews) {
        UIView *topView = _valuesContainerView.subviews.count == 0 ? _valuesContainerView : _valuesContainerView.subviews.lastObject;
        
        [_valuesContainerView addSubview:valueView];
        
        [_valuesContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[valueView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"valueView": valueView}]];
        
        [_valuesContainerView addConstraint:[NSLayoutConstraint constraintWithItem:valueView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:topView
                                                                         attribute:topView == _valuesContainerView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                        multiplier:1.0f
                                                                          constant:0.0f]];
        
        if (valueView != valuesViews.lastObject) {
            UIView *filletView = [UIView new];
            filletView.backgroundColor = RGB(204, 204, 204);
            filletView.translatesAutoresizingMaskIntoConstraints = NO;
            [_valuesContainerView addSubview:filletView];
            
            NSDictionary *views = @{@"filletView": filletView,
                                    @"valueView": valueView};
            [_valuesContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[filletView]-10-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
            [_valuesContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[valueView]-0-[filletView(==1)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
    }
    
    [_valuesContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_valuesContainerView.subviews.lastObject
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_valuesContainerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
    
    [_valuesContainerView setNeedsLayout];
    [_valuesContainerView layoutIfNeeded];
    
    [self setTotalValue:@(ttGlobalOrder.floatValue / 100.0f)];
    [self setInstallmentsCount:[dictInstallments[@"installmentAmount"] unsignedIntegerValue] installmentsValue:dictInstallments[@"valuePerInstallment"]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _summary = summary;
}

- (void)setTotalValue:(NSNumber *)totalValue {
    _totalValueLabel.text = [NSString stringWithFormat:@"Valor total: %@", [totalValue currencyFormat]];
    _totalValue = totalValue;
}

- (void)setInstallmentsCount:(NSUInteger)installmentsCount installmentsValue:(NSNumber *)installmentsValue {
    _installmentsLabel.text = [NSString stringWithFormat:@"Em até %ldx de %@", (unsigned long) installmentsCount, [installmentsValue currencyFormat]];
}

@end
