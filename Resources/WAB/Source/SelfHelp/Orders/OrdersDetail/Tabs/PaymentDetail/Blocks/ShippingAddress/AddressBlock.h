//
//  ShippingAddressBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 29/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingAddress.h"

@interface AddressBlock : TrackingViewWithXib

- (void)setupWithAddress:(TrackingAddress *)address;

@end
