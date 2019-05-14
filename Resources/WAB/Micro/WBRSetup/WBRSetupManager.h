//
//  WBRSetupManager.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/12/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelAlert.h"
#import "ModelBaseImages.h"
#import "ModelServices.h"
#import "ModelSkin.h"
#import "ModelSplash.h"
#import "ModelErrata.h"
#import "ModelBanner.h"
#import "WBRStampCampaign.h"
#import "ModelSetup.h"
#import "WBRInstallCampaign.h"

typedef void(^kSetupManagerSuccessBlock)(ModelSetup *setupModel);
typedef void(^kSetupManagerFailureBlock)(NSError *error);

/**
 <b>Provides informations</b> about Alert, Base Images, Services (toggles), Skin and Splash.<br>
 <b>Optional items:</b> Alert, Skin and Splash.
 */
@interface WBRSetupManager : NSObject

/**
 Provides parameters for <b>blocking or not blocking</b> the application. This is an optional item.
 
 @param success Alert model with keys: block, message, url, version, system, title, buttonOk and buttonCancel.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getAlert:(void (^)(ModelAlert *alertModel))success failure:(void (^)(NSDictionary *dictError))failure;

/**
 Provides parameters <b>base url for acquire images</b> in showcases and product detail.
 
 @param success BaseImages model with keys: products, showcases.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getBaseImages:(void (^)(ModelBaseImages *baseImagesModel))success failure:(void (^)(NSDictionary *dictError))failure;

+ (ModelBaseImages *) baseImages;


/**
 Provides <b>control toggles</b> parameters.
 
 @param success Services model with keys: tracking, showDepartmentsOnMenu, paymentByBankSlip.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getServices:(void (^)(ModelServices *servicesModel))success failure:(void (^)(NSDictionary *dictError))failure;


/**
 Provides parameters to <b>modify visual identity for special events</b>. This is an optional item.
 
 @param success Skim model with keys: idSkin, name, home background color (RGB) and home header color (RGB).
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getSkin:(void (^)(ModelSkin *skinModel))success failure:(void (^)(NSDictionary *dictError))failure;


/**
 Provides parameters to <b>modify splash when application is opened</b>. This is an optional item.
 
 @param success Splash model with keys: idSkin, name, image and background color (RGB).
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getSplash:(void (^)(ModelSplash *splashModel))success failure:(void (^)(NSDictionary *dictError))failure;


/**
 Provides parameters to <b>show errata when home is loaded</b>. This is an optional item.
 
 @param success Errata model with keys: urlImage, title, message and url.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getErrata:(void (^)(ModelErrata *errataModel))success failure:(void (^)(NSDictionary *dictError))failure;


/**
 Provides parameters to <b>show banners when home is loaded</b>. This is an optional item.
 
 @param success Banner model with keys: top and bottom.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
+ (void) getBanners:(void (^)(ModelBanner *bannerModel))success failure:(void (^)(NSDictionary *dictError))failure;

/**
 Get Stamp campaign for card brands
 
 @param success success block
 @param failure failure block
 */
+ (void) getStampCampaign:(void (^)(WBRStampCampaign *stampModel))success failure:(void (^)(NSDictionary *dictError))failure;

/**
 Get the Install Campaign active on Walmart

 @param success success block
 @param failure failure block
 */
+ (void) getInstallCampaign:(void (^)(WBRInstallCampaign *installCampaignModel))success failure:(void (^)(NSDictionary *dictError))failure;

/**
 Get the about info

 @return return the string with about text
 */
+ (NSString *)aboutInfo;


/**
 Provides the text for the Master Card Campaign to legal text
 
 @return string with the legal text
 */
+ (NSString *)stampCampaignDisclaimer;

@end
