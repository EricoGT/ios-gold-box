//
//  UIViewController+Product.h
//  Walmart
//
//  Created by Renan Cargnin on 01/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Product)

/**
 *  Opens product detail view controller
 *
 *  @param productId  NSString with the product id to load
 */
- (void)openProductWithID:(NSString *)productId;

/**
 *  Opens product detail view controller
 *
 *  @param productSku  NSString with the product sku to load
 */
- (void)openProductWithSKU:(NSString *)productSku;

/**
 *  Opens product detail view controller
 *
 *  @param productId  NSString with the product id to load
 *  @param showcaseId NSString with the showcase if it's coming from to register in the retargeting
 */
- (void)openProductWithID:(NSString *)productId fromShowcaseId:(NSString *)showcaseId;

@end
