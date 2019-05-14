//
//  WBRHomeManager.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/23/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRHomeManager.h"
#import "ErrorConnectionmanager.h"
#import "HomeUrls.h"
#import "TimeManager.h"
#import "WBRUTM.h"
#import "WishlistInteractor.h"
#import "WBRRetargeting.h"
#import "WBRConnection.h"
#import "NSError+CustomError.h"

static ModelStaticHome *modelStaticHome;
static ModelCampaigns *modelCampaigns;
static NSArray <ModelShowcases> *modelShowcases;

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm

#define USE_MOCK_HOME_STATIC YES
#define USE_MOCK_HOME_DYNAMIC YES

#else

#define USE_MOCK_HOME_STATIC NO
#define USE_MOCK_HOME_DYNAMIC NO

#endif
// ---------------------------------------------------

@implementation WBRHomeManager


+ (void)loadStaticHomeWithSuccessBlock:(void (^)(HomeModel *))successBlock failureBlock:(void (^)())failureBlock {
    
    LogInfo(@"[HOME] loadStaticHomeWithSuccessBlock");
    
    [self getHomeStaticOriginal:^(NSData *dataJson) {
        
        //Transform data from server to mutable
        NSMutableDictionary *dictJsonTemp = [NSJSONSerialization JSONObjectWithData:dataJson options:kNilOptions error:nil];
        
        NSMutableDictionary *dictJson = [NSMutableDictionary dictionaryWithDictionary:dictJsonTemp];
        
        //Inject special showcase for automation tests
        if (USE_MOCK_HOME_STATIC) {
            //Showcase QA
            NSMutableArray *arrMutShowcases = [NSMutableArray arrayWithArray:[dictJson objectForKey:@"showcases"]];
            
            //Get content of mock file
            NSString *filePathMockStaticHome = [[NSBundle mainBundle] pathForResource:@"testHomeShowcase" ofType:@"json"];
            NSString *content = [NSString stringWithContentsOfFile:filePathMockStaticHome
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
            NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
            //Get dictionary from file data
            NSDictionary *showcaseTestJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSArray *arrShowcaseTest = [showcaseTestJSON objectForKey:@"showcases"];
            NSDictionary *dictShowcaseTest = [arrShowcaseTest objectAtIndex:0];
            
            [arrMutShowcases addObject:dictShowcaseTest];
            
            //Showcase iOS
            //Get content of mock file
            NSString *filePathMockStaticHomeIos = [[NSBundle mainBundle] pathForResource:@"iOSHomeShowcase" ofType:@"json"];
            NSString *contentIos = [NSString stringWithContentsOfFile:filePathMockStaticHomeIos
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
            NSData* dataIos = [contentIos dataUsingEncoding:NSUTF8StringEncoding];
            //Get dictionary from file data
            NSDictionary *showcaseTestJSONIos = [NSJSONSerialization JSONObjectWithData:dataIos options:kNilOptions error:nil];
            
            NSArray *arrShowcaseTestIos = [showcaseTestJSONIos objectForKey:@"showcases"];
            NSDictionary *dictShowcaseTestIos = [arrShowcaseTestIos objectAtIndex:0];
            
            [arrMutShowcases addObject:dictShowcaseTestIos];
            
            [dictJson setObject:arrMutShowcases forKey:@"showcases"];
        }
        
        NSError *parserError;
        //HomeModel *home = [[HomeModel alloc] initWithData:dataJson error:&parserError];
        HomeModel *home = [[HomeModel alloc] initWithDictionary:dictJson error:&parserError];
        
        if (successBlock) successBlock(home);
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) failureBlock();
        });
    }];
}

+ (void)loadDynamicHomeWithSuccessBlock:(void (^)(NSArray *))successBlock failureBlock:(void (^)())failureBlock {
    
    LogInfo(@"[HOME] loadDynamicHomeWithSuccessBlock");
    
    [self getHomeDynamicOriginal:^(NSData *dataJson) {
        
        //Transform data from server to mutable
        NSDictionary *dictJsonTemp = [NSJSONSerialization JSONObjectWithData:dataJson options:kNilOptions error:nil];
        
        NSDictionary *dictJson = [NSMutableDictionary dictionaryWithDictionary:dictJsonTemp];
        
        NSArray *dynamicShowcasesDicts = dictJson[@"showcases"];
        NSError *parserError;
        NSArray *dynamicShowcases = [ShowcaseModel arrayOfModelsFromDictionaries:dynamicShowcasesDicts error:&parserError];
        
        if (!parserError)
        {
            for (ShowcaseModel *showcase in dynamicShowcases) {
                showcase.dynamic = YES;
            }
            [WishlistInteractor assignWishlistStatusToShowcases:dynamicShowcases];
            
            if (successBlock) {
                successBlock(dynamicShowcases);
            }
        }
        
        
    } failure:^(NSError *error) {
        
        if (failureBlock) {
            failureBlock();
        }
    
    }];
}

/**
 Track product to retargeting
 
 @param Array of showcases ids.
 */
