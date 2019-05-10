//
//  WishlistUrls.h
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 URL Wishlist
 
 @return Complete url with base url of wishlist
 */

#define URL_WISHLIST BASE_URL APP_VERSION @"/" @"list/wishlist"
#define URL_WISHLIST_SKU URL_WISHLIST @"/id"

@interface WishlistUrls : NSObject

@end
