//
//  PushHandler.m
//  Tracking
//
//  Created by Bruno Delgado on 26/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

@import AirshipKit;

#import "PushHandler.h"
#import "UserSession.h"
#import "OFAppDelegate.h"
#import "OFUrls.h"
#import "OFSetup.h"

#import "WBRConnection.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString * const kPushTypeHome = @"home";
static NSString * const kPushTypeProduct = @"product";
static NSString * const kPushTypeOrderStatus = @"status";

@interface PushHandler ()

@end

@implementation PushHandler

+ (instancetype)singleton
{
    static PushHandler *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [PushHandler new];
    });
    return singleton;
}

+ (void)destroy
{
    PushHandler *handler = [PushHandler singleton];
    handler.notificationDictionary = nil;
}

- (void)registerForPushNotifications
{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil]];
}

- (void)unregisterForPushNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UserSession sharedInstance] setPushNotificationsActivated:NO];
}

- (void)handlePushReceived:(NSDictionary *)userInfo
{
    LogInfo(@"[Push Handler] handlePushReceived: ");
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive)
    {
        LogInfo(@"[Push Handler] Application state is active, checking notifcation type");
        
        LogInfo(@"[Push Handler] userInfo: %@", userInfo);
        
        if (userInfo)
        {
            NSString *orderID = [self orderIDFromPushNotification];
            if (orderID)
            {
                NSDictionary *alertDictionary = [userInfo objectForKey:@"aps"] ?: nil;
                if (alertDictionary)
                {
                    NSString *alertMessage = [alertDictionary objectForKey:@"alert"];
                    if (alertMessage)
                    {
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           LogInfo(@"Message received: %@", alertMessage);
                           [FlurryWM logEvent_push_notification_launch:alertMessage];
                           
                           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mensagem" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Fechar" style:UIAlertActionStyleCancel handler:nil];
                           [alertController addAction:alertAction];
                           
                           OFAppDelegate *appDelegate = (OFAppDelegate *)[UIApplication sharedApplication].delegate;
                           UIViewController *currentShowedViewController = appDelegate.window.rootViewController.presentedViewController ? appDelegate.window.rootViewController.presentedViewController : appDelegate.window.rootViewController;
                           [currentShowedViewController presentViewController:alertController animated:YES completion:nil];
                       });
                    }
                }
            }
        }
    }
    else
    {
        LogInfo(@"[Push Handler] Application state is not Active, saving notification");
        self.notificationDictionary = userInfo;
    }
}

- (BOOL)isHomePushNotification
{
    NSString *type = [self.notificationDictionary objectForKey:@"type"];
    if (type) type = type.lowercaseString;
    
    BOOL homePush = [type isEqualToString:kPushTypeHome];
    return homePush;
}

- (NSString *)productIdFromNotification
{
    NSString *productId = nil;
    productId = [self.notificationDictionary objectForKey:@"product_id"];
    if (productId && productId.length > 0) LogInfo(@"[Push Handler] Temos um product id válido");
    
    if (!productId)
    {
        //New way to check
        productId = [self.notificationDictionary objectForKey:@"product"];
        NSString *type = [self.notificationDictionary objectForKey:@"type"];
        if (type) type = type.lowercaseString;
        
        return (productId && productId.length > 0 && [type isEqualToString:kPushTypeProduct]) ? productId : nil;
    }
    
    return productId;
}

- (NSString *)productSKUFromNotification
{
    NSString *sku = nil;
    sku = [self.notificationDictionary objectForKey:@"product_sku"];
    if (sku && sku.length > 0) LogInfo(@"[Push Handler] We have a valid product sku");
    return sku;
}

