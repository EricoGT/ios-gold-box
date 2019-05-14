//
//  WMOmniture.h
//  Walmart
//
//  Created by Bruno on 6/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductDetailModel;

//ACTION NAMES
#define ACTION_SEARCH_CATEGORIES_RESULT @"pt:br:app:busca:busca-se-procura"
#define ACTION_SEARCH_PRODUCTS_RESULT @"pt:br:app:busca:resultado-busca"
#define ACTION_PRODUCT_DETAIL @"pt:br:app:prod-view"
#define ACTION_CALCULATE_FREIGHT @"pt:br:app:calcular-frete"
#define ACTION_ADD_CART @"pt:br:app:add-cart"
#define ACTION_CART @"pt:br:app:cart-view"
#define ACTION_DELIVERY @"pt:br:app:entrega"
#define ACTION_DELIVERY_NEW_ADDRESS @"pt:br:app:entrega:novo-endereco"
#define ACTION_DELIVERY_TYPE @"pt:br:app:tipo-entrega"
#define ACTION_PAYMENT @"pt:br:app:pagamento"
#define ACTION_LOGIN @"pt:br:app:login-view"
#define ACTION_REGISTER @"pt:br:app:register-view"
#define ACTION_PURCHASE @"pt:br:app:compra-finalizada"
#define ACTION_CARD_ADD @"pt:br:app:cartao:add"

@class DeliveryType;

@interface WMOmniture : NSObject

#pragma mark - pt:br:app:home
/**
 *  Tracks when home is presented to the user
 */
+ (void)trackHomeEntering;

#pragma mark - pt:br:app:add-cart
/**
 *  Tracks when a product is added to the card
 *
 *  @param product NSDictionary of the product
 */
+ (void)trackAddingProductInCart:(NSDictionary *)product;

#pragma mark - pt:br:app:cart-view
/**
 *  Tracks when cart was loaded and its products
 *
 *  @param products NSArray with products in the cart
 */
+ (void)trackProductsinCart:(NSArray *)products;

#pragma mark - pt:br:app:register-view
/**
 *  Tracks when cart is empty
 *
 */
+ (void)trackEmptyCart;

#pragma mark - pt:br:app:busca:busca-se-procura / pt:br:app:busca:resultado-busca
/**
 *  Tracks when search is performed by the user
 *
 *  @param quantity NSInteger with search result total products
 */
+ (void)trackSearchResultAction:(NSString *)action quantity:(NSInteger)quantity searchedTerm:(NSString *)searchedTerm;

#pragma mark - pt:br:app:prod-view
/**
 *  Tracks when user enters in product detail
 *
 *  @param product NSDictionary of the product
 */
+ (void)trackProduct:(ProductDetailModel *)product;

#pragma mark - pt:br:app:calcular-frete
/**
 *  Tracks when user calculates freight in product detail
 *
 *  @param product NSDictionary of the freight
 */
+ (void)trackCalculateFreight:(DeliveryType *)freight;

#pragma mark - pt:br:app:entrega
/**
*  Tracks when user enters address list screen in checkout
*/
+ (void)trackAddressListInCheckout;

#pragma mark - pt:br:app:entrega
/**
 *  Tracks when user enters on new address screen from Checkout flow
 */
+ (void)trackCheckoutNewAddressScreen;

#pragma mark - pt:br:app:tipo-entrega
/**
 *  Tracks when user enters delivery type screen
 */
+ (void)trackDeliveryTypeInCheckout;


#pragma mark - pt:br:app:
/**
 *  Tracks when user enters delivery type screen
 */
+ (void)trackDeliveryTypeNames:(NSString *)deliveryTypeName andDeliveryCount:(NSInteger)deliveryCount;


#pragma mark - pt:br:app:register-view
/**
 *  Tracks when user enters the registration screen
 */
+ (void)trackRegisterPage;

#pragma mark - pt:br:app:login-view
/**
 *  Tracks when user enters login screen
 */
+ (void)trackLoginPage;

/**
 *  Tracks when user opens the zip pop-up for delivery cost estimate
 */
+ (void)trackDeliveryShippingPopUp;

/**
 *  Tracks when user opens the add discount coupon pop-up
 */
+ (void)trackDiscountCouponPopUp;

#pragma mark - pt:br:app:pagamento
/**
 *  Tracks when user enters payment screen
 */
+ (void)trackPaymentScreen;

#pragma mark - pt:br:compra-finalizada
/**
 *  Tracks when user completes the checkout proccess
 */
+ (void)trackPurchaseComplete:(NSDictionary *)orderDict;

+ (void)trackAllShoppingEnter;

#pragma mark - pt:br:app:departamento
/**
 *  Tracks when the user taps a department in the menu
 *
 *  @param department NSString with the name of the department
 */
+ (void)trackMenuDepartmentTap:(NSString *)department;

#pragma mark - pt:br:app:categoria
/**
 *  Tracks when the user taps a category inside a department in the menu
 *
 *  @param department NSString with the name of the department
 *  @param category   NSString with the name of the category
 */
+ (void)trackMenuCategoryTap:(NSString *)department category:(NSString *)category;

#pragma mark - pt:br:app:sub-categoria
/**
 *  Tracks when the user taps a category inside a department in the menu
 *
 *  @param department NSString with the name of the department
 *  @param category   NSString with the name of the category
 *  @param subcategory   NSString with the name of the subcategory
 */
+ (void)trackMenuSubCategoryTap:(NSString *)department category:(NSString *)category subcategory:(NSString *)subcategory;

