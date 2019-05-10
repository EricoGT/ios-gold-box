//
//  WBRUserDocumentValidation.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/14/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRUserDocumentValidation : NSObject

+ (BOOL) validateCpfCnpj:(NSString *)document;

+ (BOOL)applyUserDocumentMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)applyUserNameMaskOnKeyTouchedInTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
