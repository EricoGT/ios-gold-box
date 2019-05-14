//
//  WBRUTM.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRUTM.h"

#import "TimeManager.h"
#import "WBRURLHelper.h"
#import "WBRUTMModel.h"

#import "FXKeychain.h"
#import "PSLog.h"

static NSString * const kUTMDeepLinkParameterSource = @"utm_source";
static NSString * const kUTMDeepLinkParameterMedium = @"utm_medium";
static NSString * const kUTMDeepLinkParameterCampaign = @"utm_campaign";

@implementation WBRUTM

#pragma mark - Public Methods

+ (void)handleDeepLink:(NSString *)deepLinkURL {
    
    NSDictionary *parameters = [WBRURLHelper getParameterFromDeepLinkURL:deepLinkURL];
    
    if ([self dictionaryContainsUTMParameters:parameters]) {
        
        [self cleanUTMKeys];
        
        [self processUTMDictionary:parameters forDeepLinkKey:kUTMDeepLinkParameterSource keychainKey:kUTMKeychainSource];
        [self processUTMDictionary:parameters forDeepLinkKey:kUTMDeepLinkParameterMedium keychainKey:kUTMKeychainMedium];
        [self processUTMDictionary:parameters forDeepLinkKey:kUTMDeepLinkParameterCampaign keychainKey:kUTMKeychainCampaign];
    }
}

+ (void)updateHourIfNeeded:(NSDate *)newDate {
    
    WBRUTMModel *utmSource = [self UTMForKey:kUTMKeychainSource];
    [self saveUTMIfNeeded:utmSource date:newDate withKey:kUTMKeychainSource];
    
    WBRUTMModel *utmMedium = [self UTMForKey:kUTMKeychainMedium];
    [self saveUTMIfNeeded:utmMedium date:newDate withKey:kUTMKeychainMedium];
    
    WBRUTMModel *utmCampaign = [self UTMForKey:kUTMKeychainCampaign];
    [self saveUTMIfNeeded:utmCampaign date:newDate withKey:kUTMKeychainCampaign];
}

+ (BOOL)invalidateUTMs {
    
    BOOL result = YES;
    
    if (![self invalidateUTMWithKey:kUTMKeychainSource]) {
        result = NO;
    }
    if (![self invalidateUTMWithKey:kUTMKeychainMedium]) {
        result = NO;
    }
    if (![self invalidateUTMWithKey:kUTMKeychainCampaign]) {
        result = NO;
    }
    
    return result;
}

+ (NSDictionary *)addUTMHeaderTo:(NSURL *)url {
    
    NSMutableDictionary *utmHeader = [[NSMutableDictionary alloc] init];
    ModelServices *services = [WALMenuViewController singleton].services;
    
    if ([self HeaderShouldAddUTMParameters:url] && services.showUtm.boolValue) {
        
        if ([WBRUTM getUTMForKey:kUTMKeychainMedium] != nil) {
            [utmHeader setObject:[WBRUTM getUTMForKey:kUTMKeychainMedium].UTMValue forKey:kUTMDeepLinkParameterMedium];
        }
        
        if ([WBRUTM getUTMForKey:kUTMKeychainSource] != nil) {
            [utmHeader setObject:[WBRUTM getUTMForKey:kUTMKeychainSource].UTMValue forKey:kUTMDeepLinkParameterSource];
        }
        
        if ([WBRUTM getUTMForKey:kUTMKeychainCampaign] != nil) {
            [utmHeader setObject:[WBRUTM getUTMForKey:kUTMKeychainCampaign].UTMValue forKey:kUTMDeepLinkParameterCampaign];
        }
        
    }
    
    return utmHeader;
}

+ (NSURL *)addUTMQueryParameterTo:(NSURL *)url {
    
    NSURL *urlWithUTM = url;
    ModelServices *services = [WALMenuViewController singleton].services;
    
    if ([self URLShouldAddUTMParameters:url] && services.showUtm.boolValue) {
        
        NSString *utmQueryString = url.absoluteString;
        
        utmQueryString = [self getFormattedURLWithQueryStringWithURL:utmQueryString andUTM:[self getUTMQueryStringByKey:kUTMKeychainSource withURLParameter:kUTMDeepLinkParameterSource] ];
        
        utmQueryString = [self getFormattedURLWithQueryStringWithURL:utmQueryString andUTM:[self getUTMQueryStringByKey:kUTMKeychainMedium withURLParameter:kUTMDeepLinkParameterMedium]];
        
        utmQueryString = [self getFormattedURLWithQueryStringWithURL:utmQueryString andUTM:[self getUTMQueryStringByKey:kUTMKeychainCampaign withURLParameter:kUTMDeepLinkParameterCampaign]];
    
        urlWithUTM = [NSURL URLWithString:utmQueryString];
        
    }
    
    return urlWithUTM;
}

