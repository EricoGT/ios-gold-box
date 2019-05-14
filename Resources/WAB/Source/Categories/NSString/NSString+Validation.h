//
//  NSString+Validation.h
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

/**
 *  Validates a string considering CNPJ format
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isCNPJ;

/**
 *  Validates a string considering CPF format
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isCPF;

/**
 *  Validates a string considering e-mail format
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isEmail;

/**
 *  Validates a string considering phone format (8 digits)
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isPhone;

/**
 *  Validates a string considering mobile phone format (8 digits or more)
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isMobilePhone;

/**
 *  Validates a string considering name format (only letters)
 *
 *  @return The validation result (valid = YES, not valid = NO)
 */
- (BOOL)isName;

/**
 *  Returns a string without punctuation characters
 *
 *  @return The string without punctuation characters
 */
- (NSString *)stringWithoutPuntuaction; // TODO: fix method name (punctuation)

@end
