//
//  WBRFacebookLoginManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 05/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRFacebookLoginManager.h"
#import "WBRLoginUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NSError+CustomError.h"
#import "WBRConnection.h"
#import "WALFavoritesCache.h"
#import "PushHandler.h"
#import "ShowcaseProductModel.h"
#import "WALHomeViewController.h"
#import "User.h"
#import "WBRLoginManager.h"

static NSString * const kTemporaryFacebookErrorMessage = @"[Temporary message]\n\nFacebook error\n\n[Temporary message]";

/*
Facebook Token for test:
@"EAAKmFI6bvw0BAHHTiVw8GFPhepszGZA2ingzR2boZAY1ZAK8lmG7AEhCPsVtGRzRBtM08WZBAQ1ZB39E5I42oLVg7ZCIsn3LdbB49j4NR0TcK1N9r7iCuDB5aZAwZA47yekKhsYMwlfAZAXrUwrd3RAd5U1PGfKcvbmuzqvSb9PWmTNTDkhLweX2B";
*/

@implementation WBRFacebookLoginManager

+ (void)loginWithFacebookSuccess:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock{
    
    [self loginWithFacebookWithPermissions:nil success:^(FaceUser *user) {
        NSString *url = URL_CONNECT_FACEBOOK;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            LogInfo(@"[FACEBOOK] User   : %@", user.name);
            LogInfo(@"[FACEBOOK] E-mail : %@", user.email);
            LogInfo(@"[FACEBOOK] Access : %@", user.tokenFacebook);
            LogInfo(@"[FACEBOOK] Image  : %@", user.picture_url);
            LogInfo(@"[FACEBOOK] Expire : %@", [FBSDKAccessToken currentAccessToken].expirationDate);
            if (user.tokenFacebook) {
                
                
                
                [self connectFacebookAccessTokenWithUrl:url andToken:user.tokenFacebook success:^(NSString *content, NSHTTPURLResponse *response) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LogInfo(@"[FACEBOOK] Content: %@", content);
                        LogInfo(@"[FACEBOOK] Status Code: %i", (int) response.statusCode);
                        
                        //Search by pre favorited product
                        NSData *wishlistProductData = [[NSUserDefaults standardUserDefaults] objectForKey:@"showcaseHeart"];
                        if (wishlistProductData) {
                            ShowcaseProductModel *spm = [NSKeyedUnarchiver unarchiveObjectWithData:wishlistProductData];
                            [[WALHomeViewController new] favoriteProduct:spm completionBlock:nil];
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
                        }
                        if (successBlock) {
                            successBlock(user, response);
                        }
                    });
                    
                } failure:^(NSError *error, NSHTTPURLResponse *response) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *msgError = ERROR_CONNECTION_UNKNOWN;
                        
                        LogErro(@"[FACE] Error");
                        LogInfo(@"[FACE] Status Code: %i", (int) response.statusCode ?: 0);
                        
                        NSString *errorString = error.description ?: @"";
                        NSInteger statusCode = [response statusCode] ?: 0;
                        
                        if ([errorString rangeOfString:@"Code=-1012"].location != NSNotFound) {
                            statusCode = 401; //The connection failed because the user cancelled required authentication
                        } else if ([errorString rangeOfString:@"Code=-1001"].location != NSNotFound) {
                            statusCode = 408; //The connection timed out
                            msgError = ERROR_CONNECTION_TIMEOUT;
                        }
                        else if ([errorString rangeOfString:@"Code=-1003"].location != NSNotFound ||
                                 [errorString rangeOfString:@"Code=-1004"].location != NSNotFound ||
                                 [errorString rangeOfString:@"Code=-1005"].location != NSNotFound ||
                                 [errorString rangeOfString:@"Code=-1009"].location != NSNotFound) {
                            statusCode = 1009;
                            
                            msgError = ERROR_CONNECTION_INTERNET;
                        } else if ((int) statusCode == 0) {
                            
                            msgError = ERROR_CONNECTION_DATA;
                        }
                        
                        NSError *errorMessage = [NSError errorWithCode:statusCode message:msgError];
                        if (failureBlock) {
                            failureBlock(errorMessage, response);
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LogErro(@"[FACEBOOK] Error - No access token from Facebook");
                    if (failureBlock) {
                        failureBlock([NSError errorWithCode:99 message:FACEBOOK_MSG_ERROR_NO_TOKEN], nil);
                    }
                });
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LogErro(@"[FACEBOOK] Error: %@", [error description]);
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }];
}