+ (void)registerShowcases:(NSArray *)showcases {
    
    for (ShowcaseModel *showcase in showcases) {
        
        NSString *typeShowcase = showcase.type;
        
        if ([typeShowcase.lowercaseString isEqualToString:@"retargeting"] && showcase.products.count > 0) {
            LogRtg(@"[RETARGETING] ID Showcase: %@", showcase.showcaseId);
            
            NSString *strParam = [NSString stringWithFormat:@"/webevent/pageaction.gif?PageType=Home&Event=viewShelfProduct&Action=VIEW&Source=%@&Sku=undefined&Position=undefined&Shelf=%@&ShelfPosition=-1", showcase.showcaseId, showcase.showcaseId];
            
            
            [[WBRRetargeting new] retargetingShowcases:[NSString stringWithFormat:@"%@%@", RETARGETING_TRACKING_URL, strParam] success:^(NSHTTPURLResponse *httpResponse) {
                LogRtg(@"[RETARGETING] Success: %@", httpResponse);
            } failure:^(NSDictionary *dictError) {
                LogErro(@"[RETARGETING] Error: %@", dictError);
            }];
        }
    }
}

+ (void) getHomeStaticOriginal:(void (^)(NSData *dataJson))success failure:(void (^)(NSError *error))failure {
    
    LogInfo(@"[HOME] getHomeStaticOriginal");
    
    if (USE_MOCK_HOME_STATIC) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"staticHome" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Static Home: %@", dictJson);
        
        //Send to model
        NSError *error = nil;
        
        if (!error) {
            success (jsonData);
        }
        else {
            failure ([NSError errorWithMessage:ERROR_PARSE_DATABASE]);
        }
        
    } else {
        
        [self requestHomeContentWithUrl:URL_HOME_STATIC isDynamic:NO success:^(NSData *data, NSHTTPURLResponse *httpResponse) {
            
            //            [TimeManxager assignTimeHomeStatic];
            
            if (success) {
                success (data);
            }
            
        } failure:^(NSError *error) {
            
            if (failure) {
                failure (error);
            }
        }];
    }
}


+ (void) getHomeDynamicOriginal:(void (^)(NSData *dataJson))success failure:(void (^)(NSError *error))failure {
    
    LogInfo(@"[HOME] getHomeDynamicOriginal");
    
    if (USE_MOCK_HOME_DYNAMIC) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dynamicHome" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Dynamic Home: %@", dictJson);
        
        //Send to model
        NSError *error = nil;
        
        if (!error) {
            success(jsonData);
        } else {
            failure([NSError errorWithMessage:ERROR_PARSE_DATABASE]);
        }
        
    } else {
        
        [self requestHomeContentWithUrl:URL_HOME_DYNAMIC isDynamic:YES success:^(NSData *data, NSHTTPURLResponse *httpResponse) {
            
            if (success) {
                success (data);
            }
            
        } failure:^(NSError *error) {
            
            if (failure) {
                failure (error);
            }
        }];
    }
}

+ (void)requestHomeContentWithUrl:(NSString *) strUrl isDynamic:(BOOL) dynamicHome success:(void (^)(NSData *data, NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSError *error))failure {
    
    LogInfo(@"[HOME] requestHomeContentWithUrl: %@ isDynamic: %@", strUrl, [NSNumber numberWithBool:dynamicHome]);
    
    NSString *previousMethod = [self getCallerStackSymbol];
    LogMicro(@"Previous Method: %@", previousMethod);
    
    NSURL *url = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:strUrl]];
    LogURL(@"Url: %@", url.absoluteString);
    
    NSMutableDictionary *dictHeaderMutable = [[NSMutableDictionary alloc] init];
    
    if (dynamicHome) {
        NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        if (deviceId.length > 0) {
            
            [dictHeaderMutable setValue:deviceId forKey:@"deviceid"];
        }
        
        if (deviceId.length == 0) {
            
            NSError *error = [NSError errorWithMessage:@"Device Id is null"];
            LogMicro(@"[%@] DictError: %@", previousMethod, error);
            failure (error);
            
            return;
        }
    }
    
    [[WBRConnection sharedInstance] GET:[url absoluteString]
                                headers:[NSDictionary dictionaryWithDictionary:dictHeaderMutable]
                    authenticationLevel:kAuthenticationLevelOptional
                           successBlock:^(NSURLResponse *response, NSData *data) {
                               
                               if (data) {
                                   //Transform data from server to NSDictionary
                                   NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   LogInfo(@"[REQUEST %@] Home: %@", previousMethod, dictJson);
                               }
                               
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                               [TimeManager updateServerDateWithResponse:httpResponse];
                        
                               if (success) {
                                   success(data, httpResponse);
                               }
                           }
                           failureBlock:^(NSError *error, NSData *failureData) {
                               
                               LogMicro(@"[%@] DictError: %@", previousMethod, error);
                               
                               if (failure) failure (error);
                           }];
    
}

+ (NSString *)getCallerStackSymbol {
    
    NSString *callerStackSymbol = @"Could not track caller stack symbol";
    
    NSArray *stackSymbols = [NSThread callStackSymbols];
    if(stackSymbols.count >= 2) {
        callerStackSymbol = [stackSymbols objectAtIndex:2];
        if(callerStackSymbol) {
            NSMutableArray *callerStackSymbolDetailsArr = [[NSMutableArray alloc] initWithArray:[callerStackSymbol componentsSeparatedByString:@" "]];
            NSUInteger callerStackSymbolIndex = callerStackSymbolDetailsArr.count - 3;
            if (callerStackSymbolDetailsArr.count > callerStackSymbolIndex && [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex]) {
                callerStackSymbol = [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex];
                callerStackSymbol = [callerStackSymbol stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
        }
    }
    
    return callerStackSymbol;
}


@end
