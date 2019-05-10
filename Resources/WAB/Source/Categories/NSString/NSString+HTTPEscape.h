//
//  NSString+HTTPEscape.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 10/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTTPEspace)

/**
 Replaces Break line special char (\n) to a escaped char (\\n) from string for http POST

 @return New escaped string
 */
- (NSString *)escapeFromBreakLine;

@end
