//
//  NSString+HTTPEscape.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 10/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "NSString+HTTPEscape.h"

@implementation NSString (HTTPEscape)

- (NSString *)escapeFromBreakLine {
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
}

@end
