//
//  WBRProductConnection.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCategoryResult.h"
#import "PaymentForms.h"
#import "WBRModelSendReview.h"

/**
 ## Mock Control
 
 * **CONFIGURATION_Release, CONFIGURATION_EnterpriseTK and DEBUG**:<br>
 _Build Production_<br>
 Should ALWAYS be configured with NO.<br>
 * **CONFIGURATION_DebugCalabash or CONFIGURATION_TestWm**:<br>
 _Build for test_<br>
 Choose YES or NO as required.<br>
 * **OTHER BUILDS**:<br>
 Choose YES or NO as required.
 */
// MOCK Control---------------------------------------
#if defined CONFIGURATION_Release || CONFIGURATION_EnterpriseTK || DEBUG
#define USE_MOCK_SEARCH NO
#define USE_MOCK_PRODUCT_DETAIL NO
#define USE_MOCK_PRODUCT_WARRANTY NO
#define USE_MOCK_PAYMENT_FORMS NO
#define USE_MOCK_PRODUCT_REVIEWS NO

#else
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_SEARCH YES
#define USE_MOCK_PRODUCT_DETAIL YES
#define USE_MOCK_PRODUCT_WARRANTY YES
#define USE_MOCK_PAYMENT_FORMS YES
#define USE_MOCK_PRODUCT_REVIEWS YES

#else
#define USE_MOCK_SEARCH NO
#define USE_MOCK_PRODUCT_DETAIL NO
#define USE_MOCK_PRODUCT_WARRANTY NO
#define USE_MOCK_PAYMENT_FORMS NO
#define USE_MOCK_PRODUCT_REVIEWS NO

#endif
#endif
// ---------------------------------------------------

typedef void(^kProductConnectionSuccessBlock)(NSDictionary *dataJson);
typedef void(^kProductConnectionFailureBlock)(NSDictionary *dictError);

@interface WBRProductConnection : NSObject

- (void) requestSearchQuery:(NSString *)query sortParameter:(NSString *)sortParam successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

- (void) requestProductDetail:(NSString *)urlProdDetail showcaseId:(NSString *)showcaseId successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

- (void) requestWarrantyProductDetail:(NSString *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

- (void) requestPaymentForms:(NSDictionary *) dictProductInfo successBlock:(void (^)(PaymentForms *payment)) success failure:(void (^) (NSDictionary *dictError)) failure;

- (void) requestProductReviews:(NSString *)urlProdReviews successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

/**
 Request to add product review
 
 @param productReview product review object
 @param completion BOOL success, NSError and NSData
 */
- (void)sendProductReview:(WBRModelSendReview *)productReview withProductId:(NSString *)productId successBlock:(kProductConnectionSuccessBlock)success failure:(kProductConnectionFailureBlock)failure;

- (void)postProductReviewEvaluation:(NSString *)reviewURL evaluation:(NSNumber *)evaluation successBlock:(kProductConnectionSuccessBlock)success failure:(kProductConnectionFailureBlock)failure;

@end
