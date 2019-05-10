//
//  PaymentsBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 5/2/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingOrderDetail.h"

@interface PaymentsBlock : TrackingViewWithXib

- (void)setupWithOrderDetail:(TrackingOrderDetail *)detail;

@end
