//
//  MyAddressesConnection.m
//  Walmart
//
//  Created by Renan on 5/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "MyAddressesConnection.h"

#import "Reachability.h"
#import "AddressModel.h"
#import "ZipCodeModel.h"
#import "OFSetup.h"

@implementation MyAddressesConnection

- (void)addAddress:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLMyAddresses]];
    LogURL(@"Add address url: %@", [url description]);
    
    NSDictionary *addressDictionary = address.toDictionary;
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:addressDictionary];
    NSString *numberAddress = [mutDict objectForKey:@"number"];
    numberAddress = [numberAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    [mutDict setObject:numberAddress forKey:@"number"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:nil];
    
    NSString *strPostData = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    LogInfo(@"Add address content: \n\n%@\n\n", strPostData);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        if (success) success();
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure(error);
    }];
}

- (void)updateAddress:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLMyAddresses]];
    LogURL(@"Update address url: %@", [url description]);
    
    NSDictionary *addressDictionary = address.toDictionary;
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:addressDictionary];
    NSString *numberAddress = [mutDict objectForKey:@"number"];
    numberAddress = [numberAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    [mutDict setObject:numberAddress forKey:@"number"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        if (success) success();
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure(error);
    }];
}

- (void)loadMyAddressesWithCompletionBlock:(void (^)(NSArray *addresses, NSTimeInterval executionTime))success failure:(void (^)(NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLMyAddresses]];
    LogURL(@"Get my addresses url: %@", [url description]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDate *Start_Time_OF_Method = [NSDate date];
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSArray *jsonArray = [json objectForKey:@"addresses"];
        NSMutableArray *addressesMutable = [NSMutableArray new];
        for (NSDictionary *addressDict in jsonArray) {
            NSError *parseError;
            AddressModel *address = [[AddressModel alloc] initWithDictionary:addressDict error:&parseError];
            if (parseError) {
                continue;
            }
            else {
                [addressesMutable addObject:address];
            }
        }
        
        NSDate *Finish_Time_OF_Method = [NSDate date];
        NSTimeInterval executionTime = [Finish_Time_OF_Method timeIntervalSinceDate:Start_Time_OF_Method];
        if (success) success(addressesMutable.copy, executionTime);
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure(error);
    }];
}

- (void)deleteAddressWithAddressId:(NSString *)addressId completionBlock:(void (^)())success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLMyAddresses]];
    url = [url URLByAppendingPathComponent:addressId];
    
    LogURL(@"Delete address url: %@", url.description);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"DELETE"];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } failure:^(NSError *error, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(error);
        });
    }];
}

- (void)setAddressAsDefaultWithAddressId:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLMyAddresses]];
    LogURL(@"Update address url: %@", [url description]);

    address.defaultAddress = [NSNumber numberWithBool:YES];

    NSDictionary *addressDictionary = address.toDictionary;
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:addressDictionary];
    NSString *numberAddress = [mutDict objectForKey:@"number"];
    numberAddress = [numberAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    [mutDict setObject:numberAddress forKey:@"number"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        if (success) success();
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure(error);
    }];
}

- (void)getZipCodeData:(NSString *)zipCode completionBlock:(void (^)(ZipCodeModel *))success failure:(void (^)(NSString *))failure
{
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLZipInfo]];
    url = [url URLByAppendingPathComponent:zipCode];
    LogURL(@"Get zipcode info url: %@", [url description]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSDictionary *jsonDict = [json objectForKey:@"zipcode"];
        NSError *parseError;
        ZipCodeModel *zipCode = [[ZipCodeModel alloc] initWithDictionary:jsonDict error:&parseError];
        if (parseError) {
            if (failure) failure(REQUEST_ERROR);
        }
        else {
            if (success) success(zipCode);
        }
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure(REQUEST_ERROR);
    }];
}

@end
