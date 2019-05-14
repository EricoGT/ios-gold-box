//
//  OFUrls.m
//  Ofertas
//
//  Created by Marcelo Santos on 7/24/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFUrls.h"
#import "OFSetup.h"

@implementation OFUrls

@synthesize randomNumber;

+ (NSURL *)urlWithAppVersion:(int)appVersion pathComponents:(NSArray *)pathComponents {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@v%d/%@", BASE_URL, appVersion, [pathComponents componentsJoinedByString:@"/"]]];
}

+ (NSURL *)urlWithPathComponents:(NSArray *)pathComponents {
    return [OFUrls urlWithAppVersion:1 pathComponents:pathComponents];
}

- (NSString *)getBaseURLWithAppVersion {
    return [NSString stringWithFormat:@"%@%@", BASE_URL, APP_VERSION];
}

- (NSString *) getURLSplash {
    
//#ifdef CONFIGURATION_BetaQA
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_skin"]) {
//        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPLASH_BF];
//    } else {
//        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPLASH];
//    }
//#endif
//    
//#ifdef DEBUGQA
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_skin"]) {
//        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPLASH_BF];
//    } else {
//        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPLASH];
//    }
//#endif
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_skin"]) {
        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPLASH_BF];
    } else {
        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, @"v2", URL_SPLASH];
    }
}
- (NSString *) getURLSkin {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_skin"]) {
        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SKIN_BF];
    } else {
        return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SKIN];
    }
}
- (NSString *) getURLProduct {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_PRODUTO_NEW];
}
- (NSString *) getURLProductSKU {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_PRODUTO_NEW_SKU];
}
- (NSString *) getURLSpecification {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SPECIFICATION];
}
- (NSString *) getURLSpecificationEndPoint {
    return URL_SPECIFICATION_ENDPOINT;
}
- (NSString *) getURLSpecificationTranslated {
    return URL_SPECIFICATION_TRANSLATED;
}

- (NSURL *)specificationURLWithProductId:(NSString *)productId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@%@/%@", BASE_URL, APP_VERSION, URL_SPECIFICATION, productId, URL_SPECIFICATION_ENDPOINT]];
}

- (NSURL *)descriptionURLWithProductId:(NSString *)productId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@%@/%@", BASE_URL, APP_VERSION, URL_DESCRIPTION, productId, URL_DESCRIPTION_ENDPOINT]];
}

- (NSString *) getURLDescription {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_DESCRIPTION];
}
- (NSString *) getURLDescriptionTranslated {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_DESCRIPTION_TRANSLATED];
}

- (NSString *) getURLDescriptionEndPoint {
    return URL_DESCRIPTION_ENDPOINT;
}
- (NSString *) getURLShipmentAddresses {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SHIPMENT_ADDRESSES];
}
- (NSString *) getURLListOffers {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_LISTOFFERS];
}
- (NSString *) getURLCategories {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_CATEGORIES];
}
- (NSString *) getURLExtendedWarranty {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_EXTENDED_WARRANTY];
}
- (NSString *) getURLSendFeedback {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SEND_FEEDBACK];
}
- (NSString *) getURLNewAddress {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_NEW_ADDRESS];
}
- (NSString *) getURLShoppingCart {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SHOPPING_CART];
}
- (NSString *) getURLUpdateAddress {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_UPDATE_ADDRESS];
}
- (NSString *) getURLDeleteAddress {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_DELETE_ADDRESS];
}
- (NSString *) getURLZipInfo {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_ZIP_ADDRESS];
}
- (NSString *) getURLShipmentInfos {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SHIPMENT_INFOS];
}
- (NSString *) getURLShipmentInfos2 {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SHIPMENT_INFOS_2];
}
- (NSString *) getURLFreight {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_FREIGHT];
}
- (NSString *) getURLUpdateUser {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_UPDATE_USER];
}
- (NSString *) getURLNewUser {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_NEW_USER];
}
- (NSString *) getURLShippings {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_SHIPPINGS];
}

- (NSString *) getURLPayments {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_PAYMENTS];
}
- (NSString *) getURLInstallments {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_INSTALLMENTS];
}
- (NSString *) getURLPO {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_PO];
}

- (NSString *) getURLRequestPassword {
    return [NSString stringWithFormat:@"%@%@/%@", BASE_URL, APP_VERSION, URL_RECOVER_PASSWORD];
}
- (NSString *)getURLOrders {
    if ([OFSetup useNewTrackingURL])
    {
        return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_ORDERS];
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_OLD_ORDERS];
    }
}

- (NSString *)getURLOrdersDetail{
    if ([OFSetup useNewTrackingURL])
    {
        return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_ORDER_DETAIL];
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_OLD_ORDER_DETAIL];
    }
}

- (NSString *)getURLOrderStatusDetail{
    return [NSString stringWithFormat:@"%@%@%@/", BASE_URL, APP_VERSION, URL_ORDER_STATUS_DETAIL];
}
- (NSString *) getURLSuggestions {
    return URL_SEARCH_SUGGESTIONS;
}
- (NSString *) getURLSearch {
    //return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_SEARCH_CATEGORIES];
//    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, @"/search/new/product/%@"];
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, @"/search/global/product/%@"];

}
- (NSString *) getURLSearchProducts {
    return [NSString stringWithFormat:@"%@%@%@/", BASE_URL, APP_VERSION, URL_SEARCH_PRODUCTS];
}
- (NSString *) getURLSearchProductsByCategoryName {
    return [NSString stringWithFormat:@"%@%@%@/", BASE_URL, APP_VERSION, URL_SEARCH_PRODUCTS_BY_CATEGORY_NAME];
}
- (NSString *) getURLRegisterDeviceInServer {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_REGISTER_PUSH_WALMART_SERVER];
}
- (NSString *) getURLRemoveDeviceFromServer {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_REMOVE_PUSH_WALMART_SERVER];
}

