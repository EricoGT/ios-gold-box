//
//  CreditCardInteractor.h
//  Walmart
//
//  Created by Renan Cargnin on 3/22/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CreditCardFlag) {
    CreditCardFlagAmex = 0,
    CreditCardFlagVisa = 1,
    CreditCardFlagMaster = 2,
    CreditCardFlagHiper = 3,
    CreditCardFlagDiners = 4,
    CreditCardFlagElo = 5,
    CreditCardFlagUnrecognized = 6,
};

@interface CreditCardInteractor : NSObject

+ (UIImage *)imageForFlag:(CreditCardFlag)flag;

/**
 * This method is specifc for the ThankYouPage because the flag images are a bit larged
 * than the usual.
 **/
+ (UIImage *)thankYouPageImageForFlag:(CreditCardFlag)flag;
+ (UIImage *)minImageForFlag:(CreditCardFlag)flag;
+ (NSString *)valueForFlag:(CreditCardFlag)flag;

+ (CreditCardFlag)creditCardFlagForCardName:(NSString *)cardName;
+ (CreditCardFlag)creditCardFlagWithCardNumberString:(NSString *)cardNumberString;
+ (CreditCardFlag)creditCardFlagWithCardNumber:(NSNumber *)cardNumber;

@end
