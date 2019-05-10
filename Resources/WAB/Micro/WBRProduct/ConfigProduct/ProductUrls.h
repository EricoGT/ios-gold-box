//
//  ProductUrls.h
//  Walmart
//
//  Created by Marcelo Santos on 3/30/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 URL Product
 
 @return Complete url with base url of products
 */
#define URL_PRODUCT_BASE BASE_URL APP_VERSION @"/" @"navigation"
#define URL_PRODUCT_DETAIL URL_PRODUCT_BASE
#define URL_SEARCH URL_PRODUCT_BASE @"/search"
#define URL_NOTIFY URL_PRODUCT_BASE @"/sku"
#define URL_PRODUCT_EXTENDED_WARRANTY URL_PRODUCT_BASE @"/sku"
#define URL_PRODUCT_PAYMENT_FORMS URL_PRODUCT_BASE @"/sku"

//#define URL_SEARCH BASE_URL APP_VERSION @"/" @"navigation/search"
//#define URL_PRODUCT_DETAIL BASE_URL APP_VERSION @"/" @"navigation"
//#define URL_NOTIFY BASE_URL APP_VERSION @"/" @"navigation/sku"
//#define URL_PRODUCT_EXTENDED_WARRANTY BASE_URL APP_VERSION @"/" @"navigation/sku"
//#define URL_PRODUCT_PAYMENT_FORMS BASE_URL APP_VERSION @"/" @"navigation/sku"

@interface ProductUrls : NSObject

@end
