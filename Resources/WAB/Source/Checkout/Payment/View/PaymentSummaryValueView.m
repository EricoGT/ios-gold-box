//
//  PaymentSummaryValueView.m
//  Walmart
//
//  Created by Renan Cargnin on 04/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "PaymentSummaryValueView.h"

#import "NSNumber+Currency.h"

@interface PaymentSummaryValueView ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation PaymentSummaryValueView

- (NSString *)valueDescription {
    return _descriptionLabel.text;
}

- (void)setValueDescription:(NSString *)valueDescription {
    _descriptionLabel.text = valueDescription;
}

- (void)setValue:(NSNumber *)value {
    _valueLabel.text = value.floatValue == 0 ? @"Grátis" : [value currencyFormat];
    _value = value;
}

@end
