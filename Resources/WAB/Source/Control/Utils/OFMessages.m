
//
//  OFMessages.m
//  Ofertas
//
//  Created by Marcelo Santos on 7/22/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFMessages.h"

@implementation OFMessages

- (NSString *) getMsgCheckout:(NSString *) code {
    
    if ([code isEqualToString:@"PLC0116"]) {
        return PLC0116;
    }
    else if ([code isEqualToString:@"PLC0120"]) {
        return PLC0120;
    }
    else if ([code isEqualToString:@"PLC0213"]) {
        return PLC0213;
    }
    else if ([code isEqualToString:@"PLC0214"]) {
        return PLC0214;
    }
    else if ([code isEqualToString:@"PLC0215"]) {
        return PLC0215;
    }
    else if ([code isEqualToString:@"PLC0219"]) {
        return PLC0219;
    }
    else if ([code isEqualToString:@"PLC0201"] || ([code isEqualToString:@"PRODUCT_UNAVAILABLE"])) {
        return PLC0201;
    }
    else if ([code isEqualToString:@"PLC0202"]) {
        return PLC0202;
    }
    else if ([code isEqualToString:@"LGT0115"]) {
        return LGT0115;
    }
    else if ([code isEqualToString:@"LGT0301"] || [code isEqualToString:@"LGT0302"] || [code isEqualToString:@"LGT0303"] || [code isEqualToString:@"LGT0304"] || [code isEqualToString:@"LGT0305"]) {
        return LGT030X;
    }
    else if ([code isEqualToString:@"LGT0402"]) {
        return LGT0402;
    }
    else if ([code isEqualToString:@"SNP0036"]) {
        return SNP0036;
    }
    else if ([code isEqualToString:@"PREAUTH"]) {
        return PREAUTH;
    }
    else {
        return ERROR_UNKNOWN_CATEGORY;
    }
}

- (NSString *) tryButton {
    return TRY_BUTTON;
}
- (NSString *) emailAlready {
    return EMAIL_ALREADY;
}
- (NSString *) cpfAlready {
    return CPF_ALREADY;
}
- (NSString *) errorConnectionSplash {
    return ERROR_CONNECTION_SPLASH;
}
- (NSString *) errorConnectionSkin {
    return ERROR_CONNECTION_SKIN;
}
- (NSString *) errorConnectionProduct {
    return ERROR_CONNECTION_PRODUCT;
}
- (NSString *) errorConnectionUnknown {
    return ERROR_CONNECTION_UNKNOWN;
}
- (NSString *) errorConnectionInternet {
    return ERROR_CONNECTION_INTERNET;
}
- (NSString *) errorConnectionInvalidData {
    return ERROR_CONNECTION_INVALID_DATA;
}
- (NSString *) successConnectionInternet {
    return SUCCESS_CONNECTION_INTERNET;
}
- (NSString *) errorParseOrDatabase {
    return ERROR_PARSE_DATABASE;
}
- (NSString *) errorConnectionImage {
    return ERROR_CONNECTION_IMAGE;
}
- (NSString *) errorProductStock {
    return ERROR_PRODUCT_NO_STOCK;
}
- (NSString *) errorZip {
    return ERROR_UNZIP_FILE;
}
- (NSString *) errorLogin {
    return ERROR_LOGIN_USERNAME_PASSWORD;
}
- (NSString *)privacyLoginMessage {
    return PRIVACY_LOGIN_MESSAGE;
}
- (NSString *)loginUseTerms {
    return LOGIN_USE_TERMS;
}
- (NSString *)loginPrivacyTerms {
    return LOGIN_PRIVACY_TERMS;
}
- (NSString *) errorUnknownAuth {
    return ERROR_UNKNOWN_AUTH;
}
- (NSString *) errorUnknownShipmentAddress {
    return ERROR_UNKNOWN_SHIPADD;
}
- (NSString *) errorNoShipAdd {
    return ERROR_NO_SHIPADD;
}
- (NSString *) errorParserShippingOptions{
    return ERROR_PARSER_SHIPPING_OPTIONS;
}
- (NSString *) passOk {
    return SUCCESS_PASSWORD_RECOVER;
}
- (NSString *) errorConnectionAuth {
    return ERROR_CONNECTION_AUTH;
}
- (NSString *) errorConnectionShipmentAddress {
    return ERROR_CONNECTION_SHIPADD;
}
- (NSString *) errorConnectionRecover {
    return ERROR_CONNECTION_RECOVER;
}
- (NSString *) errorUnknownRecover {
    return ERROR_UNKNOWN_RECOVER;
}
- (NSString *) emptyCart {
    return EMPTY_CART;
}

