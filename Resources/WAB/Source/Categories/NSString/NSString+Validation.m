//
//  NSString+Validation.m
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isCNPJ {
    NSString *cnpj = self;
    NSString *cnpjRegex = @"[0-9]{2}\\.?[0-9]{3}\\.?[0-9]{3}\\/?[0-9]{4}\\-?[0-9]{2}";
    NSPredicate *cnpjPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cnpjRegex];
    if ([cnpjPredicate evaluateWithObject:cnpj] == NO) return NO;
    
    cnpj = [cnpj stringByReplacingOccurrencesOfString:@"." withString:@""];
    cnpj = [cnpj stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cnpj = [cnpj stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSInteger sumCheckDigit1 = 0, sumCheckDigit2 = 0, checkDigit1 = -1, checkDigit2 = -1;
    if ((cnpj.length != 14) ||
        ([cnpj isEqualToString:@"00000000000000"]) ||
        ([cnpj isEqualToString:@"11111111111111"]) ||
        ([cnpj isEqualToString:@"22222222222222"]) ||
        ([cnpj isEqualToString:@"33333333333333"]) ||
        ([cnpj isEqualToString:@"44444444444444"]) ||
        ([cnpj isEqualToString:@"55555555555555"]) ||
        ([cnpj isEqualToString:@"66666666666666"]) ||
        ([cnpj isEqualToString:@"77777777777777"]) ||
        ([cnpj isEqualToString:@"88888888888888"]) ||
        ([cnpj isEqualToString:@"99999999999999"]))
        return NO;
    else
    {
        NSInteger multiplyFactor = 6;
        for (NSInteger i = cnpj.length; i > 2; i--)
        {
            NSRange range = NSMakeRange((cnpj.length - i),1);
            NSInteger value = [[cnpj substringWithRange:range] integerValue];
            
            if (multiplyFactor == 2)
                sumCheckDigit1 += value * 9;
            else
                sumCheckDigit1 += value * (multiplyFactor-1);
            sumCheckDigit2 += value * multiplyFactor;
            
            if (multiplyFactor == 2)
                multiplyFactor = 9;
            else
                multiplyFactor--;
        }
        
        checkDigit1 = 11 - (sumCheckDigit1 % 11);
        if (checkDigit1 >= 10)
            checkDigit1 = 0;
        sumCheckDigit2 += 2 * checkDigit1;
        checkDigit2 = 11 - (sumCheckDigit2 % 11);
        if (checkDigit2 >= 10)
            checkDigit2 = 0;
        
        NSRange range12 = NSMakeRange(12, 1);
        NSRange range13 = NSMakeRange(13, 1);
        
        return ((checkDigit1 == [[cnpj substringWithRange:range12] integerValue])
                && (checkDigit2 == [[cnpj substringWithRange:range13] integerValue]));
    }
}

- (BOOL)isCPF {
    NSString *cpf = self;
    NSString *cpfRegex = @"[0-9]{3}\\.?[0-9]{3}\\.?[0-9]{3}\\-?[0-9]{2}";
    NSPredicate *cpfPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cpfRegex];
    if ([cpfPredicate evaluateWithObject:cpf] == NO) return NO;
    
    cpf = [cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
    cpf = [cpf stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSInteger sumCheckDigit1 = 0, sumCheckDigit2 = 0, checkDigit1 = -1, checkDigit2 = -1;
    if ((cpf.length != 11) ||
        ([cpf isEqualToString:@"00000000000"]) ||
        ([cpf isEqualToString:@"11111111111"]) ||
        ([cpf isEqualToString:@"22222222222"]) ||
        ([cpf isEqualToString:@"33333333333"]) ||
        ([cpf isEqualToString:@"44444444444"]) ||
        ([cpf isEqualToString:@"55555555555"]) ||
        ([cpf isEqualToString:@"66666666666"]) ||
        ([cpf isEqualToString:@"77777777777"]) ||
        ([cpf isEqualToString:@"88888888888"]) ||
        ([cpf isEqualToString:@"99999999999"]))
        return NO;
    else
    {
        for (NSInteger i = cpf.length; i > 2; i--)
        {
            NSRange range = NSMakeRange(cpf.length - i,1);
            NSInteger value = [[cpf substringWithRange:range] integerValue];
            sumCheckDigit1 += value * (i-1);
            sumCheckDigit2 += value * i;
        }
        
        checkDigit1 = 11 - (sumCheckDigit1 % cpf.length);
        if (checkDigit1 >= 10)
            checkDigit1 = 0;
        sumCheckDigit2 += 2 * checkDigit1;
        checkDigit2 = 11 - (sumCheckDigit2 % cpf.length);
        if (checkDigit2 >= 10)
            checkDigit2 = 0;
        
        
        NSRange range9 = NSMakeRange(9, 1);
        NSRange range10 = NSMakeRange(10, 1);
        
        return ((checkDigit1 == [[cpf substringWithRange:range9] integerValue])
                && (checkDigit2 == [[cpf substringWithRange:range10] integerValue]));
    }
}

- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhone {
    return [[self stringWithoutPuntuaction] stringWithoutWhiteSpaces].length == 10;
}

- (BOOL)isMobilePhone {
    return [[self stringWithoutPuntuaction] stringWithoutWhiteSpaces].length >= 10;
}

- (BOOL)isName {
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzáéíóúçãõ"];
    return [[self lowercaseString] stringByTrimmingCharactersInSet:acceptableCharactersSet].length == 0;
}

- (NSString *)stringWithoutPuntuaction {
    NSCharacterSet *puntuactionCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".-/()"];
    return [[self componentsSeparatedByCharactersInSet:puntuactionCharacterSet] componentsJoinedByString:@""];
}

- (NSString *)stringWithoutWhiteSpaces {
    NSCharacterSet *whiteSpaceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    return [[self componentsSeparatedByCharactersInSet:whiteSpaceCharacterSet] componentsJoinedByString:@""];
}

@end