+ (NSString *)urlWithoutUTMParameters:(NSString *)url {
    
    NSString *resultURL = url;
    
    while ([resultURL rangeOfString:@"utm"].location != NSNotFound) {
        
        NSRange utmRange = [resultURL rangeOfString:@"utm"];
        
        NSString *stringParameters = [resultURL substringFromIndex:utmRange.location];
        
        NSRange nextAmphersandRange = [stringParameters rangeOfString:@"&"];
        
        NSInteger utmKeyAndValueSize;
        if (nextAmphersandRange.location != NSNotFound) {
            utmKeyAndValueSize =  nextAmphersandRange.location + 1;
        }
        else {
            
            utmKeyAndValueSize = stringParameters.length;
            
            if ([resultURL characterAtIndex:utmRange.location-1] == '&') {
                utmKeyAndValueSize ++;
                utmRange.location --;
            }
        }
        
        utmRange.length = utmKeyAndValueSize;
        
        resultURL = [resultURL stringByReplacingCharactersInRange:utmRange withString:@""];
    }
    
    return resultURL;
}

+ (WBRUTMModel *)getUTMForKey:(NSString *)key {
    return [self UTMForKey:key];
}

#pragma mark - Private Methods

+ (void)cleanUTMKeys {
    
    [self removeUTMKeyFromKeychain:kUTMKeychainSource];
    [self removeUTMKeyFromKeychain:kUTMKeychainMedium];
    [self removeUTMKeyFromKeychain:kUTMKeychainCampaign];
}

+ (BOOL)dictionaryContainsUTMParameters:(NSDictionary<NSString *, NSString *> *)dictionary {
    
    __block BOOL hasUTMKey = NO;
    [dictionary.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj lowercaseString] containsString:@"utm"]) {
            hasUTMKey = YES;
            *stop = YES;
        }
    }];
    
    return hasUTMKey;
}

+ (BOOL)URLShouldAddUTMParameters:(NSURL *)url {
    NSArray *urlsToCheck = @[@"/navigation/home/dynamic",
                              @"/navigation/home/static",
                              @"/wishList/skus",
                              @"/list/wishlist",
                              @"/navigation/product",
                              @"/navigation/sku",
                              @"/cart/addAllProducts/seller",
                              @"/checkout/track",
                              @"/cart/updateCart",
                              @"/checkout/freight",
                              @"/cart/loadCart",
                              @"/cart/findGroupedCart",
                              @"/cart/selectDeliveryPaymentWithCompleteCart",
                              @"/checkout/installments",
                              @"/order",
                              @"/navigation/sku",
                              @"/cart/removeProduct"];
    
    BOOL shouldAdd = NO;
    
    for (NSString *urlToCheck in urlsToCheck) {
        if ([url.absoluteString localizedCaseInsensitiveContainsString:urlToCheck]) {
            shouldAdd = YES;
            break;
        }
    }
    
    return shouldAdd;
}

+ (BOOL)HeaderShouldAddUTMParameters:(NSURL *)url {
    NSArray *urlsToCheck = @[@"/navigation/search"];
    
    BOOL shouldAdd = NO;
    
    for (NSString *urlToCheck in urlsToCheck) {
        if ([url.absoluteString localizedCaseInsensitiveContainsString:urlToCheck]) {
            shouldAdd = YES;
            break;
        }
    }
    
    return shouldAdd;
}

+ (NSString *)getUTMQueryStringByKey:(NSString *)utmKey withURLParameter:(NSString *)urlParameter {
    
    NSString *utmQueryString = @"";
    WBRUTMModel *utmModel = [self UTMForKey:utmKey];
    
    if (utmModel && [TimeManager UTMDateStillValid:utmModel.savedDate]) {
        
        utmQueryString = [NSString stringWithFormat:@"%@=%@", urlParameter, utmModel.UTMValue];
    }
    
    return utmQueryString;
}

