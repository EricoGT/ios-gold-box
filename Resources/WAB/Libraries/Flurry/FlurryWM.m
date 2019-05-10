//
//  FlurryWM.m
//  Walmart
//
//  Created by Marcelo Santos on 7/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "FlurryWM.h"
#import "Flurry.h"

//Home events
#define EVENT_HOME_ENTERING @"EVENT_HOME_ENTERING"
#define EVENT_HOME_CART_BTN @"EVENT_HOME_CART_BTN"
#define EVENT_HOME_MENU_BTN @"EVENT_HOME_MENU_BTN"
#define EVENT_HOME_FEEDBACK @"EVENT_HOME_FEEDBACK"
#define EVENT_HOME_PRODUCT_DETAILS @"EVENT_HOME_PRODUCT_DETAILS"
#define EVENT_HOME_SEE_ALL @"EVENT_HOME_SEE_ALL"
#define EVENT_TIMED_EVENT_PURCHASE @"EVENT_TIMED_EVENT_PURCHASE"

//Category events
#define EVENT_CATEGORY_PRODUCT_DETAILS @"EVENT_CATEGORY_PRODUCT_DETAILS"

//Menu events
#define EVENT_MENU_SIGNUP_BTN @"EVENT_MENU_SIGNUP_BTN"
#define EVENT_MENU_LOGIN_BTN @"EVENT_MENU_LOGIN_BTN"
#define EVENT_MENU_LOGOUT_BTN @"EVENT_MENU_LOGOUT_BTN"
#define EVENT_MENU_CATEGORY @"EVENT_MENU_CATEGORY"
//#define EVENT_MENU_NOTIFICATION_ON @"EVENT_MENU_NOTIFICATION_ON"
//#define EVENT_MENU_NOTIFICATION_OFF @"EVENT_MENU_NOTIFICATION_OFF"
#define EVENT_MENU_NOTIFICATION @"EVENT_MENU_NOTIFICATION"
#define EVENT_MENU_ABOUT_BTN @"EVENT_MENU_ABOUT_BTN"
#define EVENT_ABOUT_ENTERING @"EVENT_ABOUT_ENTERING"
#define EVENT_MENU_HELP_BTN @"EVENT_MENU_HELP_BTN"
#define EVENT_MENU_FEEDBACK_BTN @"EVENT_MENU_FEEDBACK_BTN"
#define EVENT_MENU_MOBILE_SITE_BTN @"EVENT_MENU_MOBILE_SITE_BTN"
#define EVENT_MENU_CONTACT_US @"EVENT_MENU_CONTACT_US"

//about
#define EVENT_TERMS_OF_CONTENT_ENTERING @"EVENT_TERMS_OF_CONTENT_ENTERING"
#define EVENT_PRIVACY_POLICY_ENTERING @"EVENT_PRIVACY_POLICY_ENTERING"
#define EVENT_DELIVERY_POLICY_ENTERING @"EVENT_DELIVERY_POLICY_ENTERING"

//help
#define EVENT_HELP_ENTERING @"EVENT_HELP_ENTERING"
#define EVENT_HELP_FEEDBACK @"EVENT_HELP_FEEDBACK"
#define EVENT_ORDER_COMPLETED_FEEDBACK @"EVENT_ORDER_COMPLETED_FEEDBACK"
//Signup events
#define EVENT_SIGNUP_ENTERING @"EVENT_SIGNUP_ENTERING"
#define EVENT_SIGNUP_SUCCESS @"EVENT_SIGNUP_SUCCESS"
#define EVENT_SIGNUP_ERR @"EVENT_SIGNUP_ERR"
#define EVENT_SIGNUP_TOC @"EVENT_SIGNUP_TOC"
#define EVENT_COMPLETE_ACCOUNT_ENTERING @"EVENT_COMPLETE_ACCOUNT_ENTERING"
//Login events
#define EVENT_LOGIN_ENTERING @"EVENT_LOGIN_ENTERING"
#define EVENT_LOGIN_BTN @"EVENT_LOGIN_BTN"
#define EVENT_LOGIN_SIGNUP @"EVENT_LOGIN_SIGNUP"
#define EVENT_LOGIN_FORGOT_PWD @"EVENT_LOGIN_FORGOT_PWD"
#define EVENT_LOGIN_ERR @"EVENT_LOGIN_ERR"

//Feedback events
#define EVENT_FEEDBACK_ENTERING @"EVENT_FEEDBACK_ENTERING"
#define EVENT_FEEDBACK_SENT @"EVENT_FEEDBACK_SENT"

//Product Details event
#define EVENT_DETAILS_ENTERING @"EVENT_DETAILS_ENTERING"
#define EVENT_DETAILS_CALC_SHIPPING_BTN @"EVENT_DETAILS_CALC_SHIPPING_BTN"
#define EVENT_DETAILS_SPEC_BTN @"EVENT_DETAILS_SPEC_BTN"
#define EVENT_DETAILS_DESC_BTN @"EVENT_DETAILS_DESC_BTN"
#define EVENT_DETAILS_BUY_BTN @"EVENT_DETAILS_BUY_BTN"
#define EVENT_PRODUCT_SPECIFICATION_ENTERING @"EVENT_PRODUCT_SPECIFICATION_ENTERING"
#define EVENT_PRODUCT_DESCRIPTION_ENTERING @"EVENT_PRODUCT_DESCRIPTION_ENTERING"

