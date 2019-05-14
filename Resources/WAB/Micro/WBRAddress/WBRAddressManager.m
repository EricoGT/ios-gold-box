//
//  WBRAddressManager.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRAddressManager.h"

#import "WBRConnection.h"
#import "WBRUTM.h"
#import "NSError+CustomError.h"

@implementation WBRAddressManager

#pragma mark - Rest Methods

+ (void)newAddress:(WBRCheckoutAddressModel *)addressModel successBlock:(kAddressManagerSuccessBlock)successBlock failureBlock:(kAddressManagerFailureBlock)failureBlock {
    
    NSDictionary *infosDictionary = [addressModel toDictionary];
    LogInfo(@"[WBRAddressManager] newAddressWithDictionary:successBlock:failureBlock: %@", infosDictionary);
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    
    NSString *newAddressURL = [[OFUrls new] getURLNewAddress];
    
    [[WBRConnection sharedInstance] POST:newAddressURL headers:headersDictionary body:infosDictionary authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        LogInfo(@"[WBRAddressManager] newAddressWithDictionary:successBlock:failureBlock: successBlock");
        
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
    
        LogInfo(@"[WBRAddressManager] newAddressWithDictionary:successBlock:failureBlock: failureBlock");
        NSError *addressError = [self addAddressErrorWithError:error];
        
        if (failureBlock) {
            failureBlock(addressError);
        }
    }];
}

+ (void)updateAddress:(WBRCheckoutAddressModel *)addressModel forAddressId:(NSString *)addressId successBlock:(kAddressManagerSuccessBlock)successBlock failureBlock:(kAddressManagerFailureBlock)failureBlock {
    
    NSDictionary *infosDictionary = [addressModel toDictionary];
    LogInfo(@"[WBRAddressManager] updateAddress:forAddressId:successBlock:failureBlock: %@", infosDictionary);
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    
    NSString *updateAddressURL = [[[OFUrls new] getURLUpdateAddress] stringByAppendingString:addressId];
    [[WBRConnection sharedInstance] PUT:updateAddressURL headers:headersDictionary body:infosDictionary authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        LogInfo(@"[WBRAddressManager] updateAddress:forAddressId:successBlock:failureBlock: successBlock");
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        LogInfo(@"[WBRAddressManager] updateAddress:forAddressId:successBlock:failureBlock: failureBlock");
        NSError *addressError = [self updateAddressErrorWithError:error];
        
        if (failureBlock) {
            failureBlock(addressError);
        }
    }];
}

#pragma mark -

+ (void)getShipmentOptionsForZipcode:(NSString *)zipcode sucessBlock:(kAddressManagerShipmentSuccessBlock)successBlock failureBlock:(kAddressManagerShipmentFailureBlock)failureBlock {
    
    LogInfo(@"[WBRAddressManager] getShipmentOptionsForZipcode:sucessBlock:failureBlock:");
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSString *cartID = [[WMTokens new] getCartId];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"],
                                                                 @"cart": cartID
                                                                 };
    NSDictionary *parameters = @{@"postalCode": zipcode};
    
    NSURL *shipmentOptions = [NSURL URLWithString:[[OFUrls new] getURLFreight]];
    NSString *shipmentOptionsFullURL = [[WBRUTM addUTMQueryParameterTo:shipmentOptions] absoluteString];
    [[WBRConnection sharedInstance] PUT:shipmentOptionsFullURL headers:headersDictionary body:parameters authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
     
        LogInfo(@"[WBRAddressManager] getShipmentOptionsForZipcode:sucessBlock:failureBlock: successBlock");
        
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
       
        if (parseError) {
            NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: ERROR_CONNECTION_CATEGORY};
            NSError *error = [NSError errorWithDomain:@"com.walmart" code:0 userInfo:errorInfo];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        }
        else {
            
            NSNumber *freightPrice = [json objectForKey:@"estimatedBestShippingPrice"];
            if (freightPrice) {
                if (successBlock) {
                    successBlock(freightPrice);
                }
            }
            else {
                NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: ERROR_CONNECTION_CATEGORY};
                NSError *error = [NSError errorWithDomain:@"com.walmart" code:0 userInfo:errorInfo];
                if (failureBlock) {
                    failureBlock(error, nil);
                }
            }
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        LogInfo(@"[WBRAddressManager] getShipmentOptionsForZipcode:sucessBlock:failureBlock: failureBlock");
        
        [FlurryWM logEvent_communication_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                                 @"message"      :   [[NSString alloc] initWithData:failureData encoding:kCFStringEncodingUTF8],
                                                 @"method"       :   @"getShipmentOptionsForZipCode:"}];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", shipmentOptionsFullURL] andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:error.description andUserMessage:@"" andScreen:@"PaymentCardViewController" andFragment:@"getShipmentOptionsForZipCode:"];
        
        if (error.code == 400) {
            
            error = [NSError errorWithCode:error.code message:ERROR_SHIPPING_ROUTE];
        }
        
        if (failureBlock) {
            failureBlock(error, failureData);
        }
    }];
}

#pragma mark - Error

+ (NSError *)addAddressErrorWithError:(NSError *)error {
    
    NSString *errorString = @"";
    
    if (error.code == 401) {
        errorString = ERROR_CONNECTION_AUTH;
    }
    else if (error.code == 1009){
        errorString = ERROR_CONNECTION_INTERNET;
    }
    else {
        errorString = NEW_ADDRESS_ERROR;
    }
    
    NSError *addressError = [NSError errorWithCode:error.code message:errorString];
    
    return addressError;
}

+ (NSError *)updateAddressErrorWithError:(NSError *)error {
    
    NSString *errorString = @"";
    
    if (error.code == 401) {
        errorString = ERROR_CONNECTION_AUTH;
    }
    else if (error.code == 1009) {
        errorString = ERROR_CONNECTION_INTERNET;
    }
    else {
        errorString = UPDATE_ADDRESS_ERROR;
    }
    
    NSError *addressError = [NSError errorWithCode:error.code message:errorString];
    
    return addressError;
}

@end
