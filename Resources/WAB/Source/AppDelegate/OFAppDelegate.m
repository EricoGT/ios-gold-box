//
//  OFAppDelegate.m
//  Ofertas AppDelegate
//
//  Created by Marcelo Santos on 7/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

@import AirshipKit;

#import "OFAppDelegate.h"
#import "OFSplashViewController.h"
#import "Flurry.h"
#import "PushHandler.h"
#import "ADBMobile.h"
#import "WALHomeViewController.h"
#import "DeepLinkAction.h"
#import "OFSplashViewController.h"
#import "NewCartViewController.h"
#import "WMAlertView.h"
#import "ServicesMessageModel.h"
#import "WMTokens.h"
#import "MDSSqlite.h"
#import "WMBlockVersion.h"
#import "WALFavoritesCache.h"
#import "WMBTokenMigration.h"
#import "User.h"

#import <Bolts/Bolts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "WBRUser.h"
#import "WBRSetupManager.h"

#import "WMMyAccountViewController.h"
#import "WALHomeCache.h"
#import "WBRFacebookLoginManager.h"

#import "WBRUTM.h"
#import "WBRUserManager.h"

#import "Firebase.h"


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString * const DeepLinkApplicationId = @"walmartbr://";
static NSString * const DeepLinkProductSku = @"productSKU=";
static NSString * const DeepLinkProductId = @"productID=";
static NSString * const DeepLinkSearchResult = @"searchQuery=";

@interface OFAppDelegate () <UAPushNotificationDelegate>

@property (strong, nonatomic) WMBlockVersion *blockVersion;
@property BOOL alreadyFabric;
@property BOOL isAlertVisible;

@property (strong, nonatomic) UIView *obfuscatedView;
@end

@implementation OFAppDelegate


/**
 @abstract Support and initialization for:<br>
 
 - HockeyApp:
 
        - WM Pre Release    :   AppKey: f65a5e77773242c58d6529fd56b1a059
        - Walmart iOS PROD  :   AppKey: 8a7154dc41fb908a79353a0dd616da6f
        - Walmart iOS QA    :   AppKey: 10cfd442494ce3dc50e5645543cb9654
        - Walmart iOS Stage :   AppKey: da5a72717ad42ea04aabcf6894f77b47
        - Walmart iOS Beta  :   AppKey: 1af70e686502516f5146afe789bb7a11
 
    We don't need to call all ApiKeys because the distribution is made via Jenkins. We are starting a few appKeys here to submit builds directly to HockeyApp through Xcode.
    
    The class used for HockeyApp distribution is BITHockeyManager
 
 - Omniture:
 
        - Prod      :   0e62e65cc25be73d28499217177bfbaa556816fba5131908cea46c027ffe399b
        - Others    :   eaf561c1040d384d09cc70af630a2e57d079ec5eea00b0556c6fff833cdda6fd
 
    The class used for Omniture metrics is ADMobile
 
 - Urban:
 
        Production:
        - developmentAppKey     :   PSTljyElT6OzD7VnoyYdFw (not used)
        - developmentAppSecret  :   qwL4R81cRSuc7gQEaDptRA (not used)
        - developmentAppKey     :   OxcuCn1FSLOpTjAA9cx-Mw
        - developmentAppSecret  :   Wijdz81yS-etkNMc8PcqVA
 
        QA:
        - developmentAppKey     :   PSTljyElT6OzD7VnoyYdFw (not used)
        - developmentAppSecret  :   qwL4R81cRSuc7gQEaDptRA (not used)
        - developmentAppKey     :   kytFf9D2Ts-ZyhVEkzkTdw
        - developmentAppSecret  :   irvkLyhhTKysfmcjPmt_eg
 
 - Crashlytics (Fabric):
 
        - APIKey    :   6c02aee46466569b0b0ce8e7d678962476db2aca
 
 - Flurry:
 
        - APIKey Production :   H2D7C7BX8HR865WSF3FR
        - APIKey QA         :   2NNJS2XZC8P8W3YVK5DK
 
*/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LogInfo(@"Logs service enabled [%i] (0:off 1:on)", [OFSetup logsEnable]);
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    [self verifyCleanDirectories];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self configureFirebase];
    