#define EVENT_DETAILS_CHECK_PAYMENT_BTN @"EVENT_DETAILS_CHECK_PAYMENT_BTN"
#define EVENT_DETAILS_ADD_TO_CART @"EVENT_DETAILS_ADD_TO_CART"


#define EVENT_DETAILS_CALC_SHIPPING_BTN             @"EVENT_DETAILS_CALC_SHIPPING_BTN"
#define EVENT_DETAILS_SELECT_VAR_DIALOG             @"EVENT_DETAILS_SELECT_VAR_DIALOG"
#define EVENT_CALC_SHIPPING_ENTERING                @"EVENT_CALC_SHIPPING_ENTERING"
#define EVENT_CAL_SHIPPING_GO                       @"EVENT_CAL_SHIPPING_GO"
#define EVENT_DETAILS_CHECK_PAYMENT_ENTERING        @"EVENT_DETAILS_CHECK_PAYMENT_ENTERING"
#define EVENT_DETAILS_ERR                           @"EVENT_DETAILS_ERR"
#define EVENT_SEARCH_RESULT_PRODUCT_SORT_BTN        @"EVENT_SEARCH_RESULT_PRODUCT_SORT_BTN"
#define EVENT_SEARCH_RESULT_PRODUCT_SORT_GO         @"EVENT_SEARCH_RESULT_PRODUCT_SORT_GO"
#define EVENT_DETAILS_REGISTER_PRODUCT_AVAILABILITY @"EVENT_DETAILS_REGISTER_PRODUCT_AVAILABILITY"
#define EVENT_DETAILS_CHECK_ZOOM_BTN                @"EVENT_DETAILS_CHECK_ZOOM_BTN"
#define EVENT_DETAILS_CHECK_ZOOM_EXIT               @"EVENT_DETAILS_CHECK_ZOOM_EXIT"

//Cart events
#define EVENT_CART_ENTERING @"EVENT_CART_ENTERING"
#define EVENT_CART_CALC_SHIPPING_BTN @"EVENT_CART_CALC_SHIPPING_BTN"
#define EVENT_CART_DELETE_BTN @"EVENT_CART_DELETE_BTN"
#define EVENT_CART_EMPTY @"EVENT_CART_EMPTY"
#define EVENT_CART_MORE_PRODUCTS_BTN @"EVENT_CART_MORE_PRODUCTS_BTN"
#define EVENT_CART_ORDER_DONE_BTN @"EVENT_CART_ORDER_DONE_BTN"
#define EVENT_CART_BACK_BTN @"EVENT_CART_BACK_BTN"
#define EVENT_CART_CHANGE_BTN @"EVENT_CART_CHANGE_BTN"

//Checkout Address
#define EVENT_CHECKOUT_SELECT_DELIVERY_ENTERING @"EVENT_CHECKOUT_SELECT_DELIVERY_ENTERING"
#define EVENT_CHECKOUT_BACK_BTN @"EVENT_CHECKOUT_BACK_BTN"
#define EVENT_CHECKOUT_ERR @"EVENT_CHECKOUT_ERR"
#define EVENT_CHECKOUT_SHIPPING_NEW_ADDRESS @"EVENT_CHECKOUT_SHIPPING_NEW_ADDRESS"
#define EVENT_CHECKOUT_SHIPPING_SELECT_ADDRESS @"EVENT_CHECKOUT_SHIPPING_SELECT_ADDRESS"
#define EVENT_CHECKOUT_SHIPPING_EDIT_BTN @"EVENT_CHECKOUT_SHIPPING_EDIT_BTN"
#define EVENT_CHECKOUT_SHIPPING_DELETE_BTN @"EVENT_CHECKOUT_SHIPPING_DELETE_BTN"

#define EVENT_CHECKOUT_NEW_ADDRESS_ENTERING @"EVENT_CHECKOUT_NEW_ADDRESS_ENTERING"
#define EVENT_CHECKOUT_NEW_ADDRESS_SEARCH_BTN @"EVENT_CHECKOUT_NEW_ADDRESS_SEARCH_BTN"
#define EVENT_CHECKOUT_NEW_ADDRESS_BACK_BTN @"EVENT_CHECKOUT_NEW_ADDRESS_BACK_BTN"

//Shipment Options
#define EVENT_CHECKOUT_SELECT_ADDRESS_ENTERING @"EVENT_CHECKOUT_SELECT_ADDRESS_ENTERING"
#define EVENT_CHECKOUT_SHIPPING_CHANGE_ADDRESS @"EVENT_CHECKOUT_SHIPPING_CHANGE_ADDRESS"
#define EVENT_CHECKOUT_SHIPPING_NEXT_STEP @"EVENT_CHECKOUT_SHIPPING_NEXT_STEP"
#define EVENT_SIMULATE_SHIPPING_ENTERING @"EVENT_SIMULATE_SHIPPING_ENTERING"

//Payment Info
#define EVENT_CHECKOUT_PAYMENT_ENTERING @"EVENT_CHECKOUT_PAYMENT_ENTERING"
#define EVENT_CHECKOUT_PAYMENT_DETAILS @"EVENT_CHECKOUT_PAYMENT_DETAILS"

