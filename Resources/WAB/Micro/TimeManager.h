//
//  TimeManager.h
//  Walmart
//
//  Created by Marcelo Santos on 1/12/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 ## Time of expiration in seconds

 * **EXPIRE_SECONDS_SETUP**<br>
 Time between requests: HUB Setup (default: 60)
 * **EXPIRE_SECONDS_HOME_DYNAMIC**<br>
 Time between requests: Dynamic Home (default: 30)
 * **EXPIRE_SECONDS_HOME_STATIC**<br>
 Time between requests: Static Home (default: 15)
 @return time in seconds
 */
#define EXPIRE_SECONDS_SETUP 60
#define EXPIRE_SECONDS_HOME_DYNAMIC 30
#define EXPIRE_SECONDS_HOME_STATIC 15
#define EXPIRE_SECONDS_UTMS 259200 // 3 days: 259200 secs

@interface TimeManager : NSObject


/**
 Assign a time for Setup requests
 */
+ (void) assignTimeSetup;

/**
 Informs about if you should or not make a request

 @return YES or NO
 */
+ (BOOL) shouldMakeRequestSetup;

/**
 Assign a time for Dynamic Home requests
 */
+ (void) assignTimeHomeDynamic;
/**
 Informs about if you should or not make a request
 
 @return YES or NO
 */
+ (BOOL) shouldMakeRequestHomeDynamic;

/**
 Assign a time for Static Home requests
 */
+ (void) assignTimeHomeStatic;
/**
 Informs about if you should or not make a request
 
 @return YES or NO
 */
+ (BOOL) shouldMakeRequestHomeStatic;

/**
 Update store information on WBMSession of server date

 @param response to get Date parameter
 */
+ (void)updateServerDateWithResponse:(NSHTTPURLResponse *)response;

/**
 Invalidade UTM, it'll add EXPIRE_SECONDS_UTMS on date passed as parameter

 @param utmDate date to use as reference
 @return invalide UTM date
 */
+ (NSDate *)invalidateUTMDate:(NSDate *)utmDate;

/**
 Check if UTM date is still valid for request

 @param UTMDate used to check if it stills valid
 @return BOOL
 */
+ (BOOL)UTMDateStillValid:(NSDate *)UTMDate;

@end
