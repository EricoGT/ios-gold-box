//
//  ShippingProductCell.h
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartItem;

@interface ShippingProductCell : UITableViewCell

- (void)setupWithCartItem:(CartItem *)cartItem;

@end
