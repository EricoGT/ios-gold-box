//
//  OFSetup.h
//  Walmart
//
//  Created by Bruno Delgado on 5/21/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved..
//

#import <Foundation/Foundation.h>

@interface OFSetup : NSObject

//Refresh Time interval home (seconds)
//#define HOME_STATIC_INTERVAL 0 //default:300
//#define HOME_DYNAMIC_INTERVAL 1.80 //default: 180


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH > 736.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define kAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define timeoutRequest 35.0f

/**
 Internet connection verification
 
 @return boolean YES or NOT
 */
+ (BOOL)hasActiveConnection;

/**
 Show or hide Banking Ticket option (boleto bancario)
 
 @return boolean YES or NOT
 */
+ (BOOL)showBankingTicket;


/**
 Show or hide My Account

 @return boolean YES or NOT
 */
+ (BOOL)showMyAccount;

+ (BOOL)showSearch;
+ (BOOL)showFilter;
+ (BOOL)showDepartmentsOnMenu;
+ (BOOL)showRatingAlertView;

+ (BOOL)testCollections;
+ (NSArray *)arrTestCollections;

+ (BOOL) testVariations;
+ (NSString *) idProductVariations;

+ (BOOL) testAdviseMe;
+ (BOOL) showBannerDelivery;

- (void) setShowAccount:(BOOL) show;
- (void) setShowBannerDelivery:(BOOL) show;
- (void) setShowDepartmentsOnMenu:(BOOL) show;
- (void) setShowExtendedWarrantyInSelfHelp:(BOOL) show;

+ (BOOL) logsEnable;
+ (BOOL) backgroundEnable;

+ (BOOL) extendedWarrantyEnableNewCard;
+ (BOOL) extendedWarrantyEnableFeature;
+ (BOOL) showHomeError;

+ (BOOL) useNewTrackingURL;
+ (BOOL) enableNewDoublePayment;

+ (BOOL) enableMockHome;
+ (BOOL)showNewInvoiceInTracking;

+ (BOOL) showExtendedWarrantyInSelfHelp;

+ (BOOL)enableInstallmentsWithRateInPaymentForms;
+ (BOOL)enableInstallmentsWithRateInCheckout;

+ (BOOL)enableFacebookDeepLink;
+ (BOOL)enableFacebookButton;

+ (BOOL)enableUTMI;

+ (BOOL)enableWishlist;
+ (BOOL)canAddProductsToTheWishlistOutsideProductDetail;

+ (BOOL)enableTouchID;

+ (BOOL)enableShowcaseColorsCount;

+ (NSDictionary *) infoAppToServer;

+ (BOOL)enableBankSlipDiscount;

@end
