//
//  WMBCreditCardDisclaimer.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 02/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardDisclaimer.h"

@implementation WBRCreditCardDisclaimer

- (void)awakeFromNib {
    [super awakeFromNib];
    self.disclaimerView.layer.cornerRadius = 4.0f;
    self.disclaimerView.layer.masksToBounds = YES;
}

+ (NSString *)reuseIdentifier {
    return @"WBRCreditCardDisclaimer";
}


@end
