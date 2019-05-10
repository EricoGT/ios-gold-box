//
//  ProductOptionsView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductOptionsView.h"

@interface ProductOptionsView()

@property (assign, nonatomic) BOOL showPaymentMethods;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *paymentMethodsView;

@end

@implementation ProductOptionsView

- (ProductOptionsView *)initWithDelegate:(id<ProductOptionsViewDelegate>)delegate showPaymentMethods:(BOOL)showPaymentMethods {
    if (self = [super init]) {
        self.delegate = delegate;
        self.showPaymentMethods = showPaymentMethods;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (self.showPaymentMethods) {
        self.paymentMethodsViewHeightConstraint.constant = 60;
        self.paymentMethodsView.hidden = NO;
    }
    else {
        self.paymentMethodsViewHeightConstraint.constant = 0;
        self.paymentMethodsView.hidden = YES;
    }
    
    [self layoutIfNeeded];
}

- (IBAction)pressedPaymentForms {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productOptionsPressedPaymentForms)]) {
        [self.delegate productOptionsPressedPaymentForms];
    }
}

- (IBAction)pressedDescription {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productOptionsPressedDescription)]) {
        [self.delegate productOptionsPressedDescription];
    }
}

- (IBAction)pressedFeatures {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productOptionsPressedFeatures)]) {
        [self.delegate productOptionsPressedFeatures];
    }
}

@end
