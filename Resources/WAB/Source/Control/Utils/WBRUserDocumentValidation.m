//
//  WBRUserDocumentValidation.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/14/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRUserDocumentValidation.h"

@implementation WBRUserDocumentValidation

+ (NSString *)cleanPunctuation:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

+ (BOOL)isCPFValid:(NSString *)cpf {
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

+ (BOOL)isCNPJValid:(NSString *)cnpj
{
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

+ (BOOL) validateCpfCnpj:(NSString *)document {
    BOOL valid = NO;
    
    if ([self isCPFValid:[self cleanPunctuation:document]]) {
        LogInfo(@"CPF válido");
        valid = YES;
    } else {
        LogErro(@"CPF inválido");
    }
    
    if ([self isCNPJValid:[self cleanPunctuation:document]]) {
        LogInfo(@"CNPJ válido");
        valid = YES;
    } else {
        LogErro(@"CNPJ inválido");
    }
    
    return valid;
}

+ (BOOL)applyUserDocumentMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
    NSInteger lenght = mutableResult.length;
    BOOL isCPF = (lenght <= 14) ? YES : NO;
    
    if (lenght > 18) return NO;
    
    if (isCPF) {
        [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(000.)
        if (lenght > 3)
        {
            [mutableResult insertString:@"." atIndex:3];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(000.000.)
        if (lenght > 7)
        {
            [mutableResult insertString:@"." atIndex:7];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(000.000.000-)
        if (lenght > 11)
        {
            [mutableResult insertString:@"-" atIndex:11];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        if (range.length == 1 && string.length == 0) return YES;
        if (insertedPunctuation) return NO;
    }
    else
    {
        //CNPJ
        [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(00.)
        if (lenght > 2)
        {
            [mutableResult insertString:@"." atIndex:2];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(00.000.)
        if (lenght > 6)
        {
            [mutableResult insertString:@"." atIndex:6];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(00.000.000/)
        if (lenght > 10)
        {
            [mutableResult insertString:@"/" atIndex:10];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(00.000.000/0000-)
        if (lenght > 15)
        {
            [mutableResult insertString:@"-" atIndex:15];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        if (range.length == 1 && string.length == 0) return YES;
        if (insertedPunctuation) return NO;
    }
    
    return YES;
}

+ (BOOL)applyUserNameMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //Name on Credit Card
    NSUInteger newLengthOwnerName = [textField.text length] + [string length] - range.length;
    if(newLengthOwnerName > 50){
        return NO;
    }
    else{
        return YES;
    }
}

@end