//Confirm Payment
#define EVENT_CHECKOUT_CONFIRMATION_ENTERING @"EVENT_CHECKOUT_CONFIRMATION_ENTERING"
#define EVENT_CHECKOUT_TERMS_OF_USE_CONFIRMATION @"EVENT_CHECKOUT_TERMS_OF_USE_CONFIRMATION"
#define EVENT_CHECKOUT_CONFIRMATION_EDIT_PAYMENT_BTN @"EVENT_CHECKOUT_CONFIRMATION_EDIT_PAYMENT_BTN"
#define EVENT_CHECKOUT_CONFIRMATION_EDIT_SHIPPING_BTN @"EVENT_CHECKOUT_CONFIRMATION_EDIT_SHIPPING_BTN"
#define EVENT_CHECKOUT_CONFIRMATION_EDIT_PRODUCTS_BTN @"EVENT_CHECKOUT_CONFIRMATION_EDIT_PRODUCTS_BTN"
#define EVENT_CHECKOUT_FINISH_PURCHASE_BTN @"EVENT_CHECKOUT_FINISH_PURCHASE_BTN"

//Success
#define EVENT_CHECKOUT_SUCCESS @"EVENT_CHECKOUT_SUCCESS"
#define EVENT_CHECKOUT_ORDER_COMPLETE_ENTERING @"EVENT_CHECKOUT_ORDER_COMPLETE_ENTERING"

//Push
#define EVENT_PUSH_NOTIFICATION_LAUNCH @"EVENT_PUSH_NOTIFICATION_LAUNCH"

//General Error
#define EVENT_ERROR @"EVENT_ERROR"
//Communication Error
#define EVENT_COMMUNICATION_ERROR @"EVENT_COMMUNICATION_ERR"

//Search
#define EVENT_SEARCH_BTN                        @"EVENT_SEARCH_BTN"
#define EVENT_SEARCH_GO                         @"EVENT_SEARCH_GO"
#define EVENT_SEARCH_CANCEL_BTN                 @"EVENT_SEARCH_CANCEL_BTN"
#define EVENT_SEARCH_RESULT_CATEGORY_ENTERING   @"EVENT_SEARCH_RESULT_CATEGORY_ENTERING"
#define EVENT_SEARCH_RESULT_EMPTY               @"EVENT_SEARCH_RESULT_EMPTY"
#define EVENT_SEARCH_RESULT_ERROR               @"EVENT_SEARCH_RESULT_ERROR"
#define EVENT_SEARCH_RESULT_CATEGORY_BTN        @"EVENT_SEARCH_RESULT_CATEGORY_BTN"
#define EVENT_SEARCH_RESULT_PRODUCT_PAGE_NUMBER @"EVENT_SEARCH_RESULT_PRODUCT_PAGE_NUMBER"
#define EVENT_SEARCH_PRODUCT_DETAILS            @"EVENT_SEARCH_PRODUCT_DETAILS"
#define EVENT_SEARCH_RESULT_CATEGORY_SLIDE      @"EVENT_SEARCH_RESULT_CATEGORY_SLIDE"
#define EVENT_SEARCH_RESULT_HUBS @"EVENT_SEARCH_RESULT_HUBS"

//Splash
#define EVENT_SPLASH_ENTERING      @"EVENT_SPLASH_ENTERING"

//Extended Warranty
#define EVENT_EXTENDED_WARRANTY_ENTERING @"EVENT_EXTENDED_WARRANTY_ENTERING"
#define EVENT_EXTENDED_WARRANTY_CONDITIONS_ENTERING @"EVENT_EXTENDED_WARRANTY_CONDITIONS_ENTERING"
//New Extended Warranty
#define EVENT_DETAILS_WARRANTY @"EVENT_DETAILS_WARRANTY"
#define EVENT_CHECKOUT_PAYMENT_CHOICE @"EVENT_CHECKOUT_PAYMENT_CHOICE"
#define EVENT_CHECKOUT_PAYMENT_CHOICE_CHANGED @"EVENT_CHECKOUT_PAYMENT_CHOICE_CHANGED"

#define EVENT_CHECKOUT_NEW_ADDRESS_ADD_EDIT_BTN @"EVENT_CHECKOUT_NEW_ADDRESS_ADD_EDIT_BTN"

//Tracking
#define TRACKING_EVENT_ACCOUNT_ENTERING @"TRACKING_EVENT_ACCOUNT_ENTERING"
#define TRACKING_EVENT_ACCOUNT_LOGOUT @"TRACKING_EVENT_ACCOUNT_LOGOUT"
#define TRACKING_EVENT_ACCOUNT_ORDER_ENTERING @"TRACKING_EVENT_ACCOUNT_ORDER_ENTERING"
#define TRACKING_EVENT_ACCOUNT_ORDER_LIST_ENTERING @"TRACKING_EVENT_ACCOUNT_ORDER_LIST_ENTERING"
#define TRACKING_EVENT_ACCOUNT_ORDER_DETAILS_ENTERING @"TRACKING_EVENT_ACCOUNT_ORDER_DETAILS_ENTERING"
#define TRACKING_EVENT_ACCOUNT_ORDER_STATUS_ENTERING @"TRACKING_EVENT_ACCOUNT_ORDER_STATUS_ENTERING"
#define TRACKING_EVENT_ACCOUNT_ORDER_PAYMENT_ENTERING @"TRACKING_EVENT_ACCOUNT_ORDER_PAYMENT_ENTERING"
#define TRACKING_EVENT_ACCOUNT_ERR @"TRACKING_EVENT_ACCOUNT_ERR"

//Promo
#define EVENT_PROMO_TOUCHED @"EVENT_PROMO_TOUCHED"
#define EVENT_PROMO_ENTERING @"EVENT_PROMO_ENTERING"

//Filter
#define EVENT_SEARCH_RESULT_FILTER @"EVENT_SEARCH_RESULT_FILTER"

