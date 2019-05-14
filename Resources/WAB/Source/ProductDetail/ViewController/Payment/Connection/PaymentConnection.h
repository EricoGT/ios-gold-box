//
//  PaymentConnection.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/18/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"
#import "PaymentForms.h"

@interface PaymentConnection : WMBaseConnection <NSURLConnectionDataDelegate>

@property (nonatomic) NSURLConnection   *paymentConnection;

//@property (nonatomic) Payment *paymentResult;

- (void)getPaymentFormsWithSku:(NSString *)standardSku andPrice:(NSString*)price completionBlock:(void (^)(PaymentForms *payment))success failureBlock:(void (^)(NSError *error))failure;

@end