- (NSString *)orderIDFromPushNotification
{
    NSString *orderID = nil;
    NSDictionary *alertDictionary = [self.notificationDictionary objectForKey:@"aps"] ?: nil;
    
    LogInfo(@"[Push Handler] alertDictionary: %@", alertDictionary);
    
    if (alertDictionary)
    {
        
        NSString *alertMessage = @"";
        
        if ([[alertDictionary objectForKey:@"alert"] isKindOfClass:[NSDictionary class]]) {
            NSString *title = [[alertDictionary objectForKey:@"alert"] objectForKey:@"title"];
            NSString *body = [[alertDictionary objectForKey:@"alert"] objectForKey:@"body"];
            
            LogInfo(@"[Push Handler] Dictionary type with title");
            LogInfo(@"[Push Handler] Message: %@", alertMessage);
            
            alertMessage = [NSString stringWithFormat:@"%@ %@", title, body] ?: nil;
            
        }
        else {
            
            LogInfo(@"[Push Handler] String type without title");
            LogInfo(@"[Push Handler] Message: %@", [alertDictionary objectForKey:@"alert"] ?: nil);
            
            alertMessage = [alertDictionary objectForKey:@"alert"] ?: nil;
        }
        
        
        if (alertMessage)
        {
            NSArray *messageParts = [alertMessage componentsSeparatedByString:@" "];
            if (messageParts.count > 0)
            {
                NSString *possibleOrderNumber = messageParts.firstObject;
                if (possibleOrderNumber.length > 0)
                {
                    LogInfo(@"[Push Handler] OrderID com length válido");
                    LogInfo(@"[Push Handler] Possible Number: %@", possibleOrderNumber);
                    NSString *firstChar = [possibleOrderNumber substringToIndex:1];
                    
                    LogInfo(@"[Push Handler] First Character: %@", firstChar);
                    if ([firstChar isEqualToString:@"#"])
                    {
                        LogInfo(@"[Push Handler] We have a valid Order ID: %@", possibleOrderNumber);
                        orderID = possibleOrderNumber;
                        orderID = [orderID stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        [FlurryWM logEvent_push_notification_launch:orderID];
                    }
                }
            }
        }
    }
    
    //New way to check
    if (!orderID)
    {
        NSString *orderFromPush = [self.notificationDictionary objectForKey:@"orderId"];
        NSString *type = [self.notificationDictionary objectForKey:@"type"];
        if (type) type = type.lowercaseString;
        
        if (orderFromPush && orderFromPush.length > 0 && [type isEqualToString:kPushTypeOrderStatus])
        {
            LogInfo(@"[Push Handler] We have a valid Order ID: %@", orderID);
            orderID = orderFromPush;
            [FlurryWM logEvent_push_notification_launch:orderID];
        }
    }
    
    return orderID;
}

- (NSString *)collectionFromPushNotification
{
    NSString *collection = nil;
    collection = [self.notificationDictionary objectForKey:@"collection"];
    return (collection && collection.length > 0) ? collection : nil;
}

- (void)cleanBadge
{
    [self setApplicationBadgeNumber:0];
}

#pragma mark - Badge implementation
- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else
    {
        UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (currentSettings.types & UIUserNotificationTypeBadge)
        {
            LogInfo(@"[Push Handler] Badge number changed to %d", (int) badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else
        {
            LogErro(@"[Push Handler] Access denied for UIUserNotificationTypeBadge");
        }
    }
}

#pragma mark - Walmart Server
- (void)registerForPushNotificationsOnWalmartServer
{
    if ([OFSetup hasActiveConnection])
    {
        [[WMTokens new] getTokenOAuth:^(NSString *token) {
            NSString *tokOA = token;
            if (tokOA && tokOA.length > 0)
            {
                NSString *dToUrban = [[UAirship push] deviceToken] ?: @"";

                if (![dToUrban isEqualToString:@""])
                {
                    LogInfo(@"DEVICE TOKEN URBAN: %@", dToUrban);
                    NSDictionary *parameters = @{@"deviceId" : dToUrban, @"platform" : @"ios"};

                    NSString *url = [[OFUrls new] getURLRegisterDeviceInServer];
                    LogURL(@"URL PushBox Register: %@", url);

                    NSDictionary *dictInfo = [OFSetup infoAppToServer];
                    NSMutableDictionary<NSString *, NSString *> *headersDictionary = (NSMutableDictionary *) @{
                                                        @"Content-Type": @"application/json",
                                                        @"Accept": @"application/json",
                                                        @"system": [dictInfo objectForKey:@"system"],
                                                        @"version": [dictInfo objectForKey:@"version"]
                                                        };

                    LogMicro(@"Pushbox Register Parameters: %@", parameters);
                    LogMicro(@"Pushbox Register Request: %@", headersDictionary);
                    
                    [[WBRConnection sharedInstance] POST:url headers:headersDictionary body:parameters authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
                        
                        NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
                        
                        NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        LogMicro(@"Pushbox Register Response [%i]: %@",(int) aResponse.statusCode, file);
                        
                        if (aResponse.statusCode == 200) {
                            LogInfo(@"[Register Device on Walmart Server] Sucesso - 200");
                        }
                        else {
                            LogInfo(@"[Register Device on Walmart Server] Erro - %ld", (long)aResponse.statusCode);
                        }
                    } failureBlock:^(NSError *error, NSData *failureData) {
                        LogInfo(@"[Register Device on Walmart Server] Erro - %@", error.localizedDescription);
                    }];
                }
            }
        }];
    }
    else
    {
        LogInfo(@"[Register Device on Walmart Server] Sem conexão");
    }
}

- (void)unregisterForPushNotificationsOnWalmartServer
{
    if ([OFSetup hasActiveConnection])
    {
        NSString *dToUrban = [[UAirship push] deviceToken] ?: @"";
        [[WMTokens new] getTokenOAuth:^(NSString *token) {
            NSString *tokOA = token ?: @"";
            if (tokOA.length > 0 && dToUrban.length > 0) {
                NSString *strUrlUnregister = [[OFUrls new] getURLRemoveDeviceFromServer];
                NSString *url = [strUrlUnregister stringByAppendingString:dToUrban];
                LogURL(@"URL PushBox Unregister: %@", url);
                
                NSDictionary *dictInfo = [OFSetup infoAppToServer];
                NSDictionary<NSString *, NSString *> *headersDictionary = @{
                                                                                   @"Content-Type": @"application/json",
                                                                                   @"Accept": @"application/json",
                                                                                   @"system": [dictInfo objectForKey:@"system"],
                                                                                   @"version": [dictInfo objectForKey:@"version"]
                                                                                   };
                
                LogMicro(@"Pushbox Unregister Request: %@", dictInfo);
                
                [[WBRConnection sharedInstance] DELETE:url headers:headersDictionary body:nil authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
                    
                        NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
                        NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        LogMicro(@"Pushbox Unregister Response [%i]: %@",(int) aResponse.statusCode, file);
                        
                        if (aResponse.statusCode == 200) {
                            LogInfo(@"[Remove Device on Walmart Server] Sucesso - 200");
                        }
                        else {
                            LogErro(@"[Remove Device on Walmart Server] Erro - %ld", (long)aResponse.statusCode);
                        }
                } failureBlock:^(NSError *error, NSData *failureData) {
                    LogErro(@"[Remove Device on Walmart Server] Erro - %@", error.localizedDescription);
                }];
            }
            else {
                
                LogErro(@"[Remove Device on Walmart Server] No Token or deviceId");
            }
        }];
    }
    else
    {
        LogErro(@"[Remove Device on Walmart Server] Sem conexão");
    }
}

@end