//Notification
#define EVENT_MENU_NOTIFICATION @"EVENT_MENU_NOTIFICATION"
#define EVENT_NOTIFICATION_ON @"EVENT_NOTIFICATION_ON"
#define EVENT_NOTIFICATION_OFF @"EVENT_NOTIFICATION_OFF"

//Menu Departments
#define EVENT_MENU_SHOPPING_ROOT @"EVENT_MENU_SHOPPING_ROOT"
#define EVENT_MENU_SHOPPING_RESULT @"EVENT_MENU_SHOPPING_RESULT"

//Rating
#define EVENT_MENU_RATE_US @"EVENT_MENU_RATE_US"

//Sort
#define EVENT_SEARCH_RESULT_SORT @"EVENT_SEARCH_RESULT_SORT"

//RefreshToken
#define EVENT_REFRESH_TOKEN @"EVENT_REFRESHTOKEN_ERR"

//ConvertToken
#define EVENT_CONVERT_TOKEN @"EVENT_CONVERTTOKEN_ERR"

//Push Recover
#define EVENT_PUSH_RECOVER_SHOW_ALERT @"EVENT_PUSH_RECOVER_SHOW_ALERT"
#define EVENT_PUSH_RECOVER_CONTINUE_BUTTON @"EVENT_PUSH_RECOVER_CONTINUE_BUTTON"
#define EVENT_PUSH_RECOVER_YES_BUTTON @"EVENT_PUSH_RECOVER_YES_BUTTON"
#define EVENT_PUSH_RECOVER_NO_BUTTON @"EVENT_PUSH_RECOVER_CANCEL_BUTTON"

@implementation FlurryWM

#pragma mark - Splash
+ (void)logEvent_splashEntering
{
    [Flurry logEvent:EVENT_SPLASH_ENTERING];
}


#pragma mark - Search
+ (void)logEvent_search_doSearch
{
    [Flurry logEvent:EVENT_SEARCH_BTN];
}

+ (void)logEvent_search_go:(NSString*)word 
{
    if (word && ![word isEqualToString:@""]) {
        NSString *wordLowerCase = [word lowercaseString];
        [Flurry logEvent:EVENT_SEARCH_GO withParameters:@{@"word" : wordLowerCase}];
    }
}
+ (void)logEvent_search_didCancel
{
    [Flurry logEvent:EVENT_SEARCH_CANCEL_BTN];
}
+ (void)logEvent_search_didEnterCategoryResults
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_CATEGORY_ENTERING];
}
+ (void)logEvent_search_didResultEmpty
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_EMPTY];
}
+ (void)logEvent_search_didResultError
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_ERROR];
}
+ (void)logEvent_search_didResultCategoryButton:(NSString*)categoryName
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_CATEGORY_BTN withParameters:@{@"category" : categoryName}];
}
+ (void)logEvent_search_didResultProductPage:(NSNumber*)page
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_PRODUCT_PAGE_NUMBER withParameters:@{@"page" : page}];
}
+ (void)logEvent_search_productEntering:(NSString *) productTitle {
    [Flurry logEvent:EVENT_SEARCH_PRODUCT_DETAILS withParameters:@{@"product":   productTitle}];
}
+ (void)logEvent_search_didResultCategorySlide:(NSString *)categoryName atPosition:(NSNumber*)position
{
    [Flurry logEvent:EVENT_SEARCH_RESULT_CATEGORY_SLIDE withParameters:@{@"category":categoryName, @"position": position}];
}

+ (void)logEvent_search_result_hubs:(NSString *)hub {
    [Flurry logEvent:EVENT_SEARCH_RESULT_HUBS withParameters:@{@"hub":hub}];
}

#pragma mark - General Error
//General Error
+ (void)logEvent_error:(NSDictionary *) error {
    
    NSNumber *strCode =    ([error valueForKey:@"response_code"]) ?: @"";
    NSString *strMessage = ([error valueForKey:@"message"])       ?: @"";
    NSString *strScreen =  ([error valueForKey:@"screen"])        ?: @"Other";
    NSString *strMethod =  ([error valueForKey:@"method"])        ?: @"";
    
    [Flurry logEvent:EVENT_ERROR withParameters:@{@"message"    :   strMessage,
                                                  @"method"     :   strMethod,
                                                  @"response_code"  :   strCode,
                                                  @"screen"     :   strScreen
                                                  }];
}

+ (void)logEvent_communication_error:(NSDictionary *) error {
    
    NSNumber *strCode =    ([error valueForKey:@"response_code"]) ?: @"";
    NSString *strMessage = ([error valueForKey:@"message"])       ?: @"";
    NSString *strScreen =  ([error valueForKey:@"screen"])        ?: @"Other";
    NSString *strMethod =  ([error valueForKey:@"method"])        ?: @"";
    
    [Flurry logEvent:EVENT_COMMUNICATION_ERROR withParameters:@{@"message"    :   strMessage,
                                                  @"method"     :   strMethod,
                                                  @"response_code"  :   strCode,
                                                  @"screen"     :   strScreen
                                                  }];
}

#pragma mark - Push
//Push
+ (void)logEvent_push_notification_launch:(NSString *) msg  {
    [Flurry logEvent:EVENT_PUSH_NOTIFICATION_LAUNCH withParameters:@{@"message":   msg}];
}

