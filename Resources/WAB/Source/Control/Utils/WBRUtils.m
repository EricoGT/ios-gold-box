//
//  WBRUtils.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRUtils.h"

@implementation WBRUtils

+ (NSString *)formatDocument:(NSString *)document {
    
    if (document.length == 11) {
        return [self formatCPF:document];
    }
    else {
        return [self formatCNPJ:document];
    }
    
}

+ (NSString *)formatCPF:(NSString *)cpf {
    
    if (cpf.length == 11) {
        NSString *firstPart = [cpf substringWithRange:NSMakeRange(0, 3)];
        NSString *secondPart = [cpf substringWithRange:NSMakeRange(3, 3)];
        NSString *thirdPart = [cpf substringWithRange:NSMakeRange(6, 3)];
        NSString *lastPart = [cpf substringWithRange:NSMakeRange(9, 2)];
        
        return [NSString stringWithFormat:@"%@.%@.%@-%@", firstPart, secondPart, thirdPart, lastPart];
    }
    else {
        return cpf;
    }
}

+ (NSString *)formatCNPJ:(NSString *)cnpj {
    
    if (cnpj.length == 14) {
        NSString *firstPart = [cnpj substringWithRange:NSMakeRange(0, 2)];
        NSString *secondPart = [cnpj substringWithRange:NSMakeRange(2, 3)];
        NSString *thirdPart = [cnpj substringWithRange:NSMakeRange(5, 3)];
        NSString *fourthPart = [cnpj substringWithRange:NSMakeRange(8, 4)];
        NSString *lastPart = [cnpj substringWithRange:NSMakeRange(12, 2)];
        
        return [NSString stringWithFormat:@"%@.%@.%@/%@-%@", firstPart, secondPart, thirdPart, fourthPart, lastPart];
    }
    else {
        return cnpj;
    }
}

@end
