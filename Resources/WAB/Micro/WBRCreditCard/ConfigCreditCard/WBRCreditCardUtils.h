//
//  WBRCreditCardConstants.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 11/09/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMastercardString;
extern NSString * const kHipercardString;
extern NSString * const kAmexString;
extern NSString * const kVisaString;

@interface WBRCreditCardUtils : NSObject

+ (BOOL)isPaymentTypesEnableStamp:(NSArray *)paymentTypes;

@end