#pragma mark - Success
//Success
+ (void)logEvent_checkout_order_complete_entering {
    [Flurry logEvent:EVENT_CHECKOUT_ORDER_COMPLETE_ENTERING];
}
+ (void)logEvent_checkout_success:(NSDictionary *) products  {

    NSString *total = [products objectForKey:@"total"];
    NSString *idOrder = [products objectForKey:@"order_id"];
    NSString *paymentMethod = [products objectForKey:@"paymentMethod"];
//    [Flurry logEvent:EVENT_CHECKOUT_SUCCESS withParameters:@{@"products":   products}];
    [Flurry logEvent:EVENT_CHECKOUT_SUCCESS withParameters:@{@"total":   total,
                                                             @"oder_id" :   idOrder,
                                                             @"paymentMethod" : paymentMethod}];
}

#pragma mark - Confirm Payment
//Confirm Payment
+ (void)logEvent_checkout_confirmation_entering {
    [Flurry logEvent:EVENT_CHECKOUT_CONFIRMATION_ENTERING];
}
+ (void)logEvent_checkout_terms_confirmation {
    [Flurry logEvent:EVENT_CHECKOUT_TERMS_OF_USE_CONFIRMATION];
}

+ (void)logEvent_checkout_confirmation_edit_payment_btn {
    [Flurry logEvent:EVENT_CHECKOUT_CONFIRMATION_EDIT_PAYMENT_BTN];
}

+ (void)logEvent_checkout_confirmation_edit_shipping_btn {
    [Flurry logEvent:EVENT_CHECKOUT_CONFIRMATION_EDIT_SHIPPING_BTN];
}

+ (void)logEvent_checkout_confirmation_edit_products_btn {
    [Flurry logEvent:EVENT_CHECKOUT_CONFIRMATION_EDIT_PRODUCTS_BTN];
}

+ (void)logEvent_checkout_finish_purchase_btn {
    [Flurry logEvent:EVENT_CHECKOUT_FINISH_PURCHASE_BTN];
}

#pragma mark - Payment Info
//Payment Info
+ (void)logEvent_checkout_payment_entering {
    [Flurry logEvent:EVENT_CHECKOUT_PAYMENT_ENTERING];
}

+ (void)logEvent_checkout_payment_details:(NSString *) typeCc  {
    [Flurry logEvent:EVENT_CHECKOUT_PAYMENT_DETAILS withParameters:@{@"flag":   typeCc}];
}

#pragma mark - Shipment Options
//Shipment Options
+ (void)logEvent_checkout_shipping_change_address {
    [Flurry logEvent:EVENT_CHECKOUT_SHIPPING_CHANGE_ADDRESS];
}

+ (void)logEvent_checkout_shipping_next_stepWithType:(NSString *) typeDelivery  {
    [Flurry logEvent:EVENT_CHECKOUT_ERR withParameters:@{@"deliveryType":   typeDelivery}];
}

#pragma mark - Extended Warranty
+ (void)logEvent_extendedWarrantyEntering {
    [Flurry logEvent:EVENT_EXTENDED_WARRANTY_ENTERING];
}
+ (void)logEvent_extendedWarrantyConditionsEntering {
    [Flurry logEvent:EVENT_EXTENDED_WARRANTY_CONDITIONS_ENTERING];
}

+ (void)logEvent_eventDetailsWarranty:(NSString *) warrantyName {
    
    [Flurry logEvent:EVENT_DETAILS_WARRANTY withParameters:@{@"extend" : warrantyName}];
}
+ (void)logEvent_eventCheckoutPaymentChoice:(NSString *) paymentChoice{
    [Flurry logEvent:EVENT_CHECKOUT_PAYMENT_CHOICE withParameters:@{@"paymentChoice" : paymentChoice}];
}
+ (void)logEvent_eventCheckoutPaymentChoiceChanged{
    [Flurry logEvent:EVENT_CHECKOUT_PAYMENT_CHOICE_CHANGED];
}


#pragma mark - Checkout Address
//Checkout Address
+ (void)logEvent_checkout_select_delivery_entering {
    [Flurry logEvent:EVENT_CHECKOUT_SELECT_DELIVERY_ENTERING];
}
+ (void)logEvent_checkout_select_address_entering {
    [Flurry logEvent:EVENT_CHECKOUT_SELECT_ADDRESS_ENTERING];
}
+ (void)logEvent_simulateShippingEntering {
    [Flurry logEvent:EVENT_SIMULATE_SHIPPING_ENTERING];
}



+ (void)logEvent_checkout_back_btn {
    [Flurry logEvent:EVENT_CHECKOUT_BACK_BTN];
}

+ (void)logEvent_checkout_err:(NSDictionary *) err  {
    
    NSNumber *responseCode =    ([err valueForKey:@"responseCode"]) ?: @0;
    NSString *error =           ([err valueForKey:@"error"])        ?: @"";
    NSString *screen =          ([err valueForKey:@"screen"])       ?: @"";
    NSString *cartId =          ([err valueForKey:@"cartId"])       ?: @"";
    NSString *tkCheckout =      ([err valueForKey:@"tkCheckout"])   ?: @"";
    
    [Flurry logEvent:EVENT_CHECKOUT_ERR withParameters:@{@"response_code": responseCode,
                                                         @"error" : error,
                                                         @"screen":screen,
                                                         @"cartId":cartId,
                                                         @"tkCheckout":tkCheckout }];
}

+ (void)logEvent_checkout_shipping_new_address {
    [Flurry logEvent:EVENT_CHECKOUT_SHIPPING_NEW_ADDRESS];
}

+ (void)logEvent_checkout_shipping_select_address:(NSString *) state {
    [Flurry logEvent:EVENT_CHECKOUT_SHIPPING_SELECT_ADDRESS withParameters:@{@"state" : state}];
}