- (NSString *) errorConnectionCategory {
    return ERROR_CONNECTION_CATEGORY;
}
- (NSString *) errorUnknownCategory {
    return ERROR_UNKNOWN_CATEGORY;
}

- (NSString *) errorValidateCard {
    return ERROR_VALIDATE_CCARD;
}

- (NSString *) helpMessage {
    return FEEDBACK_HELP_MESSAGE;
}
- (NSString *)errorSendFeedback{
    return ERROR_SEND_FEEDBACK;
}

- (NSString *)updateAddressErrorMessage{
    return UPDATE_ADDRESS_ERROR;
}

- (NSString *) errorShoppingCart {
    return ERROR_SHOPPING_CART;
}
- (NSString *) errorConnectionShopping {
    return ERROR_CONNECTION_SHOPPING;
}

- (NSString *)newAddressErrorMessage{
    return NEW_ADDRESS_ERROR;
}

- (NSString *)zipCodeInfosErrorMessage{
    return ZIPCODE_ERROR;
}

- (NSString *)zipCodeInfosNotFoundMessage{
    return ZIPCODE_NOTFOUND_ERROR;
}

- (NSString *) zipCodeInvalidMessage{
    return ZIPCODE_INVALID_ERROR;
}

- (NSString *)shipmentInfosErrorMessage{
    return SHIPMENTS_ERROR;
}

- (NSString *) serverInferiorPrice {
    return SERVER_RETURNED_INFERIOR_PRICE;
}

- (NSString *) serverSuperiorPrice {
    return SERVER_RETURNED_SUPERIOR_PRICE;
}

- (NSString *)updateUserErrorMessage{
    return UPDATE_USER_ERROR;
}

- (NSString *)createUserErrorMessage{
    return CREATE_USER_ERROR;
}

- (NSString *) shipmentOptions {
    return SHIPMENT_DATE_OPTIONS;
}
- (NSString *) shipmentSchedule {
    return SHIPMENT_DATE_SCHEDULE;
}
- (NSString *) shipmentDate {
    return SHIPMENT_DATE_CHOOSE;
}
- (NSString *) shipmentPeriod {
    return SHIPMENT_PERIOD_CHOOSE;
}

- (NSString *) errorConnectionShippings {
    return ERROR_CONNECTION_SHIPPINGS;
}
- (NSString *) errorShippings {
    return ERROR_SHIPPINGS;
}
- (NSString *) errorDifferentValues {
    return ERROR_DIFFERENT_VALUES;
}

- (NSString *) errorDocument {
    return ERROR_CNPJ_CPF;
}
- (NSString *) noCreditCard {
    return CREDIT_CARD_NO_SELECTED;
}

- (NSString *) qtyNotAvailable {
    return ERROR_QUANTITY_AVAILABLE;
}

- (NSString *) productNotAvailable {
    return PRODUCT_NOT_AVAILABLE;
}

- (NSString *) errorConnectionInstallments {
    return ERROR_CONNECTION_INSTALLMENTS;
}

