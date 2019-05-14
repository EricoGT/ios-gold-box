//
//  OFUrls.h
//  Ofertas
//
//  Created by Marcelo Santos on 7/24/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_VERSION @"v1"
#define APP_VERSION2 @"v2"

//Pre release version use: || CONFIGURATION_EnterprisePR
//Beta Version use: || CONFIGURATION_EnterpriseTK

//URL correct
#if defined CONFIGURATION_EnterpriseQA || DEBUGQA || CONFIGURATION_TestWm || CONFIGURATION_EnterprisePR || CONFIGURATION_DebugCalabash //QA
#define BASE_URL @"https://m.waldev.com.br/api/mobile/"
//#define BASE_URL @"https://localhost:9010/mobile/" //Local
//#define BASE_URL @"https://172.28.232.55:9010/mobile/" //Maquina
//#define BASE_URL @"https://m.stg.waldev.com.br/api/mobile/" //Staging
//#define BASE_URL @"https://api-ws.walmart.com.br/api/mobile/" //Prod
//#define BASE_URL @"https://napsao-nix-apiserver-mobile-1.vmcommerce.intra/api/mobile/" //Machine
//#define BASE_URL @"https://napsao-nix-qa-apiserver-mobile-1.qa.vmcommerce.intra/api/mobile/" //Machine1
#define BASE_URL_CONNECT @"https://connect.qa.waldev.com.br/connect/"
#define RETARGETING_TRACKING_URL @"https://vip-rtg-watcher-serv.qa.vmcommerce.intra"
#define BASE_URL_WEBSTORE @"https://qa.webstore.waldev.com.br/api/selfhelp/"
#define BASE_URL_TICKET_HUB @"https://ticket.waldev.com.br/api/v1/"

#else
#if defined CONFIGURATION_Staging //Staging
#define BASE_URL @"https://m.stg.waldev.com.br/api/mobile/"
#define BASE_URL_CONNECT @"https://connect.stg.waldev.com.br/connect/"
#define RETARGETING_TRACKING_URL @"https://vip-rtg-watcher-serv.stg.vmcommerce.intra"
#define BASE_URL_WEBSTORE @"https://stg.webstore.waldev.com.br/api/selfhelp/"
#define BASE_URL_TICKET_HUB @"https://ticket.walmart.com.br/api/v1/"

#else //Prod
#define BASE_URL @"https://api-ws.walmart.com.br/api/mobile/"
#define BASE_URL_CONNECT @"https://connect.walmart.com.br/connect/"
#define RETARGETING_TRACKING_URL @"https://rtgtracking.walmart.com.br"
#define BASE_URL_WEBSTORE @"https://www2.walmart.com.br/api/selfhelp/"
#define BASE_URL_TICKET_HUB @"https://ticket.walmart.com.br/api/v1/"

#endif
#endif

//Login Connect
#define AUTH_URL BASE_URL_CONNECT @"token"

//Facebook
#define URL_IMG_USER_FACEBOOK @"https://graph.facebook.com/"

#define URL_CONNECT_FACEBOOK BASE_URL_CONNECT @"social-network/auth/mob"
#define URL_UNLINK_FACEBOOK BASE_URL_CONNECT @"social-network/unlink/FACEBOOK"
#define URL_LINK_FACEBOOK BASE_URL_CONNECT @"social-network/auth/mob/app/logged"

#define URL_SPLASH @"splash"
#define URL_SKIN @"skin" //Changed Feb/12/2014

#define URL_SPLASH_BF @"splash/black_friday"
#define URL_SKIN_BF @"skin/black_friday"

//#define URL_SPLASH @"splash/black_friday"
//#define URL_SKIN @"skin/black_friday"

//Banking Slip (Boleto)
#define URL_BANKING_SLIP BASE_URL APP_VERSION @"/" @"order/bankslip"

//Log services
#define URL_LOG BASE_URL APP_VERSION @"/" @"log"

//Product Details REST
#define URL_PRODUTO @"products"
//#define URL_PRODUTO_NEW @"products/new"
#define URL_PRODUTO_NEW @"products/global"
#define URL_PRODUTO_NEW_SKU @"products/sku/"