#pragma mark - HockeyApp
    
    #if defined CONFIGURATION_Enterprise //Walmart iOS PROD
    //Bit Hockey
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"8a7154dc41fb908a79353a0dd616da6f" delegate:self];
    LogInfo(@"HockeyApp active - Enterprise!");
    #endif
    
    #if defined CONFIGURATION_EnterpriseQA //Walmart iOS QA
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"10cfd442494ce3dc50e5645543cb9654" delegate:self];
    LogInfo(@"HockeyApp active - Enterprise QA!");
    #endif
    
    #if defined CONFIGURATION_EnterprisePR //WM Pre Release
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"f65a5e77773242c58d6529fd56b1a059" delegate:self];
    LogInfo(@"HockeyApp active - Enterprise PR!");
    #endif
    
    #if defined CONFIGURATION_EnterpriseTK //Walmart iOS β
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"1af70e686502516f5146afe789bb7a11" delegate:self];
    LogInfo(@"HockeyApp active - Enterprise TK!");
    #endif
    
#if defined CONFIGURATION_Enterprise || CONFIGURATION_EnterpriseQA || CONFIGURATION_EnterprisePR || CONFIGURATION_EnterpriseTK
    
    // optionally enable logging to get more information about states.
    //    [BITHockeyManager sharedHockeyManager].debugLogEnabled = YES;
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    //    [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:YES];
#endif
    
    
    
    #pragma mark - Urban Push
    
#if !defined CONFIGURATION_DebugCalabash
    // Set log level for debugging config loading (optional)
    // It will be set to the value in the loaded config upon takeOff
    [UAirship setLogLevel:UALogLevelNone];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    BOOL enableBadge = YES;
    
    [UAirship push].pushNotificationDelegate = self;
    
    if (enableBadge) {
        
        [UAirship push].notificationOptions = (UIUserNotificationTypeAlert |
                                                 UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound);
        
        [UAirship push].autobadgeEnabled = YES;
        
    } else {
        
        [UAirship push].notificationOptions = (UIUserNotificationTypeAlert |
                                                 UIUserNotificationTypeSound);
    }
    
    [UAirship push].userPushNotificationsEnabled = YES;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WantNotifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
    

#if defined DEBUG || CONFIGURATION_Release || CONFIGURATION_Enterprise || CONFIGURATION_EnterpriseTK || DEBUGQA
    #pragma mark - Crashlytics (Fabric)
    [[Fabric sharedSDK] setDebug: NO];
    [Fabric with:@[[Crashlytics class]]];
#endif
    
//    [Fabric with:@[CrashlyticsKit]];
    
    #pragma mark - Flurry
    NSString *flurryQA      = @"2NNJS2XZC8P8W3YVK5DK";
    NSString *flurryProd    = @"H2D7C7BX8HR865WSF3FR";
    LogInfo(@"Flurry QA: %@ Flurry Prod: %@", flurryQA, flurryProd);
    
//    [Flurry setAppVersion:kAppVersion];
//    [Flurry setLogLevel:FlurryLogLevelNone];
//    [Flurry setCrashReportingEnabled:NO];
    
    #if defined CONFIGURATION_EnterpriseQA || DEBUGQA || CONFIGURATION_EnterprisePR || CONFIGURATION_DebugCalabash
//    [Flurry startSession:flurryQA];
    
    [Flurry startSession:flurryQA
      withSessionBuilder:[[[FlurrySessionBuilder new]
                           withCrashReporting:NO]
                          withLogLevel:FlurryLogLevelNone]];
    #endif
    
    #if defined DEBUG || CONFIGURATION_Release || CONFIGURATION_Enterprise || CONFIGURATION_EnterpriseTK
