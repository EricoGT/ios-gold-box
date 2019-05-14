//
//  NSString+Share.m
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "NSString+Share.h"

@implementation NSString (Share)

- (NSString *)shareString {
    NSString *shareAction = self.copy;
    
    shareAction = [shareAction stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    shareAction = [shareAction stringByReplacingOccurrencesOfString:@"”" withString:@""];
    shareAction = [shareAction stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSMutableCharacterSet *specialCharactersSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"'!@#$%¨&+,/-*()?:;={}][º´®`².–Ø½¼%«¨Ð„–°_`¡¯»¨ª."];
    shareAction = [[shareAction componentsSeparatedByCharactersInSet:specialCharactersSet] componentsJoinedByString:@"-"];
    shareAction = [shareAction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    shareAction = [shareAction stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    NSData *strData = [shareAction dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    shareAction = [[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding];
    
    NSError *regexError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9a-zA-Z-]+ " options:NSRegularExpressionCaseInsensitive error:&regexError];
    if (!regexError) {
        shareAction = [regex stringByReplacingMatchesInString:shareAction options:0 range:NSMakeRange(0, shareAction.length) withTemplate:@""];
    }
    
    shareAction = [shareAction stringByReplacingOccurrencesOfString:@"," withString:@""];
    shareAction = shareAction.lowercaseString;
    return shareAction;
}

@end
