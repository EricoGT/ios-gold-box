//
//  JSONValueTransformer+UIColor.h
//  Walmart
//
//  Created by Renan on 6/27/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (UIColor)

/**
 *  Handles the convertion of an array of strings or numbers into a UIColor object within JSONModel subclasses.
 *
 *  @param values The array of strings or numbers.
 *
 *  @return The color object resulted from the conversion.
 */
- (UIColor *)UIColorFromNSArray:(NSArray *)values;

/**
 *  Handles the convertion of a UIColor object into an array of numbers within JSONModel subclasses.
 *
 *  @param values The color object.
 *
 *  @return The array of numbers resulted from the conversion.
 */
- (NSArray *)JSONObjectFromUIColor:(UIColor *)color;

@end