//    [Flurry startSession:flurryProd];
    
    [Flurry startSession:flurryProd
      withSessionBuilder:[[[FlurrySessionBuilder new]
                           withCrashReporting:NO]
                          withLogLevel:FlurryLogLevelNone]];
    #endif
    
    [FlurryWM logEvent_timed_event_purchase_start];
    
    
    
    #pragma mark - Facebook Deep Link
    // Checking if we are comming from two possibilities:
    // 1 - User touched the AD in Facebook and has Walmart application installed
    // 2 - User touched the AD in Facebook and was prompted to install Walmart application, after the installation, when he opens the application for the first time
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
            if (url)
            {
                LogInfo(@"[FACEBOOK ADS DEEP LINK] Deferred App Link with success: %@", url);
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
    
    #pragma mark - Facebook Start
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    LogInfo(@"### Facebook SDK version: %@", [FBSDKSettings sdkVersion]);
    
    self.viewController = [[OFSplashViewController alloc] initWithNibName:@"OFSplashViewController" bundle:nil];
    _viewController.view.frame = _window.bounds;
    
    
    
    #pragma mark - Push Notifications
#if !defined CONFIGURATION_DebugCalabash
    NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    LogInfo(@"[AppDelegate] application:didFinishLaunchingWithOptions: %@", notification);
    if (notification) {
        [[PushHandler singleton] setNotificationDictionary:notification];
    }
#endif
    
    /*Simple mocks for push notification tests*/
//    [[PushHandler singleton] setNotificationDictionary:@{@"type" : @"home"}];
//    [[PushHandler singleton] setNotificationDictionary:@{@"type" : @"product", @"product" : @"2040412"}];
//    [[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"ft=fogao 6 bocas"}];
//    [[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"fq=H:26951"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"fq=H:26538"}];
//    [[PushHandler singleton] setNotificationDictionary:@{@"type" : @"status", @"orderId" : @"64560508"}];
    
    
    #pragma mark - Omniture
    //Omniture
    [ADBMobile collectLifecycleData];
    //    [ADBMobile setDebugLogging:YES];
    
    
    
    self.window.rootViewController = _viewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setApplicationBadgeNumber:0];

    //Migrating old token for the new one.
    [WMBTokenMigration migrateToken];
    
//    [self checkBlock];
    
    
//    //Tests
//    NSURL *urlTest = [NSURL URLWithString:@"https://walmartbr://productSKU=12345"];
//    LogInfo(@"URL Scheme: %@", urlTest.scheme);
//    LogInfo(@"URL Domain: %@", urlTest.host);
//    if ([urlTest.scheme isEqualToString:@"walmartbr"]) {
//        LogInfo(@"OK");
//    }
    
//    LogInfo(@"Keys Bundle: %@", [[[NSBundle mainBundle] infoDictionary] allKeys]);
//    LogInfo(@"Values Bundle: %@", [[NSBundle mainBundle] infoDictionary]);
    
    
#if defined CONFIGURATION_DebugCalabash
    [self logoffForAppium];
#endif
    
    return YES;
}

#pragma mark - Firebase
- (void)configureFirebase {
    
    /**
     * **** FIREBASE CONFIGURATION ****
     *
     * Firebase was configured to QA and Prod Debug/Production targets, because of this, exists two GoogleService-Info.plist in the project, one for QA and another for Prod Debug/Production.
     * To select the correct plist (QA or Prod) that will be used for the build, was added a Run Script in Build Phases called "Setup Firebase Enviroment GoogleServices-Info.plist".
     */
    
#if defined DEBUG || CONFIGURATION_Release || DEBUGQA
    [FIRApp configure];
#endif
}

#pragma mark - Search by PID
- (void) searchByPID {
    // TODO: remove after rekease
    if ([WALSession isAuthenticated]) {
        NSString *pid = [WBRUser pid];
        if (pid.length == 0) {
            [WBRUser logoutUserFromDevice];
        }
    }
}

#pragma mark - Badge implementation

//Fill badge with number
- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        application.applicationIconBadgeNumber = badgeNumber;
        
    } else {
        
        if ([self checkNotificationType:UIUserNotificationTypeBadge]) {
            //LogInfo(@"Badge number changed to %d", (int) badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else {
            LogErro(@"Access denied for UIUserNotificationTypeBadge");
        }
    }
}

//Check badge permissions
- (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    return (currentSettings.types & type);
}

- (void) verifyCleanDirectories {
    
    //Get version for app settings
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:version forKey:@"appVersion"];
    [defaults synchronize];

}


