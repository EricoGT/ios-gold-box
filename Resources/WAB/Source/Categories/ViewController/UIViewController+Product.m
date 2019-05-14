//
//  UIViewController+Product.m
//  Walmart
//
//  Created by Renan Cargnin on 01/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UIViewController+Product.h"

#import "WALProductDetailViewController.h"

@implementation UIViewController (Product)

- (void)openProductWithID:(NSString *)productId {
    [self openProduct:productId showcase:nil];
}

- (void)openProductWithID:(NSString *)productId fromShowcaseId:(NSString *)showcaseId {
    [self openProduct:productId showcase:showcaseId];
}

- (void)openProductWithSKU:(NSString *)productSku {
    WALProductDetailViewController *productDetail = [[WALProductDetailViewController alloc] initWithSKU:productSku showcaseId:nil];
    [self.navigationController pushViewController:productDetail animated:YES];
}

- (void)openProduct:(NSString *)productId showcase:(NSString *)showcaseId {
    WALProductDetailViewController *productDetail = [[WALProductDetailViewController alloc] initWithProductId:productId showcaseId:showcaseId];
    [self.navigationController pushViewController:productDetail animated:YES];
}

@end
