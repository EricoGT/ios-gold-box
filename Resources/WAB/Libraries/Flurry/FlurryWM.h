//
//  FlurryWM.h
//  Walmart
//
//  Created by Marcelo Santos on 7/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlurryWM : NSObject

//splash events
+ (void)logEvent_splashEntering;

//Menu events
+ (void)logEvent_menu_signup_btn;
+ (void)logEvent_menu_login_btn;
+ (void)logEvent_menu_logout_btn;
+ (void)logEvent_menu_category:(NSString *) category;
+ (void)logEvent_menu_notification:(NSString *) status;
+ (void)logEvent_menu_about_btn;
+ (void)logEvent_aboutEntering;
+ (void)logEvent_menu_help_btn;
+ (void)logEvent_menu_feedback_btn;
+ (void)logEvent_menu_mobile_site_btn;
+ (void)logEvent_menu_contact_us;

//About Events
+ (void)logEvent_termsOfContent;
+ (void)logEvent_privacyPolicy;
+ (void)logEvent_delivery;

//Help Events
+ (void)logEvent_helpEntering;
+ (void)logEvent_feedbackFromHelp;
+ (void)logEvent_feedbackFromOrderSuccess;

//Home events
+ (void)logEvent_home_entering;
+ (void)logEvent_home_cart_btn;
+ (void)logEvent_home_menu_btn;
+ (void)logEvent_home_feedback;
+ (void)logEvent_home_product_details:(NSString *) productDescription;
+ (void)logEvent_home_see_all:(NSString *) category;
+ (void)logEvent_timed_event_purchase_start;
+ (void)logEvent_timed_event_purchase_end;

//Search events

+ (void)logEvent_search_doSearch;
+ (void)logEvent_search_go:(NSString*)word;
+ (void)logEvent_search_didCancel;
+ (void)logEvent_search_didEnterCategoryResults;
+ (void)logEvent_search_didResultEmpty;
+ (void)logEvent_search_didResultError;
+ (void)logEvent_search_didResultCategoryButton:(NSString*)categoryName;
+ (void)logEvent_search_didResultProductPage:(NSNumber *)page;
+ (void)logEvent_search_productEntering:(NSString *)productTitle;
+ (void)logEvent_search_didResultCategorySlide:(NSString *)categoryName atPosition:(NSNumber*)position;
+ (void)logEvent_search_result_hubs:(NSString *)hub;

//Category events
+ (void)logEvent_category_product_details:(NSString *) productDescription;

//Signup events
+ (void)logEvent_signup_entering;
+ (void)logEvent_signup_success;
+ (void)logEvent_signup_err:(NSDictionary *) err;
+ (void)logEvent_signup_toc;
+ (void)logEvent_signup_completeAccountEntering;

//Login events
+ (void)logEvent_login_entering;
+ (void)logEvent_login_btn;
+ (void)logEvent_login_signup;
+ (void)logEvent_login_forgot_pwd;
+ (void)logEvent_login_err:(NSString *) err;

//Feedback events
+ (void)logEvent_feedback_entering;
+ (void)logEvent_feedback_sent;

//Product Details event
+ (void)logEvent_details_entering:(NSString *) productId andTitle:(NSString *)productTitle;
+ (void)logEvent_details_calc_shipping_btn;
+ (void)logEvent_details_spec_btn;
+ (void)logEvent_details_desc_btn;
+ (void)logEvent_details_buy_btn;
+ (void)logEvent_productSpecificationEntering;
+ (void)logEvent_productDescriptionEntering;

+ (void)logEvent_productPaymentBtn;                         //EVENT_DETAILS_CHECK_PAYMENT_BTN
+ (void)logEvent_productAddToCart:(NSString *)sku andProduct:(NSString*)product andSeller:(NSString*)seller;
                                                            //EVENT_DETAILS_ADD_TO_CART : sku product seller

+ (void)logEvent_productCalculateShippingBtn;               //EVENT_DETAILS_CALC_SHIPPING_BTN
+ (void)logEvent_productSelectVariationDialog;              //EVENT_DETAILS_SELECT_VAR_DIALOG
+ (void)logEvent_productCalculateShippingEntering;          //EVENT_CALC_SHIPPING_ENTERING
+ (void)logEvent_productCalculateShippingGo;                //EVENT_CAL_SHIPPING_GO
+ (void)logEvent_productPaymentEntering;                    //EVENT_DETAILS_CHECK_PAYMENT_ENTERING
+ (void)logEvent_productDetailsError:(NSError *)error;      //EVENT_DETAILS_ERR : error
+ (void)logEvent_productSearchSortBtn;                      //EVENT_SEARCH_RESULT_PRODUCT_SORT_BTN
+ (void)logEvent_productSearchSortGo:(NSString *)sort_type; //EVENT_SEARCH_RESULT_PRODUCT_SORT_GO : sort_type
+ (void)logEvent_productAvailabilityNotify:(NSString *)sku andProduct:(NSString*)product andSeller:(NSString*)seller;
                                                            //EVENT_DETAILS_REGISTER_PRODUCT_AVAILABILITY : sku, product, seller
