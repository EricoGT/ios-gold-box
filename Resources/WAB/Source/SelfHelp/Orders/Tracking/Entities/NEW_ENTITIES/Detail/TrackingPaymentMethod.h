//
//  TrackingPaymentMethod.h
//  Walmart
//
//  Created by Bruno Delgado on 10/9/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

//Parents
#define paymentTypeBarcode @"BARCODE"
#define paymentTypeCredit @"CREDIT"
#define paymentTypeCreditCard @"CREDIT_CARD"
#define paymentTypeDebit @"DEBIT_CARD"
#define paymentTypeGiftVoucher @"GIFT_VOUCHER"
#define paymentTypeOnlineCredit @"ONLINE_CREDIT"

//Sons - Credit
#define paymentTypeCreditVisa @"VISA"
#define paymentTypeCreditMastercard @"MASTERCARD"
#define paymentTypeCreditHipercard @"HIPERCARD"
#define paymentTypeCreditHiper @"HIPER"
#define paymentTypeCreditDiners @"DINERS"
#define paymentTypeCreditAmex @"AMEX"
#define paymentTypeCreditElo @"ELO"

//Sons - Debit
#define paymentTypeDebitItau @"Débito Banco Itau"
#define paymentTypeDebitBradesco @"Banco Bradesco S.A."

@protocol TrackingPaymentMethod
@end

#import "JSONModel.h"
#import "TrackingAddress.h"

@interface TrackingPaymentMethod : JSONModel

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *lastDigitsOfCard;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *completeName;
@property (strong, nonatomic) NSNumber *parcelAmount;
@property (strong, nonatomic) NSNumber *parcelValue;
@property (strong, nonatomic) TrackingAddress<Optional> *address;
@property (strong, nonatomic) NSString<Optional> *paymentUrl;
@property (strong, nonatomic) NSString<Optional> *interestRate;
@property (strong, nonatomic) NSString<Optional> *valueWithInterest;
@property (strong, nonatomic) NSString<Optional> *maxCET;

- (UIImage *)imageForCurrentPayment;

@end