+ (void)logEvent_checkout_shipping_edit_btn {
    [Flurry logEvent:EVENT_CHECKOUT_SHIPPING_EDIT_BTN];
}

+ (void)logEvent_checkout_shipping_delete_btn {
    [Flurry logEvent:EVENT_CHECKOUT_SHIPPING_DELETE_BTN];
}


+ (void)logEvent_checkout_new_address_entering {
    [Flurry logEvent:EVENT_CHECKOUT_NEW_ADDRESS_ENTERING];
}

+ (void)logEvent_checkout_new_address_search_btn {
    [Flurry logEvent:EVENT_CHECKOUT_NEW_ADDRESS_SEARCH_BTN];
}

+ (void)logEvent_checkout_new_address_back_btn {
    [Flurry logEvent:EVENT_CHECKOUT_NEW_ADDRESS_BACK_BTN];
}

#pragma mark - Cart Events
//Cart events
+ (void)logEvent_cart_change_btn:(NSDictionary *) product {
    [Flurry logEvent:EVENT_CART_CHANGE_BTN withParameters:product];
}
+ (void)logEvent_cart_change_btn {
    [Flurry logEvent:EVENT_CART_CHANGE_BTN];
}
+ (void)logEvent_cart_entering {
    [Flurry logEvent:EVENT_CART_ENTERING];
}

+ (void)logEvent_cart_calc_shipping_btn {
    [Flurry logEvent:EVENT_CART_CALC_SHIPPING_BTN];
}

+ (void)logEvent_cart_delete_btn:(NSDictionary *) product {
    [Flurry logEvent:EVENT_CART_DELETE_BTN withParameters:product];
}

+ (void)logEvent_cart_empty {
    [Flurry logEvent:EVENT_CART_EMPTY];
}

+ (void)logEvent_cart_more_products_btn {
    [Flurry logEvent:EVENT_CART_MORE_PRODUCTS_BTN];
}

+ (void)logEvent_cart_order_done_btn {
    [Flurry logEvent:EVENT_CART_ORDER_DONE_BTN];
}

+ (void)logEvent_cart_back_btn {
    [Flurry logEvent:EVENT_CART_BACK_BTN];
}

#pragma mark - Poduct Details
//Product Details event
+ (void)logEvent_details_entering:(NSString *) productId andTitle:(NSString *)productTitle {
    LogInfo(@"Product Id: %@", productId);
    LogInfo(@"Product Title: %@", productTitle);
    [Flurry logEvent:EVENT_DETAILS_ENTERING withParameters:@{@"id":productId ,@"product":productTitle}];
}
+ (void)logEvent_details_calc_shipping_btn {
    [Flurry logEvent:EVENT_DETAILS_CALC_SHIPPING_BTN];
}
+ (void)logEvent_details_spec_btn {
    [Flurry logEvent:EVENT_DETAILS_SPEC_BTN];
}
+ (void)logEvent_details_desc_btn {
    [Flurry logEvent:EVENT_DETAILS_DESC_BTN];
}
+ (void)logEvent_details_buy_btn {
    [Flurry logEvent:EVENT_DETAILS_BUY_BTN];
}
+ (void)logEvent_productSpecificationEntering {
    [Flurry logEvent:EVENT_PRODUCT_SPECIFICATION_ENTERING];
}
+ (void)logEvent_productDescriptionEntering {
    [Flurry logEvent:EVENT_PRODUCT_DESCRIPTION_ENTERING];
}
+ (void)logEvent_productPaymentBtn {
    [Flurry logEvent:EVENT_DETAILS_CHECK_PAYMENT_BTN];
}
+ (void)logEvent_productAddToCart:(NSString *)sku andProduct:(NSString*)product andSeller:(NSString*)seller{
    [Flurry logEvent:EVENT_DETAILS_ADD_TO_CART withParameters:@{@"sku":sku, @"product":product, @"seller":seller}];
}
+ (void)logEvent_productCalculateShippingBtn {
    [Flurry logEvent:EVENT_DETAILS_CALC_SHIPPING_BTN];
}
+ (void)logEvent_productSelectVariationDialog{
    [Flurry logEvent:EVENT_DETAILS_SELECT_VAR_DIALOG];
}
+ (void)logEvent_productCalculateShippingEntering{
    [Flurry logEvent:EVENT_CALC_SHIPPING_ENTERING];
}
+ (void)logEvent_productCalculateShippingGo{
    [Flurry logEvent:EVENT_CAL_SHIPPING_GO];
}
+ (void)logEvent_productPaymentEntering{
    [Flurry logEvent:EVENT_DETAILS_CHECK_PAYMENT_ENTERING];
}
+ (void)logEvent_productDetailsError:(NSError *)error{
    [Flurry logEvent:EVENT_DETAILS_ERR withParameters:@{@"error" : error}];
}
+ (void)logEvent_productSearchSortBtn{
    [Flurry logEvent:EVENT_SEARCH_RESULT_PRODUCT_SORT_BTN];
}
+ (void)logEvent_productSearchSortGo:(NSString *)sort_type{
    [Flurry logEvent:EVENT_SEARCH_RESULT_PRODUCT_SORT_GO withParameters:@{@"sort_type":sort_type}];
}
+ (void)logEvent_productAvailabilityNotify:(NSString *)sku andProduct:(NSString*)product andSeller:(NSString*)seller {
    [Flurry logEvent:EVENT_DETAILS_REGISTER_PRODUCT_AVAILABILITY withParameters:@{@"sku":sku, @"product":product, @"seller":seller }];
}
+ (void)logEvent_productZoomBtn{
    [Flurry logEvent:EVENT_DETAILS_CHECK_ZOOM_BTN];
}
+ (void)logEvent_productZoomExit{
    [Flurry logEvent:EVENT_DETAILS_CHECK_ZOOM_EXIT];
}


