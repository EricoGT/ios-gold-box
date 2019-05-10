//
//  ProductBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingDeliveryDetailItem.h"
#import "TrackingViewWithXib.h"

@interface ProductBlock : TrackingViewWithXib

- (void)setupWithDeliveryItem:(TrackingDeliveryDetailItem *)detail imagePath:(NSString *)imagePath seller:(NSString *)sellerName;
- (void)hideProductDivider:(BOOL)hide;

@end
