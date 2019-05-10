//
//  ShippingCartItem.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItem.h"

@interface ShippingCartItem : UIView

+ (UIView *)viewWithXibName:(NSString *)xibName;
- (void)setupWithCartItem:(CartItem *)item;

@end
