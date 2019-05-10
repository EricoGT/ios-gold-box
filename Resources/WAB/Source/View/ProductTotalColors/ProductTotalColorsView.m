//
//  ProductTotalColorsView.m
//  Walmart
//
//  Created by Renan on 7/5/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ProductTotalColorsView.h"

@interface ProductTotalColorsView ()

@property (weak, nonatomic) IBOutlet UILabel *totalColorsLabel;

@end

@implementation ProductTotalColorsView

- (NSInteger)totalColors {
    return [[[NSNumberFormatter new] numberFromString:_totalColorsLabel.text] integerValue];
}

- (void)setTotalColors:(NSInteger)totalColors {
    _totalColorsLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long) totalColors];
}

@end