//Product Details Price Variations
#define URL_PRODUTO_PRICE BASE_URL APP_VERSION @"/" @"price/"

//Specification REST
#define URL_SPECIFICATION @"products/"
#define URL_SPECIFICATION_ENDPOINT @"specification/"
#define URL_SPECIFICATION_TRANSLATED @"translated/"

//Description Product
#define URL_DESCRIPTION @"products/"
#define URL_DESCRIPTION_ENDPOINT @"description"
#define URL_DESCRIPTION_TRANSLATED @"translateProduct/"

#define URL_PERSONAL_DATA @"/users/me"

//Shipment Address REST
#define URL_SHIPMENT_ADDRESSES @"users/address"
#define URL_MY_ADDRESSES @"/users/new/address"

//Home List Offers REST
//#define URL_LISTOFFERS @"categories"
#define URL_LISTOFFERS @"new/categories"
#define URL_LISTOFFERS_NEW  BASE_URL APP_VERSION @"/" @"home"

//Home Categories REST
#define URL_CATEGORIES @"categories"

//Extended Warranty REST
#define URL_EXTENDED_WARRANTY @"products/"
#define URL_EXTENDED_WARRANTY_ENDPOINT @"warranty/"
#define URL_NEW_EXTENDED_WARRANTY   BASE_URL APP_VERSION @"/" @"warranty/description"
#define URL_EXTENDED_WARRANTY_LICENSE BASE_URL APP_VERSION @"/warranty/license"
#define URL_EXTENDED_WARRANTY_CANCEL @"/users/warranties/cancel"
#define URL_EXTENDED_WARRANTY_CANCEL_OPTIONS URL_EXTENDED_WARRANTY_CANCEL @"/data"

//Send Feedback REST
#define URL_SEND_FEEDBACK @"setup/feedback"

//Address REST
#define URL_NEW_ADDRESS @"users/address/"
#define URL_UPDATE_ADDRESS @"users/address/"
#define URL_DELETE_ADDRESS @"users/address/"
#define URL_ZIP_ADDRESS @"checkout/address/"
#define URL_SHIPMENT_INFOS @"cart/shipping/html/"
#define URL_SHIPMENT_INFOS_2 @"checkout/freight/"

//Simulate Shopping Cart REST
#define URL_SHOPPING_CART @"cart"
#define URL_SHIPPINGS @"checkout/shippings"

//Update Users REST
#define URL_UPDATE_USER @"users/"
#define URL_NEW_USER @"users/"

//Installments REST
#define URL_INSTALLMENTS @"checkout/card/"

//Payments REST
#define URL_PAYMENTS @"installment/"


//PO Rest
#define URL_PO @"checkout/order"

//Change Password
#define URL_CHANGE_PASSWORD @"/users/password"

//Change Password
#define URL_CHANGE_EMAIL @"/users/email"

//Recover Password
#define URL_RECOVER_PASSWORD @"password/recover"

//Logout
#define URL_LOGOUT BASE_URL APP_VERSION @"/" @"logout"

//NEW CHECKOUT
#define URL_CART_LOAD       BASE_URL APP_VERSION @"/" @"cart/loadCart"

#define URL_CART_ADDPRODUCT BASE_URL APP_VERSION @"/" @"cart/add/seller/1/sku/"

//#define URL_CART_ADDPRODUCT_NEW BASE_URL APP_VERSION @"/" @"cart/addAllProducts/seller/1/sku/"
#define URL_CART_ADDPRODUCT_NEW BASE_URL APP_VERSION @"/" @"cart/addAllProducts/seller/"


#define URL_CART_UPDPRODUCT BASE_URL APP_VERSION @"/" @"cart/updateCart"
#define URL_CART_DELPRODUCT BASE_URL APP_VERSION @"/" @"cart/removeProduct"

#define URL_CONVERT_TOKEN   BASE_URL APP_VERSION @"/" @"checkout/token"
#define URL_LIST_ADDRESS    BASE_URL APP_VERSION @"/" @"checkout/address"

//Tracking
#define URL_ORDERS @"/users/new/orders"
#define URL_ORDER_DETAIL @"/users/new/orders"

