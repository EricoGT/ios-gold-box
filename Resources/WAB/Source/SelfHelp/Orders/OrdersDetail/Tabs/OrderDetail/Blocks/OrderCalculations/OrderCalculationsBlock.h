//
//  OrderCalculationsBlock.h
//  Walmart
//
//  Created by Danilo on 10/21/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingOrderDetail.h"

@interface OrderCalculationsBlock : TrackingViewWithXib

- (void)setupCalculationsWithDetails:(TrackingOrderDetail *)details;

@end
