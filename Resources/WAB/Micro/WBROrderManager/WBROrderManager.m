//
//  WBROrderManager.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/22/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBROrderManager.h"


#import "OFLogService.h"
#import "WBRConnection.h"

#import "NSError+CustomError.h"

@implementation WBROrderManager

+ (void)getBankSlipWithOrder:(NSString *)orderNumber successBlock:(kOrderManagerRequestBankSlipSuccessBlock)successBlock failureBlock:(kOrderManagerRequestBankSlipFailureBlock)failureBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", URL_BANKING_SLIP, orderNumber];
    
    NSString *tkUs = [[NSUserDefaults standardUserDefaults] stringForKey:@"tkBankSlip"] ?: @"";
    
    NSMutableDictionary *headersDictionary = [[NSMutableDictionary alloc] init];
    if (tkUs.length > 0) {
        [headersDictionary setObject:tkUs forKey:@"token"];
    }
    else {
        NSError *error = [NSError errorWithCode:401 message:@""];
        error = [self getBankSlipErrorWithError:error];
        [self logBankSlipError:error forURL:url withData:nil];
        
        if (failureBlock) {
            failureBlock(error);
        }
        
        return;
    }
    
    [[WBRConnection sharedInstance] GET:url headers:headersDictionary authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        NSString *bankingSlipString = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
        NSDictionary *responseDictionary = @{@"bankSlip": bankingSlipString};
        
        if (successBlock) {
            successBlock(responseDictionary);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        [self logBankSlipError:error forURL:url withData:failureData];
        error = [self getBankSlipErrorWithError:error];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)logBankSlipError:(NSError *)error forURL:(NSString *)url withData:(NSData *)data {
    
    if (error.code == 401) {
        
        [FlurryWM logEvent_error:@{@"response_code":    @"TOKEN MISSED",
                                   @"message"      :    @"TOKEN MISSED",
                                   @"method"       :    @"getBankingSlipWithOrder:"}];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:@"" andResponseData:@"TOKEN MISSED" andUserMessage:@"" andScreen:@"WMConnection" andFragment:@"getBankingSlipWithOrder:"];
    }
    else if (error.code == 1009) {
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_BANKSLIP_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:@"" andResponseData:@"" andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMSuccessViewController" andFragment:@"getBankSlipWithOrder:"];
    }
    else {
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_BANKSLIP_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] andUserMessage:ERROR_BANKING_SLIP_CONNECTION andScreen:@"WMSuccessViewController" andFragment:@"getBankSlipWithOrder:"];
    }
}

+ (NSError *)getBankSlipErrorWithError:(NSError *)error {
    
    if (error.code == 401) {
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INVALID_DATA];
    }
    else if (error.code == 1009) {
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INTERNET];
    }
    
    return error;
}

@end