#pragma mark - Feedback events
//Feedback events
+ (void)logEvent_feedback_entering {
    [Flurry logEvent:EVENT_FEEDBACK_ENTERING];
}

+ (void)logEvent_feedback_sent {
    [Flurry logEvent:EVENT_FEEDBACK_SENT];
}

#pragma mark - Login events
//Login events
+ (void)logEvent_login_entering {
    [Flurry logEvent:EVENT_LOGIN_ENTERING];
}

+ (void)logEvent_login_btn {
    [Flurry logEvent:EVENT_LOGIN_BTN];
}

+ (void)logEvent_login_signup {
    [Flurry logEvent:EVENT_LOGIN_SIGNUP];
}

+ (void)logEvent_login_forgot_pwd {
    [Flurry logEvent:EVENT_LOGIN_FORGOT_PWD];
}

+ (void)logEvent_login_err:(NSString *) err  {
    [Flurry logEvent:EVENT_LOGIN_ERR withParameters:@{@"err":   err}];
}

#pragma mark - Signup events
//Signup events
+ (void)logEvent_signup_entering {
    [Flurry logEvent:EVENT_SIGNUP_ENTERING];
}

+ (void)logEvent_signup_success {
    [Flurry logEvent:EVENT_SIGNUP_SUCCESS];
}

+ (void)logEvent_signup_err:(NSDictionary *) err {
    [Flurry logEvent:EVENT_SIGNUP_ERR withParameters:err];
}
+ (void)logEvent_signup_toc {
    [Flurry logEvent:EVENT_SIGNUP_TOC];
}
+ (void)logEvent_signup_completeAccountEntering {
    [Flurry logEvent:EVENT_COMPLETE_ACCOUNT_ENTERING];
}



#pragma mark - Menu events
//Menu events
+ (void)logEvent_menu_signup_btn {
    [Flurry logEvent:EVENT_MENU_SIGNUP_BTN];
}

+ (void)logEvent_menu_login_btn {
    [Flurry logEvent:EVENT_MENU_LOGIN_BTN];
}

+ (void)logEvent_menu_logout_btn {
    [Flurry logEvent:EVENT_MENU_LOGOUT_BTN];
}

+ (void)logEvent_menu_category:(NSString *) category {
    [Flurry logEvent:EVENT_MENU_CATEGORY withParameters:@{@"category" : category}];
}

+ (void)logEvent_menu_notification:(NSString *) status {
    
    [Flurry logEvent:EVENT_MENU_NOTIFICATION withParameters:@{@"status" : status}];
}

+ (void)logEvent_menu_about_btn {
    [Flurry logEvent:EVENT_MENU_ABOUT_BTN];
}
+ (void)logEvent_aboutEntering {
    [Flurry logEvent:EVENT_ABOUT_ENTERING];
}

+ (void)logEvent_termsOfContent {
    [Flurry logEvent:EVENT_TERMS_OF_CONTENT_ENTERING];
}

+ (void)logEvent_privacyPolicy {
    [Flurry logEvent:EVENT_PRIVACY_POLICY_ENTERING];
}

+ (void)logEvent_delivery {
    [Flurry logEvent:EVENT_DELIVERY_POLICY_ENTERING];
}

+ (void)logEvent_menu_help_btn {
    [Flurry logEvent:EVENT_MENU_HELP_BTN];
}

+ (void)logEvent_menu_feedback_btn {
    [Flurry logEvent:EVENT_MENU_FEEDBACK_BTN];
}

+ (void)logEvent_menu_mobile_site_btn {
    [Flurry logEvent:EVENT_MENU_MOBILE_SITE_BTN];
}

+ (void)logEvent_menu_contact_us {
    [Flurry logEvent:EVENT_MENU_CONTACT_US];
}

#pragma mark - Home events
//Home events
+ (void)logEvent_home_entering {
    [Flurry logEvent:EVENT_HOME_ENTERING];
}

+ (void)logEvent_home_cart_btn {
    [Flurry logEvent:EVENT_HOME_CART_BTN];
}

+ (void)logEvent_home_menu_btn {
    [Flurry logEvent:EVENT_HOME_MENU_BTN];
}

+ (void)logEvent_home_feedback {
    [Flurry logEvent:EVENT_HOME_FEEDBACK];
}

+ (void)logEvent_home_product_details:(NSString *) productDescription {
    [Flurry logEvent:EVENT_HOME_PRODUCT_DETAILS withParameters:@{@"product" :   productDescription}];
}

+ (void)logEvent_category_product_details:(NSString *) productDescription {
    [Flurry logEvent:EVENT_CATEGORY_PRODUCT_DETAILS withParameters:@{@"product" :   productDescription}];
}

+ (void)logEvent_home_see_all:(NSString *) category {
    [Flurry logEvent:EVENT_HOME_SEE_ALL withParameters:@{@"category" :  category}];
}

+ (void)logEvent_timed_event_purchase_start {
    [Flurry logEvent:EVENT_TIMED_EVENT_PURCHASE timed:YES];
}

+ (void)logEvent_timed_event_purchase_end {
    [Flurry endTimedEvent:EVENT_TIMED_EVENT_PURCHASE withParameters:nil];
}

