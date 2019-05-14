//
//  WBRProductManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 19/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProductManager.h"
#import "WBRConnection.h"
#import "ProductUrls.h"
#import "NSError+CustomError.h"

@implementation WBRProductManager

+ (void)getProductDescriptionWithProductId:(NSString *)productId successBlock:(void (^)(NSString *))successBlock failureBlock:(kProductManagerFailureBlock)failureBlock {

    LogInfo(@"[WBRProductManager] getProductDescriptionWithProductId:productId:successBlock:failureBlock: %@", productId);

    NSString *urlString = [NSString stringWithFormat:@"%@/product/%@/description", URL_PRODUCT_DETAIL, productId];
    
    [[WBRConnection sharedInstance] GET:urlString headers:[self headersDict] authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        if (data.length > 0){
            NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (successBlock)
                successBlock(htmlString);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        failureBlock(error);
    }];
}

+ (void)getProductSpecificationWithProductId:(NSString *)productId successBlock:(void (^)(NSString *))successBlock failureBlock:(kProductManagerFailureBlock)failureBlock {

    LogInfo(@"[WBRProductManager] getProductSpecificationWithProductId:productId:successBlock:failureBlock: %@", productId);
    NSString *urlString = [NSString stringWithFormat:@"%@/product/%@/specification", URL_PRODUCT_DETAIL, productId];
    
    [[WBRConnection sharedInstance] GET:urlString headers:[self headersDict] authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        if (data.length > 0){
            NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (successBlock)
                successBlock(htmlString);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        failureBlock(error);
    }];
}

+ (void)getExtendedWarrantyLicenseWithSuccessBlock:(kProductManagerGetExtendedWarrantySuccessBlock)successBlock failureBlock:(kProductManagerGetExtendedWarrantyFailureBlock)failureBlock {
    
    NSString *url = [[OFUrls new] getURLExtendedWarrantyLicense];
    
    [[WBRConnection sharedInstance] GET:url successBlock:^(NSURLResponse *response, NSData *data) {
        
        NSString *warrantyResponse = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
        
        if (successBlock) {
            successBlock(warrantyResponse);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        
        NSString *errorMessage = @"";
        if (error.code == 1009) {
            errorMessage = ERROR_CONNECTION_INTERNET;
        }
        else {
            errorMessage = [[OFMessages new] extendedWarrantyLicenseErrorMessage];
        }
        
        if (failureBlock) {
            failureBlock(errorMessage);
        }
    }];
}

+ (void)getExtendedWarrantyDescriptionWithSuccessBlock:(kProductManagerGetExtendedWarrantySuccessBlock)successBlock failureBlock:(kProductManagerGetExtendedWarrantyFailureBlock)failureBlock {
    
    NSString *url = URL_NEW_EXTENDED_WARRANTY;
    
    [[WBRConnection sharedInstance] GET:url successBlock:^(NSURLResponse *response, NSData *data) {
        
        NSString *warrantyResponse = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
        
        if (successBlock) {
            successBlock(warrantyResponse);
        }
        
    } failureBlock:^(NSError *error, NSData *failureData) {
    
        [self logGetExtendedWarrantyDescriptionWithError:error failureData:failureData forURL:url];
        error = [self getExtendedWarrantyDescriptionErrorWithError:error];
        if (failureBlock) {
            failureBlock(error.localizedDescription);
        }
    }];
}

+ (void)notifyUser:(NSString *)username withEmail:(NSString *)email forProductSku:(NSString *)productSKU successBlock:(kProductManagerNotifyMeSuccessBlock)successBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/notify", URL_NOTIFY, productSKU];
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"cache-control": @"no-cache",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    NSDictionary *body = @{
                           @"name": username,
                           @"email": email
                           };
    
    [[WBRConnection sharedInstance] POST:url headers:headersDictionary body:body authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        if (successBlock) {
            successBlock(YES);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        if(successBlock) {
            successBlock(NO);
        }
    }];
}

+ (NSDictionary *)headersDict {
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    return headersDictionary;
}

#pragma mark - Log

+ (void)logGetExtendedWarrantyDescriptionWithError:(NSError *)error failureData:(NSData *)data forURL:(NSString *)url {

    if (data.length > 0) {
        
        if (error.code == 400) {
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                       @"message"      :   file,
                                       @"method"       :   @"getProductSpecification:",
                                       @"screen"       :   @"productDetail-specification"}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:file andUserMessage:ERROR_UNKNOWN_CATEGORY andScreen:@"WMProdDetailViewController" andFragment:@"getProductSpecification:"];
        }
        else if (error.code != 200) {
            [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                       @"message"      :   error.description,
                                       @"method"       :   @"getProductSpecification:",
                                       @"screen"       :   @"productDetail-specification"}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:error.description andUserMessage:ERROR_UNKNOWN_CATEGORY andScreen:@"WMProdDetailViewController" andFragment:@"getProductSpecification:"];
        }
    }
    else if (error != nil) {
        
        if (error.code == 1009) {
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"" andFragment:@"getProductSpecification:"];
        }
        else {
            [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                       @"message"         :   error.description,
                                       @"method"          :   @"getProductSpecification:"}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:error.description andUserMessage:@"" andScreen:@"WMProdDetailViewController" andFragment:@"getProductSpecification:"];
        }
    }
}

#pragma mark - Error

+ (NSError *)getExtendedWarrantyDescriptionErrorWithError:(NSError *)error {
    
    if (error.code == 408) {
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_TIMEOUT];
    }
    else if (error.code == 1009) {
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INTERNET];
    }
    else if (error.code == 400) {
        error = [NSError errorWithCode:error.code message:ERROR_UNKNOWN_CATEGORY];
    }
    else {
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_UNKNOWN];
    }
    
    return error;
}

@end
