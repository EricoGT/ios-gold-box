//
//  ProductBuyView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductBuyView.h"

#import "WBRStepper.h"

@interface ProductBuyView ()

@property (weak, nonatomic) IBOutlet WBRStepper *stepper;

@end

@implementation ProductBuyView

- (ProductBuyView *)initWithDelegate:(id<ProductBuyViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (NSUInteger)quantity {
    return _stepper.stepValue;
}

- (IBAction)pressedBuy {
    if (_delegate && [_delegate respondsToSelector:@selector(productBuyPressedBuyButtonWithQuantity:)]) {
        [_delegate productBuyPressedBuyButtonWithQuantity:_stepper.stepValue];
    }
}

@end