- (NSString *) errorName {
    return ERROR_NAME;
}
- (NSString *) errorSecurity {
    return ERROR_SEC_CCARD;
}
- (NSString *) errorMonth {
    return ERROR_MONTH_CCARD;
}
- (NSString *) errorYear {
    return ERROR_YEAR_CCARD;
}
- (NSString *) errorInstallments {
    return ERROR_INSTALLMENTS;
}
- (NSString *) errorConnectionPO{
    return ERROR_CONNECTION_PO;
}
- (NSString *) errorPO {
    return ERROR_PO;
}
- (NSString *) greeting_hi {
    return GREETING_HI;
}
- (NSString *) greeting_ops {
    return GREETING_OPS;
}
- (NSString *) zipCodeInvalidError{
    return ZIPCODE_INVALID_MESSAGE;
}
- (NSString *)zipCodeChangedMessage{
    return ZIPCODE_CHANGED;
}
- (NSString *)invalidBirthdayMessage{
    return INVALID_BIRTHDAY;
}
- (NSString *)invalidMobileMessage{
    return INVALID_MOBILE_NUMBER;
}
- (NSString *)invalidTelephoneMessage{
    return INVALID_TELEPHONE_NUMBER;
}
- (NSString *)invalidCPFMessage{
    return INVALID_CPF;
}
- (NSString *)invalidCNPJMessage{
    return INVALID_CNPJ;
}
- (NSString *)invalidEmailMessage{
    return INVALID_EMAIL;
}
- (NSString *)invalidPasswordSixDigitsMessage{
    return INVALID_SIZE_PASSWORD_6;
}
- (NSString *)invalidNameMessage{
    return INVALID_NAME;
}
- (NSString *)emptyEmailMessage{
    return LOGIN_EMPTY_EMAIL;
}
- (NSString *)emptyPassMessage{
    return LOGIN_EMPTY_PASS;
}
- (NSString *)emptyEmailAndPassMessage{
    return LOGIN_EMPTY_EMAIL_AND_PASS;
}
- (NSString *)emptyCPFMessage{
    return EMPTY_DOCUMENT;
}
- (NSString *)emptyPhoneMessage{
    return EMPTY_PHONE;
}
- (NSString *)emptyCompleteNomeMessage{
    return EMPTY_COMPLETE_NAME;
}
- (NSString *) emptyGeneralMessage{
    return EMPTY_GENERAL;
}
- (NSString *) emptyLabelName{
    return EMPTY_LABEL_NAME;
}
- (NSString *) emptyLabelAddressType{
    return EMPTY_LABEL_ADDRESS_TYPE;
}
- (NSString *) emptyLabelStreet{
    return EMPTY_LABEL_STREET;
}
- (NSString *) emptyLabelNeighborhood{
    return EMPTY_LABEL_NEIGHBORHOOD;
}
- (NSString *) emptyLabelNumber{
    return EMPTY_LABEL_NUMBER;
}
- (NSString *) emptyLabelZipcode{
    return EMPTY_LABEL_ZIPCODE;
}
- (NSString *)errorOrders{
    return ERROR_ORDERS;
}
- (NSString *) errorMyAccount{
    return ERROR_MY_ACCOUNT;
}
- (NSString *) emptyOrders{
    return EMPTY_ORDERS;
}
- (NSString *)myAccountTitle{
    return MY_ACCOUNT_TITLE;
}
- (NSString *)ordersTitle{
    return ORDERS_TITLE;
}
- (NSString *)errorOrderStatusDetail{
    return ERROR_ORDER_STATUS_DETAIL;
}
- (NSString *) expectedOrderDeliveryDate; {
    return DELIVERY_DATE_MESSAGE;
}
- (NSString *) emptyOrderWithTerm{
    return ORDER_EMPTY_MESSAGE_WITH_TERM;
}
- (NSString *) emptyOrderWithoutTerm{
    return ORDER_EMPTY_MESSAGE_WITHOUT_TERM;
}
- (NSString *) emptyFilterWithTerm{
    return FILTER_EMPTY_MESSAGE_WITH_TERM;
}
- (NSString *) emptyFilterWithoutTerm{
    return FILTER_EMPTY_MESSAGE_WITHOUT_TERM;
}
- (NSString *)ratingMessageTitle{
    return RATING_MESSAGE_TITLE;
}
- (NSString *)ratingMessageText{
    return RATING_MESSAGE_TEXT;
}
- (NSString *) errorHomeFooter {
    return ERROR_HOME_FOOTER;
}
- (NSString *) errorFilterConnection {
    return REQUEST_ERROR;
}
- (NSString *) extendedWarrantyProtocolMessage {
    return PROTOCOL_EXTENDED_WARRANTY_MESSAGE;
}
- (NSString *) extendedWarrantyLicenseErrorMessage {
    return EXTENDED_WARRANTY_LICENSE_ERROR;
}
- (NSString *) extendedWarrantySeparatePayment {
    return EXTENDED_WARRANTY_SEPARATE_PAYMENT;
}
- (NSString *) seeInvoice {
    return TRACKING_INVOICE_SEE;
}
- (NSString *) sendInvoice {
    return TRACKING_INVOICE_SEND_EMAIL;
}
- (NSString *) installmentsRateMessage {
    return TRACKING_INSTALLMENTS_RATE_MESSAGE;
}
- (NSString *)registerTermsMessage {
    return REGISTER_TERMS_MESSAGE;
}
- (NSString *)registerTermsText {
    return REGISTER_TERMS_TEXT;
}
- (NSString *)registerPrivacyText {
    return REGISTER_PRIVACY_TEXT;
}

+ (NSString *)variationPopUpConfirmButton {
    return VARIATION_POPUP_CONFIRM;
}
+ (NSString *)variationPopUpRetryButton {
    return VARIATION_POPUP_RETRY;
}
+ (NSString *)trackingNumberTitle {
    return TRACKING_NUMBER_TITLE;
}
+ (NSString *)touchIdReasonMessage {
    return TOUCH_ID_REASON_MESSAGE;
}

@end