#define URL_OLD_ORDERS @"/users/orders"
#define URL_OLD_ORDER_DETAIL @"/users/orders"

#define URL_ORDER_STATUS_DETAIL @"/delivery_status"

//Freight
#define URL_FREIGHT @"checkout/freight"

//Shipment Options
#define URL_SHIPMENT_OPTIONS BASE_URL APP_VERSION @"/" @"cart/findGroupedCart/"

//Payment
#define URL_PAYMENT_WITHOUT_CART BASE_URL APP_VERSION @"/" @"payment/dataBin"
#define URL_PAYMENT_WITH_CART BASE_URL APP_VERSION @"/" @"cart/selectDeliveryPaymentWithCompleteCart"
#define URL_PAYMENT_INSTALLMENTS  BASE_URL APP_VERSION @"/" @"checkout/installments"

//Place Order
#define URL_PLACE_ORDER BASE_URL APP_VERSION @"/" @"order"

//Search
//#define URL_SEARCH_SUGGESTIONS @"https://www.walmart.com.br/ws/suggest?size=10&q=%@&fields=departments"
#define URL_SEARCH_SUGGESTIONS @"https://suggestion.walmart.com.br/suggest?size=10&q=%@&fields=departmentNames"
#define URL_SEARCH_CATEGORIES @"/search/product/%@"
#define URL_SEARCH_PRODUCTS @"/search/product/%@/dpto/%@/start/%d"
#define URL_SEARCH_PRODUCTS_BY_CATEGORY_NAME @"/search/product/%@/dptoname/%@/start/%d"

//Push
#define URL_REGISTER_PUSH_WALMART_SERVER @"/setup/pushbox/device"
#define URL_REMOVE_PUSH_WALMART_SERVER @"/setup/pushbox/device/"

//Menu
#define URL_MENU_ITEMS @"/menu"

//Hubs
#define URL_HUB @"/hub"
#define URL_OFFERS @"/hub/offers/"

//Extended Warranty
#define URL_EXTENDED_WARRANTY_LIST @"/users/warranties/"

//Contact Request
#define URL_CONTACT_SUBJECTS @"/contact/subjects"

//Seller
#define URL_SELLER_DESCRIPTION @"/seller/"

//Home
#define URL_HOME @"/home"

//Services
#define URL_SERVICES @"/services"

//Track
#define BASE_TRACK @"/track"
#define URL_TRACK_DEPARTMENT @"/department"
#define URL_TRACK_CATEGORY @"/category"
#define URL_TRACK_SUBCATEGORY @"/subcategory"
#define URL_TRACK_CHECKOUT @"/checkout/track"
#define URL_TRACK_ORDER @"/order/track"

//WISHLIST
#define WISHLIST_ENDPOINT @"/wishlist"
#define WISHLIST_SKUS_ENDPOINT [NSString stringWithFormat:@"%@%@", WISHLIST_ENDPOINT, @"/skus"]

#define URL_PRIVACY @"https://www.walmart.com.br/institucional/politica-privacidade/"
#define URL_TERMS @"https://www.walmart.com.br/institucional/termos-uso/"
#define URL_TERMS_MOBILE @"https://m.walmart.com.br/institucional/termos-uso/?uam=true"
#define URL_TERMS_MARKET_PLACE @"https://m.walmart.com.br/institucional/termos-uso-marketplace/"
#define URL_CHANGE_OR_RETURN_PRODUCT @"https://www.walmart.com.br/institucional/politica-entrega-troca-devolucao"

//reviews
#define URL_PRODUCT_REVIEWS BASE_URL APP_VERSION @"/" @"navigation/product/%@/review?pageNumber=%@"
#define URL_PRODUCT_REVIEW BASE_URL APP_VERSION @"/" @"navigation" @"/" @"product"
#define URL_EVALUATE_PRODUCT_REVIEW_URL BASE_URL APP_VERSION @"/" @"navigation/product/%@/review/%@/relevance"

@interface OFUrls : NSObject {
    
    int randomNumber;
}

@property (assign) int randomNumber;

+ (NSURL *)urlWithAppVersion:(int)appVersion pathComponents:(NSArray *)pathComponents;
+ (NSURL *)urlWithPathComponents:(NSArray *)pathComponents;