#if defined CONFIGURATION_BetaQA || CONFIGURATION_EnterpriseQA || CONFIGURATION_Beta || CONFIGURATION_Enterprise
- (BOOL)didCrashInLastSessionOnStartup {
    return ([[BITHockeyManager sharedHockeyManager].crashManager didCrashInLastSession] &&
            [[BITHockeyManager sharedHockeyManager].crashManager timeintervalCrashInLastSessionOccured] < 5);
}
#endif

- (void)setupApplication {
    // setup your app specific code
}

#pragma mark - BITCrashManagerDelegate

#if defined CONFIGURATION_EnterpriseQA || CONFIGURATION_Enterprise

- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}

- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}

- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadViewObfuscated];
    });
    
    [User persist];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //Cache
    [WALFavoritesCache update];
}

- (void)loadViewObfuscated
{
    
    self.obfuscatedView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _obfuscatedView.backgroundColor = RGBA(26, 117, 207, 1);
    
    UIImage *imgLogo = [UIImage imageNamed:@"img_splashpage.png"];
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:imgLogo];

    float widthScreen = [[UIScreen mainScreen] bounds].size.width;
    float heightScreen = [[UIScreen mainScreen] bounds].size.height;
    
    float posXLogo = (widthScreen - logoImg.frame.size.width) / 2;
    float posYLogo = (heightScreen - logoImg.frame.size.height) / 2;
    
    logoImg.frame = CGRectMake(posXLogo, posYLogo, logoImg.frame.size.width, logoImg.frame.size.height);
    
    [_obfuscatedView addSubview:logoImg];
    [self.window addSubview:_obfuscatedView];
}

- (void)removeViewObfuscated {
    
    [_obfuscatedView removeFromSuperview];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [self checkBlock];
    
    //Verify services
    [_viewController configureServices];
    //Verify Alerts
    [self checkAlert:^(ModelAlert *modelAlert) {
    }];
}

- (void)checkAlert:(void (^)(ModelAlert *modelAlert)) success
{
    //Alert
    
    if (!_isAlertVisible) {
        
        __weak OFAppDelegate *weakSelf = self;
        [WBRSetupManager getAlert:^(ModelAlert *alertModel) {
            
            LogMicro(@"\n\n[ALERT] Alert Model: %@", alertModel);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (alertModel.message.length > 0) {
                    
                    weakSelf.isAlertVisible = YES;
                    
                    if (alertModel.block.boolValue) {
                        
                        [weakSelf.window showAlertWithImageName:nil title:alertModel.title.length > 0 ? alertModel.title : GREETING_OPS message:alertModel.message dismissButtonTitle:alertModel.buttonOk.length > 0 ? alertModel.buttonOk : @"OK" dismissBlock:^{
                            
                            if (alertModel.url.length > 0) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertModel.url]];
                            }
                            
                            weakSelf.isAlertVisible = NO;
                            success(alertModel);
                        }];
                    }
                    else {
                        
                        [weakSelf.window showPopupWithTitle:alertModel.title.length > 0 ? alertModel.title : GREETING_OPS message:alertModel.message cancelButtonTitle:alertModel.buttonCancel.length > 0 ? alertModel.buttonCancel : @"Cancelar" cancelBlock:^{
                            
                            [[WALMenuViewController singleton] updateDepartments];
                            [[WALMenuViewController singleton] reloadHome];
                            
                            weakSelf.isAlertVisible = NO;
                            success(alertModel);
                            
                        } actionButtonTitle:alertModel.buttonOk.length > 0 ? alertModel.buttonOk : @"Ok" actionBlock:^{
                            
                            [[WALMenuViewController singleton] updateDepartments];
                            [[WALMenuViewController singleton] reloadHome];
                            
                            if (alertModel.url.length > 0) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertModel.url]];
                            }
                            
                            weakSelf.isAlertVisible = NO;
                            success(alertModel);
                        }];
                    }
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[WALMenuViewController singleton] reloadHome];
                        success(alertModel);
                    });
                }
            });
            
        } failure:^(NSDictionary *dictError) {
            LogErro(@"[ALERT] Error: %@", dictError);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[WALMenuViewController singleton] reloadHome];
            });
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    LogInfo(@"[OFAppDelegate] applicationDidBecomeActive:");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self removeViewObfuscated];
    
    [self setApplicationBadgeNumber:0];
    
    [self searchByPID];
    
    //To see how many people are using your application, log app activations
    [FBSDKAppEvents activateApp];
    
    [self handlePush];

    //Cache
    [WALFavoritesCache update];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [User persist];
    [self setApplicationBadgeNumber:0];
}

