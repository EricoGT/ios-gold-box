//
//  HomeUrls.h
//  Walmart
//
//  Created by Marcelo Santos on 4/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 URLs Home
 
 @return Complete url with home base url
 */
#define URL_HOME_BASE BASE_URL APP_VERSION @"/" @"navigation/home"
#define URL_HOME_DYNAMIC URL_HOME_BASE @"/dynamic"
#define URL_HOME_STATIC URL_HOME_BASE @"/static"

@interface HomeUrls : NSObject

@end
