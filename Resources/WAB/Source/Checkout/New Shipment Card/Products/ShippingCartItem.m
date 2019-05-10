//
//  ShippingCartItem.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "ShippingCartItem.h"

@interface ShippingCartItem ()

@property (nonatomic, retain) IBOutlet UILabel *indexLabel;
@property (nonatomic, retain) IBOutlet UILabel *productDescriptionLabel;

@end

@implementation ShippingCartItem

//Loading view from XIB
+ (UIView *)viewWithXibName:(NSString *)xibName
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

- (void)setupWithCartItem:(CartItem *)item
{
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)item.quantity.integerValue];
    self.productDescriptionLabel.text = (item.productDescription.length > 0) ? item.productDescription : @"";
}


@end
