//
//  MDSSqlite.h
//  VcTube
//
//  Created by Marcelo Santos on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@protocol databaseDelegate <NSObject>
@optional
- (void) finishedOperationDatabaseSplash:(NSString *) splashId;
- (void) finishedOperationDatabaseSkin:(NSString *) skinName;
- (void) errorDatabase;
@end

@interface MDSSqlite : NSObject

@property (weak) id <databaseDelegate> delegate;
@property (nonatomic, retain) NSString *dbpath;

- (BOOL) verifyDBExists;

//Insert all data from splash
- (void) addImageName:(NSString *) imgName andSplashId:(NSString *) splashId andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor;
- (void) addSplashDefaultImageName:(NSString *) imgName andSplashId:(NSString *) splashId andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor;

//Insert all data from skin
- (void) addSkinName:(NSString *) skinName andPriceBarColor:(NSString *) barColor andDescriptionColor:(NSString *) descColor andInstalmentColor:(NSString *) instColor andDiscountColor:(NSString *) discountColor andBaseImageUrl:(NSString *) baseImgUrl andImgIds:(NSString *) imgIds andOrigPriceColor:(NSString *) origPriceColor andBgColor:(NSString *) bgColor andPageControlColor:(NSString *) pageControlColor andHomeBgColor:(NSString *) homeBgColor andCartBgColor:(NSString *) cartBgColor andPressedBgColor:(NSString *) pressedBgColor andBannerBgColor:(NSString *) bannerBgColor andCartBgPressedColor:(NSString *) cartBgPressedColor andBtnBgColor:(NSString *) btnBgColor;

//Update all data from splash
- (void) updateSplashId:(NSString *) splashId andImgName:(NSString *) imgName andRatio:(NSString *) ratio andBgColor:(NSArray *) bgcolor;

//Update all data from skin
- (void) updateSkinName:(NSString *) skinName andPriceBarColor:(NSString *) barColor andDescriptionColor:(NSString *) descColor andInstalmentColor:(NSString *) instColor andDiscountColor:(NSString *) discountColor andBaseImageUrl:(NSString *) baseImgUrl andImgIds:(NSString *) imgIds andOrigPriceColor:(NSString *) origPriceColor andBgColor:(NSString *) bgColor andPageControlColor:(NSString *) pageControlColor andHomeBgColor:(NSString *) homeBgColor andCartBgColor:(NSString *) cartBgColor andPressedBgColor:(NSString *) pressedBgColor andBannerBgColor:(NSString *) bannerBgColor andCartBgPressedColor:(NSString *) cartBgPressedColor andBtnBgColor:(NSString *) btnBgColor;

//Select all data from splash
- (NSArray *) getSplashAllDataFromId:(NSString *) splashId;

//Select all data from Skin
- (NSArray *) getSkinAllDataFromId:(NSString *) skinName;

//Verify if splash exists
- (BOOL) verifySplashId:(NSString *) splashId;

//Verify if skin exists
- (BOOL) verifySkinId:(NSString *) skinId;

//Select all products from cart
- (NSArray *) getCart;

//Insert product in cart
- (void) addProductInCart:(NSDictionary *) dictProduct;

//Update product in Cart
- (void) updateProductInCart:(NSDictionary *) dictProduct andExtend:(NSString *) extValue;
- (void) updateQtyProductInCart:(NSDictionary *) dictProduct;

//Verify if product already in cart
- (BOOL) productInCart:(NSString *) skuProduct andExtended:(NSString *) valueExtended;

//Delete a product
- (void) deleteProduct:(NSString *)sku andExtendValue:(NSString *) extValue;

//Clean the cart
- (void)cleanCart;

//Verify by Column
- (BOOL) verifyByTable:(NSString *) table;

//Get Token OAuth
//- (NSString *) getTokenAuth;
//Get Token Checkout
- (NSString *) getTokenCheck;
//Get CartId
- (NSString *) getCartId;

//Add Token OAuth
//- (BOOL) addTokenAuth:(NSString *) token;
//Add Token Checkout
- (BOOL) addTokenCheck:(NSString *) token;
//Add CartId
- (BOOL) addCartId:(NSString *) cart;

//Delete Token OAuth
//- (BOOL) deleteAllTokenAuth;
//- (BOOL) deleteTokenAuth:(NSString *) token;
//Delete Token Checkout
- (BOOL) deleteAllTokenCheckout;
//- (BOOL) deleteTokenCheckout:(NSString *) token;
//Delete CartId
- (BOOL) deleteAllCartId;
//- (BOOL) deleteCartId:(NSString *) cart;

//Logs
- (BOOL) addLogsToService:(NSDictionary *) dictLogs;
- (NSArray *) getAllLogsFromDB;
- (void) deleteAllErrorsFromDB;

//Token Migration
+ (BOOL)hasOldToken;
+ (void)clearOldToken;

@end