//Menu
- (NSString *) getURLMenu {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_MENU_ITEMS];
}

//Hub
- (NSString *) getURLHub {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_HUB];
}

- (NSString *) getURLOffers {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_OFFERS];
}

//Extended Warranty
- (NSString *) getURLExtendedWarrantyLicense {
    return URL_EXTENDED_WARRANTY_LICENSE;
}

//Personal Data
- (NSString *) getURLPersonalData {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_PERSONAL_DATA];
}

//Change Pwd
- (NSString *)getURLChangePassword {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_CHANGE_PASSWORD];
}

//Change Email
- (NSString *)getURLChangeEmail {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_CHANGE_EMAIL];
}

//My Addresses
- (NSString *)getURLMyAddresses {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_MY_ADDRESSES];
}

- (NSString *) getURLExtendedWarrantyList {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_EXTENDED_WARRANTY_LIST];
}

- (NSString *) getURLExtendedWarrantyCancel {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_EXTENDED_WARRANTY_CANCEL];
}

- (NSString *) getURLExtendedWarrantyCancelOptions {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_EXTENDED_WARRANTY_CANCEL_OPTIONS];
}

- (NSString *)getURLSellerDescriptionWithSellerId:(NSString *)sellerId {
    return [NSString stringWithFormat:@"%@%@%@%@", BASE_URL, APP_VERSION, URL_SELLER_DESCRIPTION, sellerId];
}

- (NSString *)getURLServices {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_SERVICES];
}

- (NSString *)getURLRetargetingDepartment {
    return [NSString stringWithFormat:@"%@%@%@%@", BASE_URL, APP_VERSION, BASE_TRACK, URL_TRACK_DEPARTMENT];
}

- (NSString *)getURLRetargetingCategory {
    return [NSString stringWithFormat:@"%@%@%@%@", BASE_URL, APP_VERSION, BASE_TRACK, URL_TRACK_CATEGORY];
}

- (NSString *)getURLRetargetingSubcategory {
    return [NSString stringWithFormat:@"%@%@%@%@", BASE_URL, APP_VERSION, BASE_TRACK, URL_TRACK_SUBCATEGORY];
}

- (NSString *)getURLRetargetingCheckout {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_TRACK_CHECKOUT];
}

- (NSString *)getURLRetargetingOrderSuccess {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, URL_TRACK_ORDER];
}

- (NSString *)getURLWishlistListEndpoint {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, WISHLIST_ENDPOINT];
}

- (NSString *)getURLWishlistSkus {
    return [NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, WISHLIST_SKUS_ENDPOINT];
}

- (NSString *) getURLPrivacy {
    return URL_PRIVACY;
}

- (NSString *) getURLTerms {
    return URL_TERMS;
}

- (NSString *) getURLTermsMarketPlace {
    return URL_TERMS_MARKET_PLACE;
}

- (NSString *) getURLChangeOrReturnProduct {
    return URL_CHANGE_OR_RETURN_PRODUCT;
}

- (NSString *)getUrlPostProductReviewWithProductId:(NSString *)productId {
    return [NSString stringWithFormat:@"%@/%@/review", URL_PRODUCT_REVIEW, productId];
}

+ (NSURL *)extendedWarrantyURLWithSKU:(NSNumber *)sku {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/%@/%@", BASE_URL, APP_VERSION, URL_PRODUTO_NEW, sku.stringValue, URL_EXTENDED_WARRANTY_ENDPOINT]];
}

+ (NSURL *)skuURLWithSKU:(NSNumber *)sku {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", BASE_URL, APP_VERSION, @"/price/", sku.stringValue]];
}

+ (NSURL *) getURLToken
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, APP_VERSION, @"/connect/token"]];
}

- (int) nrSorted {
    
    int nrSorted = arc4random()%2;
    
//    return 2; //For testing default
//    return 1; //For testing blackfriday
    return nrSorted+1;
}

+ (NSString *)getURLPostProductReviewEvaluation:(NSNumber *)productId reviewId:(NSNumber *)reviewId {
    
    return [NSString stringWithFormat:URL_EVALUATE_PRODUCT_REVIEW_URL, [productId stringValue], [reviewId stringValue]];
}


+ (NSString *)getURLContactTicketCommentsWithTicketId:(NSString *)ticketId {
    return [NSString stringWithFormat:@"%@/tickets/%@/comments?sort=asc", BASE_URL_TICKET_HUB, ticketId];
}

+ (NSString *)getURLContactTicketCommentUploadAttachment {
    return [NSString stringWithFormat:@"%@/tickets/file/upload", BASE_URL_TICKET_HUB];
}

+ (NSString *)getURLContactTicketCommentDownloadAttachmentWithAttachmentId:(NSString *)attachmentId andTicketId:(NSString *)ticketId andCommentId:(NSString *)commentId {
    return [NSString stringWithFormat:@"%@tickets/file/%@/download?ticketId=%@&commentId=%@", BASE_URL_TICKET_HUB, attachmentId, ticketId, commentId];
}

#pragma mark - URL Methods

+ (NSString *)addQueryParameterToURL:(NSString *)url queryParameter:(NSString *)parameter value:(BOOL)value {
    
    if ([url containsString:@"?"]) {
        url = [url stringByAppendingString:@"&"];
    }
    else {
        url = [url stringByAppendingString:@"?"];
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@=", parameter]];
    
    if (value == YES) {
        url = [url stringByAppendingString:@"true"];
    }
    else {
        url = [url stringByAppendingString:@"false"];
    }
    
    return url;
}

@end