#pragma mark - Push Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WantNotifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *userToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    userToken = [userToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    LogInfo(@"User Device Token: %@",userToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    LogInfo(@"[AppDelegate] didReceiveRemoteNotification:");
    [self setApplicationBadgeNumber:0];
    [[PushHandler singleton] handlePushReceived:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    LogInfo(@"[AppDelegate] didReceiveRemoteNotification: fetchCompletionHandler:");
    [self setApplicationBadgeNumber:0];
    [[PushHandler singleton] handlePushReceived:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    LogInfo(@"Fail Register Push: %@", error.localizedDescription);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pushError"];
    
    if (!_alreadyFabric) {
        
        NSString *versionApp = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        
        [Answers logCustomEventWithName:@"Push Notifications"
                       customAttributes:@{
                                          @"Status Push" : @"PUSH OFF",
                                          @"app version" : versionApp,
                                          @"app error"   : error.localizedDescription
                                          }];
        _alreadyFabric = YES;
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    LogInfo(@"URL Scheme: %@", url.scheme);
    LogInfo(@"[AppDelegate] application:openURL:options:%@", options);
    
    BOOL schemeValid = [self validURLScheme:url.scheme] ?: NO;
    
    if (schemeValid) {
        
        //Checking if is an specific open from Facebook
        if (url) {
            if ([OFSetup enableFacebookDeepLink]) {
                [self handleDeepLink:url];
            }
        }
        
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
        
        return handled;
    }
    else {
        return NO;
    }
}

- (BOOL)validURLScheme:(NSString *)scheme {
    
    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]) {
        NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        for(NSDictionary *urlType in urlTypes)
        {
            if(urlType[@"CFBundleURLSchemes"])
            {
                NSArray *urlSchemes = urlType[@"CFBundleURLSchemes"];
                for(NSString *urlScheme in urlSchemes)
                    if([urlScheme caseInsensitiveCompare:scheme] == NSOrderedSame)
                        return YES;
            }
            
        }
    }
    return NO;
}

- (void)handleDeepLink:(NSURL *)deepLinkURL {
    // Here we can define what to do when user opens the app from a deep link
    // We here might have a product id, a search query or a category result
    // Example: "walmartbr://productSKU=12345"
    // Example: "walmartbr://productID=12345"
    // Example: "walmartbr://searchQuery=ft=fogao"
    //    walmartqa://searchQuery=area=eledromestico&searchKey=fogao&utm_source=Buscape
    
    [WBRUTM handleDeepLink:deepLinkURL.absoluteString];
    NSString *urlWithoutUTMParameter = [WBRUTM urlWithoutUTMParameters:deepLinkURL.absoluteString];
    
    NSString *deepLink = urlWithoutUTMParameter;
    NSString *deepLinkLowerCase = [deepLink lowercaseString];
    NSString *parameter = nil;
    
    NSRange productSkuRange = [deepLinkLowerCase rangeOfString:[DeepLinkProductSku lowercaseString]];
    NSRange productIdRange = [deepLinkLowerCase rangeOfString:[DeepLinkProductId lowercaseString]];
    NSRange searchRange = [deepLinkLowerCase rangeOfString:[DeepLinkSearchResult lowercaseString]];
    NSRange endRange = [deepLinkLowerCase rangeOfString:@"?al_applink_data"];
    
    DeepLinkAction *deepLinkAction = [DeepLinkAction new];
    
    if (productSkuRange.location != NSNotFound) {
        NSRange range;
        if (endRange.location != NSNotFound) {
            range = NSMakeRange(productSkuRange.location + productSkuRange.length, endRange.location - productSkuRange.location - productSkuRange.length);
        } else {
            range = NSMakeRange(productSkuRange.location + productSkuRange.length, deepLink.length - (productSkuRange.location + productSkuRange.length));
        }
        if (range.location != NSNotFound) {
            parameter = [deepLink substringWithRange:range];
            LogInfo(@"[DEEP LINK] Parameter Product SKU: %@", parameter);
            deepLinkAction.type = DeepLinkTypeProductSku;
            deepLinkAction.parameter = parameter;
        }
    } else if (productIdRange.location != NSNotFound) {
        NSRange range;
        if (endRange.location != NSNotFound) {
            range = NSMakeRange(productIdRange.location + productIdRange.length, endRange.location - productIdRange.location - productIdRange.length);
        } else {
            range = NSMakeRange(productIdRange.location + productIdRange.length, deepLink.length - (productIdRange.location + productIdRange.length));
        }
        if (range.location != NSNotFound) {
            parameter = [deepLink substringWithRange:range];
            LogInfo(@"[DEEP LINK] Parameter Product Id: %@", parameter);
            deepLinkAction.type = DeepLinkTypeProductId;
            deepLinkAction.parameter = parameter;
        }
    } else if (searchRange.location != NSNotFound) {
        NSRange range;
        if (endRange.location != NSNotFound) {
            range = NSMakeRange(searchRange.location + searchRange.length, endRange.location - searchRange.location - searchRange.length);
        } else {
            range = NSMakeRange(searchRange.location + searchRange.length, deepLink.length - (searchRange.location + searchRange.length));
        }
        if (range.location != NSNotFound) {
            parameter = [deepLink substringWithRange:range];
            LogInfo(@"[DEEP LINK] Parameter Search Query: %@", parameter);
            deepLinkAction.type = DeepLinkTypeSearch;
            deepLinkAction.parameter = parameter;
        }
    }
    
    if (deepLinkAction.parameter.length > 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstNewOpen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WALMenuViewController *menu = [WALMenuViewController singleton];
        menu.deepLink = deepLinkAction;
        [menu checkDeepLinkActions];
    }
}

