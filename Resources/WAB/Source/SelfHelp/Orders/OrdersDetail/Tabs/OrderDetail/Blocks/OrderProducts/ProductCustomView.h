//
//  ProductCustomView.h
//  Walmart
//
//  Created by Bruno Delgado on 5/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingDeliveryDetailItem.h"

@interface ProductCustomView : TrackingViewWithXib

- (void)setupWithDeliveryItem:(TrackingDeliveryDetailItem *)detail kits:(NSArray *)kits;
- (void)hideProductDivider:(BOOL)hide;

@end
