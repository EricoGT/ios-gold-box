//
//  WBRSetupManager.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/12/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRSetupManager.h"

#import "ErrorConnectionmanager.h"
#import "TimeManager.h"
#import "WBRConnection.h"
#import "NSError+CustomError.h"
#import "SetupUrls.h"

static ModelSetup *modelSetup;
static ModelAlert *modelAlert;
static ModelBaseImages *modelBaseImages;
static ModelServices *modelServices;
static ModelSkin *modelSkin;
static ModelSplash *modelSplash;
static ModelErrata *modelErrata;
static ModelBanner *modelBanner;
static WBRStampCampaign *modelStampCampaign;
static WBRInstallCampaign *modelInstallCampaign;

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_SETUP YES
#else
#define USE_MOCK_SETUP NO
#endif
// ---------------------------------------------------

@implementation WBRSetupManager

/**
 Provides <b>information about Alert</b>.
 
 @param success Alert Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getAlert:(void (^)(ModelAlert *alertModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelAlert = setupModel.alert;
        if (success) {
            success(modelAlert);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

/**
 Provides <b>information about Base Images</b>.
 
 @param success BaseImages Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getBaseImages:(void (^)(ModelBaseImages *baseImagesModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelBaseImages = setupModel.baseImages;
        if (success) {
            success(modelBaseImages);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

+ (ModelBaseImages *) baseImages {
    
    return modelBaseImages;
}

/**
 Provides <b>information about Services (toggles)</b>.
 
 @param success Services Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getServices:(void (^)(ModelServices *servicesModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelServices = setupModel.services;
        if (success) {
            success(modelServices);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

/**
 Provides <b>information about Skin</b>.
 
 @param success Skin Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getSkin:(void (^)(ModelSkin *skinModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelSkin = setupModel.skin;
        if (success) success(modelSkin);
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

/**
 Provides <b>information about Splash</b>.
 
 @param success Splash Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getSplash:(void (^)(ModelSplash *splashModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelSplash = setupModel.splash;
        if (success) success(modelSplash);
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

/**
 Provides <b>information about Errata</b>.
 
 @param success Error Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getErrata:(void (^)(ModelErrata *errataModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelErrata = setupModel.errata;
        if (success) success(modelErrata);
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

/**
 Provides <b>information about Banners</b>.
 
 @param success Banner Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getBanners:(void (^)(ModelBanner *bannerModel))success failure:(void (^)(NSDictionary *dictError))failure {
    
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        
        modelBanner = setupModel.banners;
        if (success) success(modelBanner);
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
    
}

/**
 Provides <b>whole information about setup</b>.
 
 @param success Setup Model content
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getSetup:(kSetupManagerSuccessBlock)success failure:(kSetupManagerFailureBlock)failure {
    
    BOOL isValidTimeBetweenRequests = [TimeManager shouldMakeRequestSetup];
    
    if (modelSetup && isValidTimeBetweenRequests) {
        success (modelSetup);
    } else {
        
        if (USE_MOCK_SETUP) {
    
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"setup" ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
            //Transform data from server to NSDictionary
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            LogInfo(@"[REQUEST MOCK] Setup: %@", dictJson);
    
            //Send to model
            NSError *error = nil;
            
            ModelSetup *setupModel = [[ModelSetup new] initWithData:jsonData error:&error];
            modelSetup = setupModel;
    
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    if (success) {
                        success (setupModel);
                    }
                } else {
                    if (failure) {
                        NSError *error = [NSError errorWithCode:401 message:ERROR_PARSE_DATABASE];
                        failure (error);
                    }
                }
            });
        } else {
    
            NSString *previousMethod = [WBRSetupManager getCallerStackSymbol];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
            
            NSDictionary *headers = @{
                                      @"content-type": @"application/json",
                                      @"cache-control": @"no-cache",
                                      @"version": version,
                                      @"system": @"iOS"
                                      };
            
            [[WBRConnection sharedInstance] GET:URL_SETUP headers:headers authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {

                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                [TimeManager updateServerDateWithResponse:httpResponse];

                int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
                LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
                
                //Transform data from server to NSDictionary
                NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                LogInfo(@"[REQUEST] Setup: %@", dictJson);
                
                [TimeManager assignTimeSetup];
                
                //Send to model
                NSError *error = nil;
                ModelSetup *setupModel = [[ModelSetup new] initWithData:data error:&error];
                modelSetup = setupModel;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        if (success) {
                            success(setupModel);
                        }
                    } else {
                        if (failure) {
                            failure(error);
                        }
                    }
                });
            } failureBlock:^(NSError *error, NSData *failureData) {
                if (failure) {
                    failure(error);
                }
            }];
        }
    }
}

+ (void) getStampCampaign:(void (^)(WBRStampCampaign *stampModel))success failure:(void (^)(NSDictionary *dictError))failure {
    [WBRSetupManager getSetup:^(ModelSetup *setupModel) {
        modelStampCampaign = setupModel.stampCampaign;
        if (success) {
            success(modelStampCampaign);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

+ (void) getInstallCampaign:(void (^)(WBRInstallCampaign *installCampaignModel))success failure:(void (^)(NSDictionary *dictError))failure {
    [self getSetup:^(ModelSetup *setupModel) {
        modelInstallCampaign = setupModel.installCampaign;
        if (success) success(modelInstallCampaign);
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure (@{@"error" : error.localizedDescription});
        }
    }];
}

+ (NSString *)aboutInfo {
    return modelSetup.aboutInfo;
}

+ (NSString *)stampCampaignDisclaimer {
    return modelSetup.stampCampaign.disclaimer;
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