- (void)dismissModalViews
{
    if (self.window.rootViewController.presentedViewController)
    {
        [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [self dismissModalViews];
        }];
        
        if ([self.window.rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController.presentedViewController;
            [navigationController popToRootViewControllerAnimated:NO];
        }
    }
    else
    {
        for (UIViewController *controller in self.window.rootViewController.childViewControllers)
        {
            if ([controller isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *navigationController = (UINavigationController *) controller;
                [navigationController popToRootViewControllerAnimated:NO];
            }
        }
    }
}

#pragma mark - Push
- (void)handlePush
{
    
    LogInfo(@"[AppDelegate] handlePush");
    //[[PushHandler singleton] setNotificationDictionary:@{@"type" : @"home"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"type" : @"product", @"product" : @"2040412"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"ft=fogao 6 bocas"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"fq=H:26951"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"collection" : @"fq=H:26538"}];
    //[[PushHandler singleton] setNotificationDictionary:@{@"type" : @"status", @"orderId" : @"20331461212"}];
    
    PushHandler *handler = [PushHandler singleton];
    BOOL hasPush = handler.notificationDictionary != nil;
    if (!hasPush) return;
    
    NSString *productId = [handler productIdFromNotification];
    NSString *collection = [handler collectionFromPushNotification];
    
    LogInfo(@"[AppDelegate] handlePush productId: %@", productId);
    LogInfo(@"[AppDelegate] handlePush collection: %@", collection);
    if (productId || collection)
    {
        id rootViewController = self.window.rootViewController;
        if ([rootViewController isKindOfClass:OFSplashViewController.class])
        {
            OFSplashViewController *splash = (OFSplashViewController *)rootViewController;
            WALMenuViewController *menu = splash.container.viewControllers.count > 0 ? splash.container.viewControllers[0] : nil;
            
            if (menu)
            {
                WALMenuItemViewController *menuItem = menu.currentController;
                if (menuItem.navigationController.topViewController)
                {
                    UIViewController *topController = menuItem.navigationController.topViewController;
                    UIViewController *currentController = topController;
                    while (currentController.presentedViewController)
                    {
                        topController = currentController.presentedViewController;
                        if ([topController isKindOfClass:UINavigationController.class])
                        {
                            currentController = [(UINavigationController *)topController topViewController];
                        }
                        else if ([topController isKindOfClass:UIActivityViewController.class])
                        {
                            UIActivityViewController *shareViewController = (UIActivityViewController *)currentController.presentedViewController;
                            [shareViewController dismissViewControllerAnimated:YES completion:nil];
                            break;
                        }
                        else
                        {
                            currentController = topController;
                        }
                    }
                    
                    if ([currentController respondsToSelector:@selector(checkCustomOpens)])
                    {
                        for (id view in (currentController.navigationController) ? currentController.navigationController.view.subviews : currentController.view.subviews)
                        {
                            if ([view isKindOfClass:WMAlertView.class]) [view removeFromSuperview];
                        }
                        [(WMBaseViewController *)currentController checkCustomOpens];
                    }
                }
            }
        }
    }
    else
    {
        id rootViewController = self.window.rootViewController;
        if ([rootViewController isKindOfClass:OFSplashViewController.class])
        {
            OFSplashViewController *splash = (OFSplashViewController *)rootViewController;
            WALMenuViewController *menu = splash.container.viewControllers.count > 0 ? splash.container.viewControllers[0] : nil;
            
            if (menu)
            {
                WALMenuItemViewController *menuItem = menu.currentController;
                if (menuItem.navigationController.topViewController)
                {
                    UIViewController *topController = menuItem.navigationController.topViewController;
                    UIViewController *currentController = topController;
                    while (currentController.presentedViewController)
                    {
                        topController = currentController.presentedViewController;
                        if ([currentController.presentedViewController isKindOfClass:UINavigationController.class])
                        {
                            if (menuItem.navigationController.viewControllers.count > 1)
                            {
                                [currentController.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                            topController = [(UINavigationController *)currentController.presentedViewController topViewController];
                            if (topController.presentedViewController)
                            {
                                [topController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                            }
                            [topController dismissViewControllerAnimated:YES completion:nil];
                            break;
                        }
                        else if ([topController isKindOfClass:UIActivityViewController.class])
                        {
                            UIActivityViewController *shareViewController = (UIActivityViewController *)currentController.presentedViewController;
                            [shareViewController dismissViewControllerAnimated:YES completion:nil];
                            break;
                        }
                        else
                        {
                            currentController = currentController.presentedViewController;
                        }
                    }
                    
                    if ([currentController respondsToSelector:@selector(checkCustomOpens)])
                    {
                        for (id view in (currentController.navigationController) ? currentController.navigationController.view.subviews : currentController.view.subviews)
                        {
                            if ([view isKindOfClass:WMAlertView.class]) [view removeFromSuperview];
                        }
                        
                        [(WMBaseViewController *)currentController checkCustomOpens];
                    }
                }
            }
        }
    }
}

#pragma mark - Disable third party keyboard

-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    
    if (extensionPointIdentifier == UIApplicationKeyboardExtensionPointIdentifier)
    {
        return NO;
    }
    
    return YES;
}

//Called when application is about to crash
void uncaughtExceptionHandler(NSException *exception)
{
    [User persist];
}

#if !defined CONFIGURATION_Release
- (NSString *) logoffForAppium
{
    NSLog(@"Logoff user for Appium test");
//    self.window.rootViewController = [[OFSplashViewController alloc] initWithNibName:nil bundle:nil];
//    return @"";

    [self dismissModalViews];
    
    [WBRUser removePIDFromUser];
    [WBRUserManager logoutUser];
//    [[WALMenuViewController singleton] logoutAndShowHomeCalabash:YES];
    [FlurryWM logTracking_event_logout];
    [[WMTokens new] deleteTokenOAuth];
    [WALFavoritesCache clean];
    [WALHomeCache clean];
    [[WMMyAccountViewController new] willLogoutNotification];
    [WBRFacebookLoginManager logoutFacebook];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchHeart"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetWishlistStatus" object:nil];
    
    return @"";
}
#endif

-(void)receivedNotificationResponse:(UANotificationResponse *)notificationResponse completionHandler:(void (^)(void))completionHandler {
    
    LogInfo(@"[AppDelegate] receivedNotificationResponse:completionHandler:");
    
    [[PushHandler singleton] setNotificationDictionary:notificationResponse.notificationContent.notificationInfo];
    
    completionHandler();
}

@end
