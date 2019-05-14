//
//  WBRCreditCardFieldValidation.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRCreditCardValidation.h"

typedef NS_ENUM(NSInteger, CreditCardValidationFlag) {
    CreditCardValidationFlagAmex = 0,
    CreditCardValidationFlagVisa = 1,
    CreditCardValidationFlagMaster = 2,
    CreditCardValidationFlagHiper = 3,
    CreditCardValidationFlagDiners = 4,
    CreditCardValidationFlagElo = 5,
    CreditCardValidationFlagUnrecognized = 6,
};

@interface WBRCreditCardValidation : NSObject

+ (BOOL)applyCreditCardNumberMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)applyCreditCardExpirationDateMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)hasValidCardNumber:(NSString *)creditCardNumber;

+ (BOOL)verifyCreditCardExpirationDate:(NSString *)stringDate;

+ (NSString *)getCreditCardExpirationYearFrom:(NSString *)date;

+ (NSString *)getCreditCardExpirationMonthFrom:(NSString *)date;

+ (NSString *)getNameCardWithNumber:(NSString *) cardNumber;

+ (CreditCardValidationFlag)creditCardFlagForBrand:(NSString *)brand;

+ (UIImage *)thankYouPageImageForFlag:(CreditCardValidationFlag)flag;

@end
