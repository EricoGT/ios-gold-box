//
//  WBRHomeManager.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 11/23/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelStaticHome.h"
#import "ModelShowcases.h"
#import "HomeModel.h"

@interface WBRHomeManager : NSObject

/**
 *  Loads the static home from API
 *
 *  @param successBlock void(^)(HomeModel *) with the loaded home
 *  @param failureBlock void(^)()
 */
+ (void)loadStaticHomeWithSuccessBlock:(void (^)(HomeModel *home))successBlock failureBlock:(void (^)())failureBlock;

/**
 *  Loads the dynamic showcases from API
 *
 *  @param successBlock void(^)(NSArray *) with the loaded showcases
 *  @param failureBlock void(^)()
 */
+ (void)loadDynamicHomeWithSuccessBlock:(void (^)(NSArray *showcases))successBlock failureBlock:(void (^)())failureBlock;

/**
 *  Registers the loaded showcases within the Retargeting Tracking
 *
 */
+ (void)registerShowcases:(NSArray *)showCases;
@end
