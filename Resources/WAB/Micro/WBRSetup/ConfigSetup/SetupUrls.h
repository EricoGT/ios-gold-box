//
//  SetupUrls.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 URL Setup

 @return Complete url with base url of setup
 */
#define URL_SETUP BASE_URL APP_VERSION @"/" @"setup/setup"
//#define URL_SETUP @"https://napsao-qa-nix-mobile-setup-api-app-1.qa.vmcommerce.intra:9010/setup"
//#define URL_SETUP @"https://www.mocky.io/v2/58eb8f91110000a325288415" //503

@interface SetupUrls : NSObject

@end