+ (NSString *)getFormattedURLWithQueryStringWithURL:(NSString *)url andUTM:(NSString *)utm {
    
    NSString *urlWithQueryString = url;
    
    if (urlWithQueryString && urlWithQueryString.length > 0 && utm && utm.length > 0) {
        
        if ([url containsString:@"?"]) {
            urlWithQueryString = [NSString stringWithFormat:@"%@&%@", url, utm];
        } else {
            urlWithQueryString = [NSString stringWithFormat:@"%@?%@", url, utm];
        }
    }
    
    return urlWithQueryString;
}

+ (BOOL)invalidateUTMWithKey:(NSString *)UTMkey {
    
    WBRUTMModel *utmSource = [self UTMForKey:UTMkey];
    
    BOOL result = YES;
    
    if (utmSource) {
        
        if (utmSource.savedDate) {
            NSDate *invalidDate = [TimeManager invalidateUTMDate:utmSource.savedDate];
            utmSource.savedDate = invalidDate;
            result = [self saveUTMKey:UTMkey withUTMModel:utmSource];
        }
    }
    
    return result;
}

+ (void)saveUTMIfNeeded:(WBRUTMModel *)utm date:(NSDate *)newDate withKey:(NSString *)key {
    
    if (utm.savedDate == nil) {
        utm.savedDate = newDate;
        [self saveUTMKey:key withUTMModel:utm];
    }
}

+ (void)processUTMDictionary:(NSDictionary *)parametersDictionary forDeepLinkKey:(NSString *)deepLinkKey keychainKey:(NSString *)keychainKey {
    
    if ([parametersDictionary objectForKey:deepLinkKey]) {
        NSString *value = [parametersDictionary objectForKey:deepLinkKey];
        WBRUTMModel *UTMModel = [[WBRUTMModel alloc] initWithUTMValue:value];
        
        BOOL result = [self saveUTMKey:keychainKey withUTMModel:UTMModel];
        if (!result) {
            LogInfo(@"WBRUTM: UTM error to save: %@ \t Value: %@ \t Date:%@", keychainKey, UTMModel.UTMValue, UTMModel.savedDate);
        }
        else {
            LogInfo(@"WBRUTM: UTM saved: %@ \t Value: %@ \t Date:%@", keychainKey, UTMModel.UTMValue, UTMModel.savedDate);
        }
    }
}

+ (NSArray<WBRUTMModel *> *)allUTMsSaved {
    
    NSMutableArray<WBRUTMModel *> *UTMsSaved = [[NSMutableArray alloc] init];
    
    WBRUTMModel *UTMSource = [self UTMForKey:kUTMKeychainSource];
    if (UTMSource) {
        [UTMsSaved addObject:UTMSource];
    }
    WBRUTMModel *UTMMedium = [self UTMForKey:kUTMKeychainMedium];
    if (UTMMedium) {
        [UTMsSaved addObject:UTMMedium];
    }
    WBRUTMModel *UTMCampaign = [self UTMForKey:kUTMKeychainCampaign];
    if (UTMCampaign) {
        [UTMsSaved addObject:UTMCampaign];
    }
    
    return UTMsSaved;
}

#pragma mark Keychain access

+ (FXKeychain *)keychain {
    return [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
}

+ (BOOL)removeUTMKeyFromKeychain:(NSString *)key {
    return [WBRUTM.keychain removeObjectForKey:key];
}

+ (BOOL)saveUTMKey:(NSString *)key withUTMModel:(WBRUTMModel *)UTMModel {
    
    BOOL result = NO;
    
    if (UTMModel &&
        UTMModel.UTMValue != nil &&
        ![UTMModel.UTMValue isEqualToString:@""]) {
        
        result = [WBRUTM.keychain setObject:UTMModel forKey:key];
    }
    
    return result;
}

+ (WBRUTMModel *)UTMForKey:(NSString *)key {
    
    WBRUTMModel *UTMSaved = (WBRUTMModel *)[WBRUTM.keychain objectForKey:key];
    LogInfo(@"WBRUTM: %@ %@ \t Date:%@ \t Valid:%d", key,UTMSaved.UTMValue, UTMSaved.savedDate, UTMSaved.valid);
    return UTMSaved;
}

@end
