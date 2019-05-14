//
//  WALProductDetailViewController.h
//  Walmart
//
//  Created by Renan Cargnin on 1/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//
#define STAMP_VIEW_TAG 10
#define VARIATIONS_TREE_VIEW 12
#define OPTIONS_VIEW 13
#define PRODUCT_UNAVAILABLE_VIEW_TAG 14
#define FREIGHT_VIEW_TAG 15

#define TOP_OTHER_SELLERS_SPACE 40.0f
#define TOP_VARIATIONS_TREE_VIEW 0.0f
#define TOP_OPTIONS_VIEW 0.0f

#import "WMBaseViewController.h"

@interface WALProductDetailViewController : WMBaseViewController

- (WALProductDetailViewController *)initWithProductId:(NSString *)productId showcaseId:(NSString *)showcaseId;
- (WALProductDetailViewController *)initWithSKU:(NSString *)sku showcaseId:(NSString *)showcaseId;

@end
