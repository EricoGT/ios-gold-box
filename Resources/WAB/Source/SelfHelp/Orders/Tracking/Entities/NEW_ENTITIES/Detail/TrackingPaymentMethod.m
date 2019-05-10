//
//  TrackingPaymentMethod.m
//  Walmart
//
//  Created by Bruno Delgado on 10/9/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingPaymentMethod.h"

@implementation TrackingPaymentMethod

- (UIImage *)imageForCurrentPayment
{
    UIImage *image = nil;
    if ([self.method isEqualToString:paymentTypeBarcode])
    {
        //Barcode
        image = [UIImage imageNamed:@"UIPaymentBoleto"];
    }
    else if ([self.method isEqualToString:paymentTypeCredit] || [self.method isEqualToString:paymentTypeCreditCard])
    {
        //Credit Cards
        if ([self.brand isEqualToString:paymentTypeCreditVisa])
        {
            image = [UIImage imageNamed:@"UIPaymentVisa"];
        }
        else if ([self.brand isEqualToString:paymentTypeCreditMastercard])
        {
            image = [UIImage imageNamed:@"UIPaymentMastercard"];
        }
        else if (([self.brand isEqualToString:paymentTypeCreditHipercard]) || ([self.brand isEqualToString:paymentTypeCreditHiper]))
        {
            image = [UIImage imageNamed:@"UIProductDetailCardHiper"];
        }
        else if ([self.brand isEqualToString:paymentTypeCreditDiners])
        {
            image = [UIImage imageNamed:@"UIPaymentDiners"];
        }
        else if ([self.brand isEqualToString:paymentTypeCreditAmex])
        {
            image = [UIImage imageNamed:@"UIPaymentAmex"];
        }
        else if ([self.brand isEqualToString:paymentTypeCreditElo])
        {
            image = [UIImage imageNamed:@"UIPaymentElo"];
        }
        else
        {
            image = [UIImage imageNamed:@"UIPaymentGeneric"];
        }
    }
    else if ([self.method isEqualToString:paymentTypeDebit])
    {
        //Debit
        if ([self.brand isEqualToString:paymentTypeCreditVisa])
        {
            image = [UIImage imageNamed:@"UIPaymentVisa"];
        }
        else if ([self.brand isEqualToString:paymentTypeCreditMastercard])
        {
            image = [UIImage imageNamed:@"UIPaymentMastercard"];
        }
        else if ([self.brand isEqualToString:paymentTypeDebitItau])
        {
            image = [UIImage imageNamed:@"UIPaymentItau"];
        }
        else if ([self.brand isEqualToString:paymentTypeDebitBradesco])
        {
            image = [UIImage imageNamed:@"UIPaymentBradesco"];
        }
        else
        {
            image = [UIImage imageNamed:@"UIPaymentCash"];
        }
    }
    else if ([self.method isEqualToString:paymentTypeGiftVoucher])
    {
        //Voucher
        image = [UIImage imageNamed:@"UIPaymentGiftVoucher"];
    }
    else if ([self.method isEqualToString:paymentTypeOnlineCredit])
    {
        //Online Credit
        image = [UIImage imageNamed:@"UIPaymentGiftVoucher"];
    }
    else
    {
        //Generic payment
        image = [UIImage imageNamed:@"UIPaymentCash"];
    }
    
    return image;
}

@end
