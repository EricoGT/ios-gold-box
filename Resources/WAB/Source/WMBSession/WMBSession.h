//
//  WMBSession.h
//  Walmart
//
//  Created by Bruno Delgado on 7/22/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBSession : NSObject

/**
 *  Updates the stored server date
 *
 *  @param serverDateInString NSString with the server date
 */

+ (void)updateServerDateWithStringDate:(NSString * _Nullable)serverDateInString;

/**
 *  Updates the stored server date
 *
 *  @param serverDate NSDate with the server date
 */
+ (void)updateServerDateWithDate:(NSDate * _Nullable)serverDate;

/**
 *  Returns the server date (If we have one)
 *
 *  @return NSDate with the stored server date
 */
+ (nullable NSDate *)serverDate;


@end