+ (void)logEvent_productZoomBtn;                            //EVENT_DETAILS_CHECK_ZOOM_BTN
+ (void)logEvent_productZoomExit;                           //EVENT_DETAILS_CHECK_ZOOM_EXIT


//Cart events
+ (void)logEvent_cart_entering;
+ (void)logEvent_cart_change_btn:(NSDictionary *) product;
+ (void)logEvent_cart_change_btn;
+ (void)logEvent_cart_calc_shipping_btn;
+ (void)logEvent_cart_delete_btn:(NSDictionary *) product;
+ (void)logEvent_cart_empty;
+ (void)logEvent_cart_more_products_btn;
+ (void)logEvent_cart_order_done_btn;
+ (void)logEvent_cart_back_btn;

//Checkout Address
+ (void)logEvent_checkout_select_delivery_entering;
+ (void)logEvent_checkout_select_address_entering;
+ (void)logEvent_checkout_back_btn;
+ (void)logEvent_checkout_err:(NSDictionary *) err;
+ (void)logEvent_checkout_shipping_new_address;
+ (void)logEvent_checkout_shipping_select_address:(NSString *) state;
+ (void)logEvent_checkout_shipping_edit_btn;
+ (void)logEvent_checkout_shipping_delete_btn;
+ (void)logEvent_checkout_terms_confirmation;
+ (void)logEvent_checkout_new_address_entering;
+ (void)logEvent_checkout_new_address_search_btn;
+ (void)logEvent_checkout_new_address_back_btn;
+ (void)logEvent_simulateShippingEntering;

//Shipment Options
+ (void)logEvent_checkout_shipping_change_address;
+ (void)logEvent_checkout_shipping_next_stepWithType:(NSString *) typeDelivery;

//Payment Info
+ (void)logEvent_checkout_payment_entering;
+ (void)logEvent_checkout_payment_details:(NSString *) typeCc;

//Extended Warranty
+ (void)logEvent_extendedWarrantyEntering;
+ (void)logEvent_extendedWarrantyConditionsEntering;

+ (void)logEvent_eventDetailsWarranty:(NSString *) warrantyName;
+ (void)logEvent_eventCheckoutPaymentChoice:(NSString *) paymentChoice;
+ (void)logEvent_eventCheckoutPaymentChoiceChanged;

//Confirm Payment
+ (void)logEvent_checkout_confirmation_entering;
+ (void)logEvent_checkout_confirmation_edit_payment_btn;
+ (void)logEvent_checkout_confirmation_edit_shipping_btn;
+ (void)logEvent_checkout_confirmation_edit_products_btn;
+ (void)logEvent_checkout_finish_purchase_btn;

//Success
+ (void)logEvent_checkout_order_complete_entering;
+ (void)logEvent_checkout_success:(NSDictionary *) products;

//Push
+ (void)logEvent_push_notification_launch:(NSString *) msg;

//General Error
+ (void)logEvent_error:(NSDictionary *) error;
+ (void)logEvent_checkoutNewAddressAddEditBtn;

//Communication Error
+ (void)logEvent_communication_error:(NSDictionary *) error;

//Tracking
+ (void)logTracking_event_account_entering;
+ (void)logTracking_event_logout;
+ (void)logTracking_event_order_entering;
+ (void)logTracking_event_order_list_entering;
+ (void)logTracking_event_order_details_entering;
+ (void)logTracking_event_order_status_entering;
+ (void)logTracking_event_order_payment_entering;
+ (void)logTracking_event_account_err:(NSDictionary *) error;

//Promo
+ (void)logEvent_promo_touched;
+ (void)logEvent_promo_entering;

//Filter
+ (void)logEvent_search_result_filter:(NSDictionary *)parameters;

//Notifications
+ (void)logEvent_notificationsEntering;
+ (void)logEvent_notificationsOn;
+ (void)logEvent_notificationsOff;

//Shopping
+ (void)logEvent_menu_shopping_root:(NSString *)category;
+ (void)logEvent_menu_shopping_result:(NSArray *)categories;

//Rating
+ (void)logEvent_menuRating;

//Sort
+ (void)logEvent_search_result_sort:(NSDictionary *)parameters;

//Refresh Token
+ (void)logEvent_refreshToken:(NSDictionary *) error;

//Convert Token
+ (void)logEvent_convertToken:(NSDictionary *) error;

//Push Recover
+ (void)logEvent_pushShowAlert;
+ (void)logEvent_pushContinueButton;
+ (void)logEvent_pushYesButton;
+ (void)logEvent_pushNoButton;

@end
