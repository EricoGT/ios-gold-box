//
//  PaymentConnection.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/18/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "PaymentConnection.h"

//#define timeoutRequest 50.0f

@implementation PaymentConnection

- (void)getPaymentFormsWithSku:(NSString *)standardSku andPrice:(NSString*)price completionBlock:(void (^)(PaymentForms *payment))success failureBlock:(void (^)(NSError *error))failure {
    LogInfo(@"loadPayments sku: %@ and price: %@", standardSku ,price);
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@sku/%@/price/%@?showBankSlip=true",[[OFUrls new] getURLPayments], standardSku, price]]];
    req.timeoutInterval = timeoutRequest;
    
    LogInfo(@" > %@", req.URL);
    
    [self run:req authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSError *paymentsParserError;
        PaymentForms *payment = [[PaymentForms alloc] initWithDictionary:json error:&paymentsParserError];
        if (payment) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(payment);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure([self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
            });
        }
    } failure:^(NSError *error, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure([self errorWithMessage:ERROR_CONNECTION_DATA]);
        });
    }];
}

@end
