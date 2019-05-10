
//
//  OrderResumeBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingViewWithXib.h"
#import "TrackingOrderDetail.h"

@interface OrderResumeBlock : TrackingViewWithXib

- (void)setupWithOrderDetail:(TrackingOrderDetail *)detail;

@end