+ (void)connectFacebookAccessTokenWithUrl:(NSString *)strUrlConnect andToken:(NSString *) accessToken success:(void (^)(NSString *str, NSHTTPURLResponse *response))successBlock failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failureBlock {

    LogURL(@"[FACEBOOK] URL: %@", strUrlConnect);
    LogInfo(@"[FACEBOOK] Access Token sent to connect: %@", accessToken);
    NSString *url = strUrlConnect;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *urlSession = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlSession
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    NSDictionary *dictInfo = [OFSetup infoAppToServer];

    [request addValue:accessToken forHTTPHeaderField:@"accessTokenFb"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[dictInfo objectForKey:@"system"] forHTTPHeaderField:@"system"];
    [request addValue:[dictInfo objectForKey:@"version"] forHTTPHeaderField:@"version"];
    LogMicro(@"[FACEBOOK] Request Headers: %@", [request allHTTPHeaderFields]);
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = httpResponse.statusCode;
        
        LogInfo(@"[FACEBOOK] Token Status Code: %li", (long)statusCode);

        if (error == nil && statusCode == 200) {
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dictTokens = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                LogInfo(@"[FACEBOOK] Token Dictionary: %@", dictTokens);
                
                NSError *parserError;
                WMBTokenModel *tokenModel = [[WMBTokenModel alloc] initWithDictionary:dictTokens error:&parserError];
                if (tokenModel) {
                    BOOL savedSuccessfully = [[WMTokens new] addTokenOAuth:tokenModel];
                    
                    LogInfo(@"[FACEBOOK] Token saved: %i", savedSuccessfully);
                    if (savedSuccessfully)
                    {
                        WMTokens *tokenManager = [WMTokens new];
                        tokenManager.transparentError = YES;
                    }
                    
                    [WALFavoritesCache update];
                    [[PushHandler singleton] registerForPushNotificationsOnWalmartServer];
                    
                    User *localUser = [User sharedUser];
                    if (localUser == nil) {
                        [WBRLoginManager loadUserInfoDataWithSuccessBlock:nil failureBlock:nil];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
                    });
                }
            }
            if (successBlock) {
                LogMicro(@"[FACEBOOK] Success String Data: %@ \n HttpResponse: %@", file, httpResponse.description);

                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    successBlock(file, httpResponse);
                }];
            }
        } else {
            LogMicro(@"[FACEBOOK] Failure Data: %@", data);
            if (failureBlock) {
                LogInfo(@"[FACEBOOK] Failure to get Token: %@", error.description);
                failureBlock(error, httpResponse);
            }
        }
    }];
    
    [getDataTask resume];
}

+ (void)loginWithFacebookWithPermissions:(NSArray *)permissions success:(void (^)(FaceUser *user))success failure:(void (^)(NSError *error))failure
{
    if (!permissions) permissions = [WBRLoginUtils defaultFacebookPermissions];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            LogInfo(@"[FACEBOOK] Error logging with Facebook");
            if (failure) {
                failure([NSError errorWithMessage:kTemporaryFacebookErrorMessage]);
            }
        } else if (result.isCancelled) {
            LogInfo(@"[FACEBOOK] User cancelled login with Facebook");
            if (failure) failure(nil);
        } else {
            [self getFacebookUserInformationsWithSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
                if (success) {
                    success(facebookUser);
                }
            } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
                if (failure) {
                    failure(error);
                }
            }];
        }
    }];
}

+ (void)getFacebookUserInformationsWithSuccess:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{@"fields": @"id,name,picture.width(180).height(180),email,gender,birthday"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                LogErro(@"[FACEBOOK] Error: %@", [error description]);
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:kTemporaryFacebookErrorMessage], nil);
                }
            } else {
                NSError *parserError;
                FaceUser *user = [[FaceUser alloc] initWithDictionary:result error:&parserError];
                LogInfo(@"[FACEBOOK] Result: %@", [result description]);
                if (!parserError) {
                    LogInfo(@"[FACEBOOK] Successfully logged into Facebook and we get all the informations we need to register the user");
                    LogInfo(@"[FACEBOOK] User        : %@", user.name);
                    LogInfo(@"[FACEBOOK] E-mail      : %@", user.email);
                    LogInfo(@"[FACEBOOK] Access Token: %@", user.tokenFacebook);
                    LogInfo(@"[FACEBOOK] Image       : %@", user.picture_url);

                    user.tokenFacebook = FBSDKAccessToken.currentAccessToken.tokenString;
                    if (successBlock) {
                        successBlock(user, result);
                    }
                } else {
                    
                    LogInfo(@"[FACEBOOK] Error parsing Facebook Graph API call result");
                    if (failureBlock) {
                        failureBlock([NSError errorWithMessage:kTemporaryFacebookErrorMessage], nil);
                    }
                }
            }
        }];
    } else {
        LogInfo(@"[FACEBOOK] Error when getting informations from facebook. Invalid access token");
        if (failureBlock) {
            failureBlock([NSError errorWithMessage:kTemporaryFacebookErrorMessage], nil);
        }
    }
}

