//
//  WBRCreditCardFieldValidation.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardValidation.h"

NSString * const amexRegexValidation = @"^3[47][0-9]*";

//NSString * const visaRegex = @"^4[0-9]*";
NSString * const visaRegexValidation = @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";

NSString * const masterRegexValidation = @"^5[1-5][0-9]*";
NSString * const hiperRegexValidation = @"^(3841|606282)[0-9]*";
NSString * const dinersRegexValidation = @"^3(?:0[0-5]|[68][0-9])[0-9]*";

//NSString * const eloRegex = @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";

NSString * const eloRegexValidation = @"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";

NSString * const CreditCardBrandAMEX = @"AMEX";
NSString * const CreditCardBrandVISA = @"VISA";
NSString * const CreditCardBrandMASTERCARD = @"MASTERCARD";
NSString * const CreditCardBrandMASTER = @"MASTER";
NSString * const CreditCardBrandHIPERCARD = @"HIPERCARD";
NSString * const CreditCardBrandHIPER = @"HIPER";
NSString * const CreditCardBrandDINERS = @"DINERS";
NSString * const CreditCardBrandELO = @"ELO";

@implementation WBRCreditCardValidation

+ (NSString *)cleanPunctuation:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

+ (BOOL)applyCreditCardNumberMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //Credit Card number
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[textField.text stringByAppendingString:string]];
    if (range.length==1 && string.length==0)
    {
        NSString *str = textField.text;
        NSString *truncatedString = [str substringToIndex:[str length]-1];
        mutableResult = [[NSMutableString alloc] initWithString:truncatedString];
    }
    
    //LogInfo(@"Credit Card Mask: %@", self.cCardSelected);
    NSInteger lenght = mutableResult.length;
    
    CreditCardValidationFlag creditCardFlag = [WBRCreditCardValidation creditCardFlagWithCardNumberString:mutableResult];
    
    if (creditCardFlag == CreditCardValidationFlagVisa || creditCardFlag == CreditCardValidationFlagMaster || creditCardFlag == CreditCardValidationFlagElo)
    {
        if (lenght > 19) return NO;
        [mutableResult replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [mutableResult insertString:@" " atIndex:4];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [mutableResult insertString:@" " atIndex:9];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [mutableResult insertString:@" " atIndex:14];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.####)
        if (insertedPunctuation) return NO;
    }
    else if (creditCardFlag == CreditCardValidationFlagAmex)
    {
        if (lenght > 17) return NO;
        [mutableResult replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [mutableResult insertString:@" " atIndex:4];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [mutableResult insertString:@" " atIndex:11];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        ////(####.######.#####)
        if (insertedPunctuation) return NO;
    }
    else if (creditCardFlag == CreditCardValidationFlagDiners)
    {
        if (lenght > 16) return NO;
        [mutableResult replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [mutableResult insertString:@" " atIndex:4];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [mutableResult insertString:@" " atIndex:11];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        ////(####.######.####)
        if (insertedPunctuation) return NO;
    }
    else if (creditCardFlag == CreditCardValidationFlagHiper)
    {
        if (lenght > 19) return NO;
        
        [mutableResult replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [mutableResult insertString:@" " atIndex:4];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [mutableResult insertString:@" " atIndex:9];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [mutableResult insertString:@" " atIndex:14];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        ////(####.####.####.#######)
        if (insertedPunctuation) return NO;
    }
    else {
        if (lenght > 19) return NO;
    }
    
    return YES;
}

+ (BOOL)applyCreditCardExpirationDateMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c]) {
            return NO;
        }
    }
    
    if (![string isEqualToString:@""]) {
        
        // Month validation
        if (textField.text.length == 0 && [string intValue] > 1 && string.length == 1) {
            textField.text = [NSString stringWithFormat:@"0%@", string];
            return NO;
        }
        
        if (textField.text.length == 1) {
            
            // Month starts with 0
            if ([[textField.text substringToIndex:1] intValue] == 0 && string.length >= 1 && [[string substringToIndex:1] intValue] == 0) {
                return NO;
            }
            
            // Month starts with 1
            if ([[textField.text substringToIndex:1] intValue] > 0 && string.length >= 1 && [[string substringToIndex:1] intValue] > 2) {
                return NO;
            }
        }
        //
        
        if ((textField.text.length + string.length) > 2) {
            
            NSMutableString *newString = [[NSMutableString alloc] initWithString:textField.text];
            [newString appendString:string];
            
            // Insert "/" between month and year
            if (![textField.text containsString:@"/"]) {
                [newString insertString:@"/" atIndex:2];
            }
            
            // Copy/Paste Validation
            if (newString.length > 5) {
                textField.text = [newString substringToIndex:5];
            } else {
                textField.text = newString;
            }
            
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)hasValidCardNumber:(NSString *)creditCardNumber {
    NSString *strVerifyValidCard = [self getNameCardWithNumber:creditCardNumber];
    return creditCardNumber.length > 0 && [self validateCardForTypeWithText:creditCardNumber AndCreditCardFlag:strVerifyValidCard];
}

+ (NSString *) getNameCardWithNumber:(NSString *) cardNumber {
    
    
    cardNumber = [self cleanPunctuation:cardNumber];
    
    //For VISA
    //    NSString *regexVisa = @"^4[0-9]*";
    NSString *regexVisa = @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";
    NSPredicate *predVisa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexVisa];
    NSInteger minimumLenghtVisa = 16;
    //For AMEX
    NSString *regexAmex = @"^3[47][0-9]*";
    NSPredicate *predAmex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAmex];
    NSInteger minimumLenghtAmex = 15;
    //For MASTERCARD
    NSString *regexMaster = @"^5[1-5][0-9]*";
    NSPredicate *predMaster = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMaster];
    NSInteger minimumLenghtMaster = 16;
    //For DINERS
    NSString *regexDiners = @"^3(?:0[0-5]|[68][0-9])[0-9]*";
    NSPredicate *predDiners = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexDiners];
    NSInteger minimumLenghtDiners = 14;
    //For HIPER
    NSString *regexHiper = @"^(3841|606282)[0-9]*";
    NSPredicate *predHiper = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexHiper];
    NSInteger minimumLenghtHiper = 16;
    //For ELO
    //    NSString *regexElo = @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";
    NSString *regexElo = @"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";
    NSPredicate *predElo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexElo];
    NSInteger minimumLenghtElo = 16;
    
    if (([predVisa evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtVisa)) {
        return @"visa";
    }
    else if (([predAmex evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtAmex)) {
        return @"amex";
    }
    else if (([predMaster evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtMaster)) {
        return @"mastercard";
    }
    else if (([predDiners evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtDiners)) {
        return @"diners";
    }
    else if (([predHiper evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtHiper)) {
        return @"hipercard";
    }
    else if (([predElo evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtElo)) {
        return @"elo";
    }
    else {
        return nil;
    }
}

+ (BOOL)validateCardForTypeWithText:(NSString *)text AndCreditCardFlag:(NSString *)creditCardFlag
{
    text = [WBRCreditCardValidation cleanPunctuation:text];
    NSString *regex = nil;
    NSInteger minimiumLenght = 0;
    
    if ([creditCardFlag isEqualToString:@"visa"])
    {
        //        regex= @"^4[0-9]*";
        regex= @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";
        minimiumLenght = 16;
    }
    else if ([creditCardFlag isEqualToString:@"amex"])
    {
        regex= @"^3[47][0-9]*";
        minimiumLenght = 15;
    }
    else if ([creditCardFlag isEqualToString:@"mastercard"])
    {
        regex= @"^5[1-5][0-9]*";
        minimiumLenght = 16;
    }
    else if ([creditCardFlag isEqualToString:@"diners"])
    {
        regex= @"^3(?:0[0-5]|[68][0-9])[0-9]*";
        minimiumLenght = 14;
    }
    else if ([creditCardFlag isEqualToString:@"hipercard"])
    {
        regex= @"^(3841|606282)[0-9]*";
        minimiumLenght = 16;
    }
    else if ([creditCardFlag isEqualToString:@"elo"])
    {
        //        regex= @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";
        
        regex=@"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";
        minimiumLenght = 16;
    }
    
    LogInfo(@"Text length: %lu [%@]", (unsigned long)[text length], text);
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (([regexTest evaluateWithObject:text]) && (text.length == minimiumLenght))
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getCreditCardExpirationMonthFrom:(NSString *)date {
    if (date.length < 5) {
        return nil;
    }
    
    LogInfo(@"Month: %@", [date substringToIndex:2]);
    return [date substringToIndex:2];
}

+ (NSString *)getCreditCardExpirationYearFrom:(NSString *)date {
    if (date.length < 5) {
        return nil;
    }
    
    LogInfo(@"Year: %@", [date substringFromIndex:3]);
    return [date substringFromIndex:3];
}

+ (BOOL) verifyCreditCardExpirationDate:(NSString *)stringDate {
    if (stringDate.length < 5) {
        return NO;
    }
    
    // Check month is valid (1, 2, 3.. 12)
    NSString *monthInserted = [self getCreditCardExpirationMonthFrom: stringDate];
    if ([monthInserted intValue] > 12) {
        return NO;
    }
    
    BOOL successValidate = YES;
    
    //Get date info
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = (int)[components year];
    int month = (int)[components month];
    
    NSString *today = [NSString stringWithFormat:@"%i%02d", year, month];
    
    NSString *dateChoosed = [NSString stringWithFormat:@"20%@%@", [self getCreditCardExpirationYearFrom:stringDate], monthInserted];
    
    if ([today intValue] > [dateChoosed intValue])
    {
        successValidate = NO;
    }
    
    return successValidate;
}

+ (CreditCardValidationFlag)creditCardFlagWithCardNumberString:(NSString *)cardNumberString {
    
    if (!cardNumberString) {
        cardNumberString = @"";
    }
    
    NSMutableString *creditCardNumber = [[NSMutableString alloc] initWithString:cardNumberString];
    [creditCardNumber replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, creditCardNumber.length)];
    [creditCardNumber replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, creditCardNumber.length)];
    cardNumberString = creditCardNumber.copy;
    
    NSArray *regexes = @[amexRegexValidation, visaRegexValidation, masterRegexValidation, hiperRegexValidation, dinersRegexValidation, eloRegexValidation];
    for (NSInteger i = 0; i < regexes.count; i++)
    {
        NSString *regex = regexes[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:cardNumberString])
        {
            return i;
        }
    }
    return CreditCardValidationFlagUnrecognized;
}

+ (CreditCardValidationFlag)creditCardFlagForBrand:(NSString *)brand {
    
    NSString *upperCaseBrand = [brand uppercaseString];
    CreditCardValidationFlag cardFlag;
    
    if ([upperCaseBrand isEqualToString:CreditCardBrandAMEX]) {
        cardFlag = CreditCardValidationFlagAmex;
    }
    else if ([upperCaseBrand isEqualToString:CreditCardBrandVISA]) {
        cardFlag = CreditCardValidationFlagVisa;
    }
    else if (([upperCaseBrand isEqualToString:CreditCardBrandMASTERCARD]) || ([upperCaseBrand isEqualToString:CreditCardBrandMASTER])) {
        cardFlag = CreditCardValidationFlagMaster;
    }
    else if (([upperCaseBrand isEqualToString:CreditCardBrandHIPERCARD]) || ([upperCaseBrand isEqualToString:CreditCardBrandHIPER])){
        cardFlag = CreditCardValidationFlagHiper;
    }
    else if ([upperCaseBrand isEqualToString:CreditCardBrandDINERS]) {
        cardFlag = CreditCardValidationFlagDiners;
    }
    else if ([upperCaseBrand isEqualToString:CreditCardBrandELO]) {
        cardFlag = CreditCardValidationFlagElo;
    }
    else {
        cardFlag = 99; //Unknown card
    }
    
    return cardFlag;
}

+ (UIImage *)thankYouPageImageForFlag:(CreditCardValidationFlag)flag {
    UIImage *image;
    switch (flag) {
        case CreditCardValidationFlagAmex:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardAmex"];
            break;
        case CreditCardValidationFlagVisa:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardVisa"];
            break;
        case CreditCardValidationFlagMaster:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardMaster"];
            break;
        case CreditCardValidationFlagDiners:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardDiners"];
            break;
        case CreditCardValidationFlagHiper:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardHiper"];
            break;
        case CreditCardValidationFlagElo:
            image = [UIImage imageNamed:@"ThankYouPageCreditCardElo"];
            break;
        case CreditCardValidationFlagUnrecognized:
            image = nil;
            break;
        default:
            break;
    }
    
    return image;
}

@end