#pragma mark - Help
//Help
+ (void)logEvent_helpEntering{
    [Flurry logEvent:EVENT_HELP_ENTERING];
}
+ (void)logEvent_feedbackFromHelp {
    [Flurry logEvent:EVENT_HELP_FEEDBACK];
}

+ (void)logEvent_feedbackFromOrderSuccess {
    [Flurry logEvent:EVENT_ORDER_COMPLETED_FEEDBACK];
}

+ (void)logEvent_checkoutNewAddressAddEditBtn {
    [Flurry logEvent:EVENT_CHECKOUT_NEW_ADDRESS_ADD_EDIT_BTN];
}

//Tracking
+ (void)logTracking_event_account_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ENTERING];
}

+ (void)logTracking_event_logout {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_LOGOUT];
}

+ (void)logTracking_event_order_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ORDER_ENTERING];
}

+ (void)logTracking_event_order_list_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ORDER_LIST_ENTERING];
}

+ (void)logTracking_event_order_details_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ORDER_DETAILS_ENTERING];
}

+ (void)logTracking_event_order_status_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ORDER_STATUS_ENTERING];
}

+ (void)logTracking_event_order_payment_entering {
    [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ORDER_PAYMENT_ENTERING];
}

+ (void)logTracking_event_account_err:(NSDictionary *) error {
    if (error) {
        [Flurry logEvent:TRACKING_EVENT_ACCOUNT_ERR withParameters:error];
    }
}

//Promo
+ (void)logEvent_promo_touched
{
    [Flurry logEvent:EVENT_PROMO_TOUCHED];
}

+ (void)logEvent_promo_entering
{
    [Flurry logEvent:EVENT_PROMO_ENTERING];
}

//Filter
+ (void)logEvent_search_result_filter:(NSDictionary *)parameters
{
    if (parameters)
    {
        [Flurry logEvent:EVENT_SEARCH_RESULT_FILTER withParameters:parameters];
    }
}

//Notification
+ (void)logEvent_notificationsEntering {
    [Flurry logEvent:EVENT_MENU_NOTIFICATION];
}

+ (void)logEvent_notificationsOn {
    [Flurry logEvent:EVENT_NOTIFICATION_ON];
}

+ (void)logEvent_notificationsOff {
    [Flurry logEvent:EVENT_NOTIFICATION_OFF];
}

//Menu Departments
+ (void)logEvent_menu_shopping_root:(NSString *)category
{
    if (category.length > 0)
    {
        [Flurry logEvent:EVENT_MENU_SHOPPING_ROOT withParameters:@{@"category" :  category}];
    }
}

+ (void)logEvent_menu_shopping_result:(NSArray *)categories
{
    NSString *categoriesSeparatedByComma = [[categories valueForKey:@"description"] componentsJoinedByString:@","];
    categoriesSeparatedByComma = [categoriesSeparatedByComma lowercaseString];
    if (categoriesSeparatedByComma.length > 0)
    {
        [Flurry logEvent:EVENT_MENU_SHOPPING_RESULT withParameters:@{@"category" :  categoriesSeparatedByComma}];
    }
}

//Rating
+ (void)logEvent_menuRating {
    [Flurry logEvent:EVENT_MENU_RATE_US];
}

//Sort
+ (void)logEvent_search_result_sort:(NSDictionary *)parameters
{
    if (parameters)
    {
        [Flurry logEvent:EVENT_SEARCH_RESULT_SORT withParameters:parameters];
    }
}

//Refresh Token
+ (void)logEvent_refreshToken:(NSDictionary *) error {
    
    NSNumber *strCode =    ([error valueForKey:@"response_code"]) ?: @"";
    NSString *strMessage = ([error valueForKey:@"message"])       ?: @"";
    NSString *strScreen =  ([error valueForKey:@"screen"])        ?: @"Other";
    NSString *strMethod =  ([error valueForKey:@"method"])        ?: @"";
    
    [Flurry logEvent:EVENT_REFRESH_TOKEN withParameters:@{@"message"    :   strMessage,
                                                          @"method"     :   strMethod,
                                                          @"response_code"  :   strCode,
                                                          @"screen"     :   strScreen
                                                          }];
}

//Convert Token
+ (void)logEvent_convertToken:(NSDictionary *) error {
    
    NSNumber *strCode =    ([error valueForKey:@"response_code"]) ?: @"";
    NSString *strMessage = ([error valueForKey:@"message"])       ?: @"";
    NSString *strScreen =  ([error valueForKey:@"screen"])        ?: @"Other";
    NSString *strMethod =  ([error valueForKey:@"method"])        ?: @"";
    
    [Flurry logEvent:EVENT_CONVERT_TOKEN withParameters:@{@"message"    :   strMessage,
                                                          @"method"     :   strMethod,
                                                          @"response_code"  :   strCode,
                                                          @"screen"     :   strScreen
                                                          }];
}

//Push Recover
+ (void)logEvent_pushShowAlert {
    [Flurry logEvent:EVENT_PUSH_RECOVER_SHOW_ALERT];
}
+ (void)logEvent_pushContinueButton {
    [Flurry logEvent:EVENT_PUSH_RECOVER_CONTINUE_BUTTON];
}
+ (void)logEvent_pushYesButton {
    [Flurry logEvent:EVENT_PUSH_RECOVER_YES_BUTTON];
}
+ (void)logEvent_pushNoButton {
    [Flurry logEvent:EVENT_PUSH_RECOVER_NO_BUTTON];
}


@end
