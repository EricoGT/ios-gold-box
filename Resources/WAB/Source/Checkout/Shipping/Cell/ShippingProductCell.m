//
//  ShippingProductCell.m
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ShippingProductCell.h"

#import "CartItem.h"

@interface ShippingProductCell ()

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ShippingProductCell

- (void)setupWithCartItem:(CartItem *)cartItem {
    self.quantityLabel.text = [NSString stringWithFormat:@"%@x", cartItem.quantity.stringValue];
    self.nameLabel.text = cartItem.productDescription;
}

@end
