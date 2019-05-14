//
//  UITextField+MaskValidation.m
//  Walmart
//
//  Created by Bruno Delgado on 4/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UITextField+MaskValidation.h"

@implementation UITextField (MaskValidation)

- (BOOL)maskCPFInRange:(NSRange)range forReplacementString:(NSString *)string
{
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[self.text stringByAppendingString:string]];
    NSInteger lenght = mutableResult.length;
    if (lenght > 14) return NO;
    
    [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    
    BOOL insertedPunctuation = NO;
    //(000.)
    if (lenght > 3)
    {
        [mutableResult insertString:@"." atIndex:3];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    //(000.000.)
    if (lenght > 7)
    {
        [mutableResult insertString:@"." atIndex:7];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    //(000.000.000-)
    if (lenght > 11)
    {
        [mutableResult insertString:@"-" atIndex:11];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    if (range.length == 1 && string.length == 0) return YES;
    if (insertedPunctuation) return NO;
    
    return YES;
}

- (BOOL)maskCNPJInRange:(NSRange)range forReplacementString:(NSString *)string
{
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[self.text stringByAppendingString:string]];
    NSInteger lenght = mutableResult.length;
    if (lenght > 18) return NO;
    
    //CNPJ
    [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    
    BOOL insertedPunctuation = NO;
    //(00.)
    if (lenght > 2)
    {
        [mutableResult insertString:@"." atIndex:2];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    //(00.000.)
    if (lenght > 6)
    {
        [mutableResult insertString:@"." atIndex:6];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    //(00.000.000/)
    if (lenght > 10)
    {
        [mutableResult insertString:@"/" atIndex:10];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    //(00.000.000/0000-)
    if (lenght > 15)
    {
        [mutableResult insertString:@"-" atIndex:15];
        self.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    if (range.length == 1 && string.length == 0) return YES;
    if (insertedPunctuation) return NO;
    
    return YES;
}


- (BOOL)maskDocumentInRange:(NSRange)range forReplacementString:(NSString *)string
{
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[self.text stringByAppendingString:string]];
    NSInteger lenght = mutableResult.length;
    BOOL isCPF = (lenght <= 14) ? YES : NO;
    if (lenght > 18) return NO;
    
    if (isCPF)
    {
        return [self maskCPFInRange:range forReplacementString:string];
    }
    else
    {
        return [self maskCNPJInRange:range forReplacementString:string];
    }
}

@end