- (NSString *) getBaseURLWithAppVersion;
- (NSString *) getURLSplash;
- (NSString *) getURLSkin;
- (NSString *) getURLProduct;
- (NSString *) getURLProductSKU;
- (NSString *) getURLSpecification;
- (NSString *) getURLSpecificationEndPoint;
- (NSString *) getURLSpecificationTranslated;
- (NSString *) getURLDescription;
- (NSString *) getURLDescriptionEndPoint;
- (NSString *) getURLDescriptionTranslated;
- (NSString *) getURLShipmentAddresses;
- (NSString *) getURLListOffers;
- (NSString *) getURLCategories;
- (NSString *) getURLExtendedWarranty;
- (NSString *) getURLSendFeedback;
- (NSString *) getURLNewAddress;
- (NSString *) getURLUpdateAddress;
- (NSString *) getURLDeleteAddress;
- (NSString *) getURLZipInfo;
- (NSString *) getURLShoppingCart;
- (NSString *) getURLShipmentInfos;
- (NSString *) getURLShipmentInfos2;
- (NSString *) getURLFreight;
- (NSString *) getURLUpdateUser;
- (NSString *) getURLShippings;
- (NSString *) getURLInstallments;
- (NSString *) getURLPayments;
- (NSString *) getURLNewUser;
- (NSString *) getURLPO;
- (NSString *) getURLRequestPassword;
- (NSString *) getURLOrders;
- (NSString *) getURLOrdersDetail;
- (NSString *) getURLOrderStatusDetail;
- (NSString *) getURLSuggestions;
- (NSString *) getURLSearch;
- (NSString *) getURLSearchProducts;
- (NSString *) getURLSearchProductsByCategoryName;
- (NSString *) getURLRegisterDeviceInServer;
- (NSString *) getURLRemoveDeviceFromServer;
- (NSString *) getURLMenu;
- (NSString *) getURLHub;
- (NSString *) getURLOffers;
- (NSString *) getURLExtendedWarrantyLicense;
- (NSString *) getURLPersonalData;
- (NSString *) getURLChangePassword;
- (NSString *) getURLChangeEmail;
- (NSString *) getURLMyAddresses;
- (NSString *) getURLExtendedWarrantyList;
- (NSString *) getURLExtendedWarrantyCancel;
- (NSString *) getURLExtendedWarrantyCancelOptions;
- (NSString *) getURLSellerDescriptionWithSellerId:(NSString *)sellerId;
- (NSString *) getURLServices;
- (NSString *) getURLRetargetingDepartment;
- (NSString *) getURLRetargetingCategory;
- (NSString *) getURLRetargetingSubcategory;
- (NSString *) getURLRetargetingCheckout;
- (NSString *) getURLRetargetingOrderSuccess;
- (NSString *) getURLWishlistListEndpoint;
- (NSString *) getURLWishlistSkus;
- (NSString *) getURLPrivacy;
- (NSString *) getURLTerms;
- (NSString *) getURLTermsMarketPlace;
- (NSString *) getURLChangeOrReturnProduct;
- (NSString *) getUrlPostProductReviewWithProductId:(NSString *)productId;

- (NSURL *)descriptionURLWithProductId:(NSString *)productId;
- (NSURL *)specificationURLWithProductId:(NSString *)productId;

+ (NSURL *)extendedWarrantyURLWithSKU:(NSNumber *)sku;
+ (NSURL *)skuURLWithSKU:(NSNumber *)sku;
+ (NSURL *)getURLToken;

+ (NSString *)getURLPostProductReviewEvaluation:(NSNumber *)productId reviewId:(NSNumber *)reviewId;
+ (NSString *)getURLContactTicketCommentsWithTicketId:(NSString *)ticketId;
+ (NSString *)getURLContactTicketCommentUploadAttachment;
+ (NSString *)getURLContactTicketCommentDownloadAttachmentWithAttachmentId:(NSString *)attachmentId andTicketId:(NSString *)ticketId andCommentId:(NSString *)commentId;

+ (NSString *)addQueryParameterToURL:(NSString *)url queryParameter:(NSString *)parameter value:(BOOL)value;

@end
