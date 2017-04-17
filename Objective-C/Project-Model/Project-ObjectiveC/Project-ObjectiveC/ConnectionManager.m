//
//  ConnectionManager.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/25/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConstantsManager.h"

@interface ConnectionManager()

#ifdef DEBUG
#define SUBSCRIPTION_KEY AUTHENTICATE_AHK_SUBSCRIPTION_VALUE_DEV
#else
#define SUBSCRIPTION_KEY AUTHENTICATE_AHK_SUBSCRIPTION_VALUE_PROD
#endif

@property(nonatomic, strong) NSString *serverPreference;
//Download Control
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, copy) void (^downloadCompletionHandler)(NSData *response, NSError *error);
@property (nonatomic, assign) bool downloadingFile;
@property (nonatomic, strong) NSURLConnection *downloadConnection;


@end

@implementation ConnectionManager

@synthesize receivedData, downloadSize, downloadingFile, downloadConnection, downloadCompletionHandler, serverPreference;

//+ (id)sharedInstance {
//    static ConnectionManager *sharedConnectionManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedConnectionManager = [[self alloc] init];
//    });
//    return sharedConnectionManager;
//}

- (NSString*)getServerPreference
{
#ifdef DEBUG
    return [NSString stringWithFormat:@"http://%@", SERVER_URL_DEV];
#else
    return [NSString stringWithFormat:@"http://%@", SERVER_URL_PROD];
#endif
}


-(AFJSONRequestSerializer *)getHeaderParametersForServiceAS:(bool)serviceAHK
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //TODO: new header:
    //Idioma
    [requestSerializer setValue:NSLocalizedString(@"LANGUAGE_APP", @"") forHTTPHeaderField:@"idiom"];
    //Device Info
    [requestSerializer setValue:[self getDeviceInfo] forHTTPHeaderField:@"device_info"];
    //Token Acesso
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:PLISTKEY_ACCESS_TOKEN];
    [requestSerializer setValue:(token ? token : @"") forHTTPHeaderField:@"token"]; /////?

    return requestSerializer;
}

-(BOOL)isConnectionActive
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

#pragma mark - Exemplos

- (void)setData:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAS:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_AUTHENTICATE_STORE];
    //NSString *urlString = @"http://demo6609543.mockable.io/authenticate";
    
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)getData:(long)objectID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAS:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_AUTHENTICATE_STORE];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}


#pragma mark -

- (NSString*)getDeviceInfo
{
    NSMutableDictionary *dicInfo = [NSMutableDictionary new];
    [dicInfo setValue:[ToolBox deviceHelper_Name] forKey:@"name"];
    [dicInfo setValue:[NSString stringWithFormat:@"Apple - %@", [ToolBox deviceHelper_Model]] forKey:@"model"];
    [dicInfo setValue:[ToolBox deviceHelper_SystemVersion] forKey:@"system_version"];
    [dicInfo setValue:[ToolBox deviceHelper_SystemLanguage] forKey:@"system_language"];
    [dicInfo setValue:[ToolBox deviceHelper_StorageCapacity] forKey:@"storage_capacity"];
    [dicInfo setValue:[ToolBox deviceHelper_FreeMemorySpace] forKey:@"free_memory_space"];
    [dicInfo setValue:[ToolBox deviceHelper_IdentifierForVendor] forKey:@"identifier_for_vendor"];
    [dicInfo setValue:[ToolBox applicationHelper_VersionBundle] forKey:@"app_version"];
    //
    return [ToolBox converterHelper_StringJsonFromDictionary:dicInfo];
}

#pragma mark - Download de Arquivo

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
    if (statusCode == 200) {
        downloadSize = [response expectedContentLength];
        [receivedData setLength:0];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
    float downloadProgress = ((float) [receivedData length] / (float) downloadSize);
    downloadProgress = downloadProgress > 1.0 ? 1.0 : downloadProgress;
    //
    if ([self.delegate respondsToSelector:@selector(downloadProgress:)]){
        [self.delegate downloadProgress:downloadProgress];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(nil, error);
    }else{
        if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
        {
            [self.delegate didConnectWithFailure:error];
        }
    }
    //
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (downloadCompletionHandler){
            downloadCompletionHandler(receivedData, nil);
        }else{
            if ([self.delegate respondsToSelector:@selector(didConnectWithSuccessData:)])
            {
                [self.delegate didConnectWithSuccessData:receivedData];
            }
        }
        //
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
    });
}

- (void) cancelCurrentDownload
{
    if (downloadConnection){
        [downloadConnection cancel];
        //
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
