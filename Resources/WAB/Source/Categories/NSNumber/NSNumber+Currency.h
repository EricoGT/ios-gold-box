//
//  NSNumber+Currency.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Currency)

/**
 *  Returns the currency representation of an int.
 *
 *  @param intValue The int value that will be used in the conversion to the currency format string.
 *
 *  @return The currency format string resulted from the conversion.
 */
+ (NSString *)currencyFormatWithIntValue:(int)intValue;

/**
 *  Returns the currency representation of a NSInteger.
 *
 *  @param integerValue The NSInteger value that will be used in the conversion to the currency format string.
 *
 *  @return The currency format string resulted from the conversion.
 */
+ (NSString *)currencyFormatWithIntegerValue:(NSInteger)integerValue;

/**
 *  Returns the currency representation of a float.
 *
 *  @param floatValue The the float value that will be used in the conversion to the currency format string.
 *
 *  @return The currency format string resulted from the conversion.
 */
+ (NSString *)currencyFormatWithFloatValue:(float)floatValue;

/**
 *  Returns the currency representation of a double.
 *
 *  @param doubleValue The double value that will be used in the conversion to the currency format string.
 *
 *  @return The currency format string resulted from the conversion.
 */
+ (NSString *)currencyFormatWithDoubleValue:(float)doubleValue;

/**
 *  Returns the currency representation of the NSNumber object with a specific currency symbol.
 *
 *  @param currencySynbol The currency symbol that will be used in the conversion.
 *
 *  @return The currency format string resulted from the conversion.
 */
- (NSString *)currencyFormatWithCurrencySymbol:(NSString *)currencySymbol;

/**
 *  Returns the currency representation of the NSNumber object with the default currency symbol.
 *
 *  @return The currency format string resulted from the conversion.
 */
- (NSString *)currencyFormat;

@end