+ (void)linkFacebookWithGuid:(NSString *)guid andFacebookAccessToken:(NSString *)facebookAccessToken success:(void (^)())successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock {
    NSString *url = URL_LINK_FACEBOOK;
    
    LogURL(@"[FACEBOOK] Liking Facebook URL: %@", url);

    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];

    [headerDict setValue:@"application/json" forKey:@"Content-Type"];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    [headerDict setValue:guid forKey:@"guid"];
    [headerDict setValue:facebookAccessToken forKey:@"accessTokenFb"];

    [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock();
            }
        });
    } failureBlock:^(NSError *error, NSData *failureData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LogErro(@"[FACEBOOK] Error Linking Facebook Account - [%@]", url);
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });

    }];
}

+ (void)unlinkFacebookWithGuid:(NSString *)guidCli success:(void (^)())successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock {
    NSString *url = URL_UNLINK_FACEBOOK;
    LogURL(@"UNLINK Facebook url: %@", url);
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    [headerDict setValue:@"application/json" forKey:@"Content-Type"];
    [headerDict setValue:guidCli forKey:@"X-Client-GUID"];

    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    
    [[WBRConnection sharedInstance] DELETE:url headers:headerDict body:nil authenticationLevel:kAuthenticationLevelOptional successBlock:^(NSURLResponse *response, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LogMicro(@"[FACEBOOK] UnLink Success %@", data);
            if (successBlock) {
                successBlock();
            }
        });
    } failureBlock:^(NSError *error, NSData *failureData) {
        LogErro(@"[FACEBOOK] UnLink Error: %@ | %i", [error description], (int) error.code);
        if (failureBlock){
            failureBlock(error, nil);
        }
    }];
}

+ (void)loginWithPermissions:(NSArray *)permissions success:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock {
    if (!permissions) {
         permissions = [WBRLoginUtils defaultFacebookPermissions];
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            LogInfo(@"[FACEBOOK] Error logging with Facebook");
            if (failureBlock) {
                failureBlock([NSError errorWithCode:error.code message:kTemporaryFacebookErrorMessage], nil);
            }
        } else if (result.isCancelled) {
            LogInfo(@"[FACEBOOK] User cancelled login with Facebook");
            if (failureBlock) {
                failureBlock(nil, nil);
            }
        } else {
            [self getFacebookUserInformationsWithSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
                LogInfo(@"[FACEBOOK] E-mail user: %@", facebookUser.email);
                LogInfo(@"[FACEBOOK] id         : %@", facebookUser.idFacebook);
                LogInfo(@"[FACEBOOK] Image      : %@", facebookUser.picture_url);

                if (successBlock) {
                    successBlock(facebookUser, nil);
                }
            } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
                LogErro(@"[FACEBOOK] Error Login Facebook: %@", error.description ?: @"");

                if (failureBlock) {
                    failureBlock(error, failResponse);
                }
            }];
        }
    }];
}

+ (void)getImageFacebook:(NSString *)socialId completionBlock:(kFacebookLoginManagerSuccessStringBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@/picture?width=200&height=200&redirect=false", URL_IMG_USER_FACEBOOK, socialId];
    
    LogURL(@"[FACEBOOK] Facebook Image url: %@", url);
    LogInfo(@"[FACE] Social Id: %@", socialId);

    [[WBRConnection sharedInstance] GET:url successBlock:^(NSURLResponse *response, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *urlImgFacebook = [[json valueForKey:@"data"] objectForKey:@"url"];
            LogURL(@"[FACEBOOK] Profile Image Url: %@", urlImgFacebook);
            if (successBlock) {
                successBlock(urlImgFacebook);
            }
        });
    } failureBlock:^(NSError *error, NSData *failureData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LogErro(@"[FACEBOOK] Error getting image from Facebook");
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }];
}

+ (void)logoutFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}

@end