#pragma mark - pt:br:app:ver-tudo
/**
 *  Tracks when use taps in "Tudo em..." in the menu
 *
 *  @param category NSString with the name of the category
 */
+ (void)trackMenuAllInTap:(NSString *)category;

#pragma mark - pt:br:app:hub
/**
 *  Tracks when user taps a hub item
 *
 *  @param hub         NSString with the hub name
 *  @param hubItem NSString with the hub item selected
 */
+ (void)trackHubTap:(NSString *)hub hubCategory:(NSString *)hubItem;
+ (void)trackHubEnter;

/**
 *  Tracks when user enters self help
 */
+ (void)trackSelfHelpHomeEnter;

/**
 *  Tracks when user leaves self help
 */
+ (void)trackSelfHelpHomeExit;

/**
 *  Tracks when user enters orders list
 */
+ (void)trackOrdersList;

/**
 *  Tracks when user enters order status
 */
+ (void)trackOrderStatus;

/**
 *  Tracks when user enters order barcode screen
 */
+ (void)trackOrderBarcode;

/**
 *  Tracks when user enters order invoice screen
 */
+ (void)trackOrderInvoice;

/**
 *  Tracks when user enters order detail
 */
+ (void)trackOrderDetail;

/**
 *  Tracks when user enters order payment
 */
+ (void)trackOrderPayment;

/**
 *  Tracks when user enters addresses list
 */
+ (void)trackAddressList;

/**
 *  Tracks when user deletes an address
 */
+ (void)trackAddressDelete;

/**
 *  Tracks when user searches for a zip code in self help
 */
+ (void)trackAddressZipSearch;

/**
 *  Tracks when user tries to add an address
 */
+ (void)trackAddressAddTry;

/**
 *  Tracks when user adds an address
 */
+ (void)trackAddressAdd;

/**
 *  Tracks when user enters personal data screen
 */
+ (void)trackPersonalDataEnter;

/**
 *  Tracks when user updates its personal data
 */
+ (void)trackPersonalDataUpdate;

/**
 *  Tracks when user enters in the wishlist and see the tour
 */
+ (void)trackWishlistTour;

/**
 *  Tracks when user removes one or more products in the wishlist
 */
+ (void)trackRemoveProductsFromWishlistForSellerIds:(NSArray *)sellerIds SKUs:(NSArray *)skus;

/**
 *  Tracks when user taps the empty heart button
 */
+ (void)trackAddToWishlistWithSellerId:(NSString *)sellerId sku:(NSNumber *)sku pageType:(NSString *)pageType;

/**
 *  Tracks when user changes the status for one or more products to purchased in the wishlist
 */
+ (void)trackMoveProductsToPurchasedForSellerIds:(NSArray *)sellerIds SKUs:(NSArray *)skus;

/**
 *  Tracks when user taps the full heart button
 */
+ (void)trackRemoveFromWishlistWithSellerId:(NSString *)sellerId sku:(NSNumber *)sku pageType:(NSString *)pageType;

/**
 *  Tracks when user adds a product to the cart in the wishlist
 */
+ (void)trackAddToCartFromWishlistForSellerId:(NSString *)sellerId SKU:(NSString *)sku;

/**
 *  Tracks when user asks to warn him when the product is available in the wishlist
 */
+ (void)trackWarnMeFromWishlistForSellerId:(NSString *)sellerId SKU:(NSString *)sku;

/**
 *  Tracks low price and and out of stock products in wishlist
 */
+ (void)trackWishlistProductsWithSellersIds:(NSArray *)sellersIds SKUs:(NSArray *)skus filterType:(NSString *)filterType lowerPrice:(BOOL)lowerPrice outOfStock:(BOOL)outOfStock;

#pragma mark - Credit Card Scan
/**
 *  Tracks credit card scan opening when user is paying a normal product
 */
+ (void)trackCreditCardScanProductPayment;

/**
 *  Tracks credit card scan opening when user is paying an extended warranty
 */
+ (void)trackCreditCardScanWarrantyPayment;

/**
 *  Tracks errors during the credit card scan proccess when user is paying a normal product
 */
+ (void)trackCreditCardScanProductError;

/**
 *  Tracks errors during the credit card scan proccess when user is paying an extended warranty
 */
+ (void)trackCreditCardScanWarrantyError;

/**
 *  Tracks when user entens in AddCard's screen
 */
+ (void)trackCreditCardAdd;

/**
 *  Tracks when user have any credit card and if its expired
 */
+ (void)trackCreditCardSaved:(NSArray *)cards;

/**
 *  Tracks when user pick to save credit card to use on next time
 */
+ (void)trackCreditCardAllowSaveToNextShop;

#pragma mark - Ticket

/**
 *  Track when user hasn't opened tickets
 */
+ (void)trackEmptyTickets;

/**
 *  Track when user has opened tickets
 */
+ (void)trackOpenedTickets;

/**
 *  Track when user try to open a ticket by side menu
 */
+ (void)trackOpenTicketSideMenu;

/**
 *  Tracks when user pick to reopen a ticket
 */
+ (void)trackReopenTicket;

/**
 *  Track when user try to open a ticket from product status
 */
+ (void)trackOpenTicketProductStatus;

/*
 *  Tracks when a ticket was opened with success
 */
+ (void)trackOpenedTicketWithSuccess;

/**
 *  Tracks when a ticket was reopened with success
 */
+ (void)trackReopenedTicketWithSuccess;

@end
