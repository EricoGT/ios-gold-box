//
//  WBRContactRequestPaymentModel.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactRequestPaymentModel.h"

@implementation WBRContactRequestPaymentModel

- (kExchangePaymentType)paymentType {
    
    if ([self.method caseInsensitiveCompare:@"credit"] == NSOrderedSame) {
        return kExchangePaymentTypeCreditCard;
    }
    
    return kExchangePaymentTypeBankSlip;
}

@end
