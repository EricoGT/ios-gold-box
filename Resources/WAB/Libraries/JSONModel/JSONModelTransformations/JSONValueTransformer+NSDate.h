//
//  JSONValueTransformer+CustomDate.h
//  Tracking
//
//  Created by Bruno Delgado on 5/9/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (CustomDate)

- (NSDate *)NSDateFromNSString:(NSString *)string;
- (NSDate *)NSDateFromNSNumber:(NSNumber *)number;
- (NSNumber *)JSONObjectFromNSDate:(NSDate *)date;

@end
