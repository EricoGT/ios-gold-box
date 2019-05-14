//
//  NSString+Share.h
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Share)

/**
 *  Returns a string prepared for share (without invalid characters, basically)
 *
 *  @return The string prepared for share
 */
- (NSString *)shareString;

@end