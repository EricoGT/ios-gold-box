//
//  CardProductsResume.h
//  CustomComponents
//
//  Created by Marcelo Santos on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateProductsResume <NSObject>
@required
- (void) backToCartFromCardProducts;
- (void) backToSelectDeliveries;
@end

@interface CardProductsResume : UIViewController
{
    __weak id <delegateProductsResume> delegate;
}

@property (weak) id delegate;
@property (nonatomic, strong) NSDictionary *paymentDictionary;

- (NSDictionary *)products;
- (void)removeEdition;

@end
