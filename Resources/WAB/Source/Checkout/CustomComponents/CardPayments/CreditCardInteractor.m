//
//  CreditCardInteractor.m
//  Walmart
//
//  Created by Renan Cargnin on 3/22/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "CreditCardInteractor.h"

NSString * const amexRegex = @"^3[47][0-9]*";

//NSString * const visaRegex = @"^4[0-9]*";
NSString * const visaRegex = @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";

NSString * const masterRegex = @"^5[1-5][0-9]*";
NSString * const hiperRegex = @"^(3841|606282)[0-9]*";
NSString * const dinersRegex = @"^3(?:0[0-5]|[68][0-9])[0-9]*";

//NSString * const eloRegex = @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";

NSString * const eloRegex = @"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";

@implementation CreditCardInteractor

+ (CreditCardFlag)creditCardFlagForCardName:(NSString *)cardName {
    cardName = [cardName uppercaseString];
    
    CreditCardFlag cardFlag = CreditCardFlagUnrecognized;
    if ([cardName isEqualToString:@"AMEX"]) {
        cardFlag = CreditCardFlagAmex;
    }
    else if ([cardName isEqualToString:@"VISA"]) {
        cardFlag = CreditCardFlagVisa;
    }
    else if ([cardName isEqualToString:@"MASTERCARD"] || [cardName isEqualToString:@"MASTER"]) {
        cardFlag = CreditCardFlagMaster;
    }
    else if ([cardName isEqualToString:@"HIPER"] || [cardName isEqualToString:@"HIPERCARD"]) {
        cardFlag = CreditCardFlagHiper;
    }
    else if ([cardName isEqualToString:@"DINERS"]) {
        cardFlag = CreditCardFlagDiners;
    }
    else if ([cardName isEqualToString:@"ELO"]) {
        cardFlag = CreditCardFlagElo;
    }
    return cardFlag;
}

+ (CreditCardFlag)creditCardFlagWithCardNumberString:(NSString *)cardNumberString {
    
    if (!cardNumberString) {
        cardNumberString = @"";
    }
    
    NSMutableString *creditCardNumber = [[NSMutableString alloc] initWithString:cardNumberString];
    [creditCardNumber replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, creditCardNumber.length)];
    [creditCardNumber replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, creditCardNumber.length)];
    cardNumberString = creditCardNumber.copy;
    
    NSArray *regexes = @[amexRegex, visaRegex, masterRegex, hiperRegex, dinersRegex, eloRegex];
    for (NSInteger i = 0; i < regexes.count; i++)
    {
        NSString *regex = regexes[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:cardNumberString])
        {
            return i;
        }
    }
    return CreditCardFlagUnrecognized;
}

+ (UIImage *)thankYouPageImageForFlag:(CreditCardFlag)flag {
    UIImage *image;
    switch (flag) {
        case CreditCardFlagAmex:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardAmex"];
            break;
        case CreditCardFlagVisa:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardVisa"];
            break;
        case CreditCardFlagMaster:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardMaster"];
            break;
        case CreditCardFlagDiners:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardDiners"];
            break;
        case CreditCardFlagHiper:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardHiper"];
            break;
        case CreditCardFlagElo:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardElo"];
            break;
        case CreditCardFlagUnrecognized:
            image = nil;
            break;
            
        default:
            break;
    }
    
    return image;
}

+ (UIImage *)imageForFlag:(CreditCardFlag)flag {
    UIImage *image;
    switch (flag) {
        case CreditCardFlagAmex:
            image = [UIImage imageNamed:@"img_card_amex"];
            break;
        case CreditCardFlagVisa:
            image = [UIImage imageNamed:@"img_card_visa"];
            break;
        case CreditCardFlagMaster:
            image = [UIImage imageNamed:@"img_card_master"];
            break;
        case CreditCardFlagDiners:
            image = [UIImage imageNamed:@"img_card_diners"];
            break;
        case CreditCardFlagHiper:
            image = [UIImage imageNamed:@"img_card_hiper"];
            break;
        case CreditCardFlagElo:
            image = [UIImage imageNamed:@"img_card_elo"];
            break;
        case CreditCardFlagUnrecognized:
            image = nil;
            break;
            
        default:
            break;
    }
    
    return image;
}
    
+ (UIImage *)minImageForFlag:(CreditCardFlag)flag {
    UIImage *image;
    switch (flag) {
        case CreditCardFlagAmex:
        image = [UIImage imageNamed:@"minAmexIcon"];
        break;
        case CreditCardFlagVisa:
        image = [UIImage imageNamed:@"minVisaIcon"];
        break;
        case CreditCardFlagMaster:
        image = [UIImage imageNamed:@"minMasterIcon"];
        break;
        case CreditCardFlagDiners:
        image = [UIImage imageNamed:@"minDinersIcon"];
        break;
        case CreditCardFlagHiper:
        image = [UIImage imageNamed:@"minHiperIcon"];
        break;
        case CreditCardFlagElo:
        image = [UIImage imageNamed:@"minEloIcon"];
        break;
        case CreditCardFlagUnrecognized:
        image = nil;
        break;
        
        default:
        break;
    }
    
    return image;
}

+ (NSString *)valueForFlag:(CreditCardFlag)flag
{
    NSString *value = @"";
    switch (flag) {
        case CreditCardFlagAmex:
            value = @"amex";
            break;
        case CreditCardFlagVisa:
            value = @"visa";
            break;
        case CreditCardFlagMaster:
            value = @"mastercard";
            break;
        case CreditCardFlagDiners:
            value = @"diners";
            break;
        case CreditCardFlagHiper:
            value = @"hiper";
            break;
        case CreditCardFlagElo:
            value = @"elo";
            break;
        case CreditCardFlagUnrecognized:
            value = @"";
            break;
            
        default:
            break;
    }
    
    return value;
}

+ (CreditCardFlag)creditCardFlagWithCardNumber:(NSNumber *)cardNumber {
    return [CreditCardInteractor creditCardFlagWithCardNumberString:cardNumber.stringValue];
}

@end
