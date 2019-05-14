//
//  WMOmniture.m
//  Walmart
//
//  Created by Bruno on 6/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMOmniture.h"
#import "ADBMobile.h"

#import "ShippingDelivery.h"
#import "DeliveryType.h"
#import "ProductDetailModel.h"
#import "WBRUser.h"
#import "WBRCardModel.h"

#define products_key @"&&products"
#define wishlist_products_key @"&&product"
#define pid_key @"pid"

@implementation WMOmniture

#pragma mark - pt:br:app:home
+ (void)trackHomeEntering
{
    NSString *action = @"pt:br:app:home";
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", action, mutableData);
    
    if (mutableData.count > 0) {
        [ADBMobile trackState:action data:mutableData];
    }
    else {
        [ADBMobile trackState:action data:nil];
    }
}

#pragma mark - pt:br:app:add-cart
+ (void)trackAddingProductInCart:(NSDictionary *)product
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    NSString *seller = product[@"sellerName"] ?: @"";
    NSString *sku = product[@"sku"] ?: @"";
    
    seller = [WMOmniture removeAccentuationFromString:seller];
    seller = [WMOmniture removeSpacesAndSymbolsFromString:seller];
    NSString *productString = [NSString stringWithFormat:@"%@;%@", seller, sku];
    
    [mutableData setObject:@1 forKey:@"ScAdd"];
    [mutableData setObject:productString ?: @"" forKey:products_key];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_ADD_CART, mutableData.copy);
    [ADBMobile trackState:ACTION_ADD_CART data:mutableData.copy];
}

+ (void)trackEmptyCart {
    NSString *pageName = ACTION_REGISTER;
    NSDictionary *data = @{@"CartViewEmpty": @1};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

#pragma mark - pt:br:app:cart-view
+ (void)trackProductsinCart:(NSArray *)products
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    NSMutableArray *formattedProducts = [NSMutableArray new];
    
    for (NSDictionary *product in products)
    {
        NSString *seller = product[@"sellerName"] ?: @"";
        BOOL isExtended = [product[@"isExtend"] boolValue];
        
        BOOL qtyAvailable = [product[@"quantityAvailable"] boolValue];
        BOOL priceIsDivergent = [product[@"priceDivergent"] boolValue];
        BOOL errorRoute = [product[@"errorRoute"] boolValue];
        BOOL errorGeneralBySeller = [product[@"errorGeneralBySeller"] boolValue];
        BOOL errorCartLevel = [product[@"errorCartLevel"] boolValue];
        BOOL couponNotAllowed = [product[@"couponNotAllowed"] boolValue];
        
        NSString *eVar26;
        if (couponNotAllowed) {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:COUPON_NOT_ALLOWED]];
        }
        else if (!qtyAvailable)
        {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:ERROR_PRODUCT_QUANTITY_AVAILABLE]];
        }
        else if (priceIsDivergent)
        {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:PRODUCT_PRICE_DIVERGENT]];
        }
        else if (errorGeneralBySeller)
        {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:ERROR_GENERAL_SELLER]];
        }
        else if (errorRoute)
        {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:ERROR_SHIPPING_ROUTE]];
        }
        else if (errorCartLevel)
        {
            eVar26 = [NSString stringWithFormat:@"eVar26=%@", [WMOmniture removeAccentuationFromString:ERROR_GENERAL_SELLER]];
        }
        else
        {
            eVar26 = @"eVar26=sem erro";
        }
        
        if (isExtended) {
            seller = @"garantia";
            NSString *productId = product[@"productId"] ?: @"";
            
            NSString *productAction = [NSString stringWithFormat:@"%@;%@;%@", seller, productId, eVar26];
            [formattedProducts addObject:productAction];
        }
        else {
            NSString *sku = product[@"sku"];
            
            if (sku) {
                seller = [WMOmniture removeAccentuationFromString:seller];
                seller = [WMOmniture removeSpacesAndSymbolsFromString:seller];
                
                NSString *productAction = [NSString stringWithFormat:@"%@;%@;%@", seller, sku, eVar26];
                [formattedProducts addObject:productAction];
            }
        }
    }
    NSString *allProductsString = [formattedProducts componentsJoinedByString:@","];
    
    [mutableData setObject:@1 forKey:@"cartView"];
    [mutableData setObject:allProductsString ?: @"" forKey:products_key];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_CART, mutableData.copy);
    [ADBMobile trackState:ACTION_CART data:mutableData.copy];
}

#pragma mark - pt:br:app:busca:busca-se-procura / pt:br:app:busca:resultado-busca

+ (void)trackSearchResultAction:(NSString *)action quantity:(NSInteger)quantity searchedTerm:(NSString *)searchedTerm {
    NSData *searchedTermData = [searchedTerm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *searchedTermEncoded = [[NSString alloc] initWithData:searchedTermData encoding:NSASCIIStringEncoding];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@"~" withString:@""];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@"^" withString:@""];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@"`" withString:@""];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@"'" withString:@""];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@"," withString:@""];
    searchedTermEncoded = [searchedTermEncoded stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    [mutableData setObject:@1 forKey:@"search"];
    [mutableData setObject:searchedTermEncoded ?: @"" forKey:@"term"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    if (quantity == 0) [mutableData setObject:@1 forKey:@"searchNull"];
    
    [WMOmniture storeUTMIInMutableData:mutableData];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", action, mutableData.copy);
    [ADBMobile trackState:action data:mutableData.copy];
}

#pragma mark - pt:br:app:prod-view
+ (void)trackProduct:(ProductDetailModel *)product
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    NSString *seller = product.defaultSeller.name ?: @"";
    NSString *productID = product.productId.stringValue ?: @"";
    
    seller = [WMOmniture removeAccentuationFromString:seller];
    seller = [WMOmniture removeSpacesAndSymbolsFromString:seller];
    NSString *productInformation = [NSString stringWithFormat:@"%@;%@", seller, productID];
    
    NSMutableArray *sellersToBeTracked = [NSMutableArray new];
    for (SellerOptionModel *sellerOption in product.sellerOptions)
    {
        NSString *sellerName = sellerOption.name ?: @"";
        sellerName = [WMOmniture removeAccentuationFromString:sellerName];
        sellerName = [WMOmniture removeSpacesAndSymbolsFromString:sellerName];
        [sellersToBeTracked addObject:sellerName];
    }
    NSString *sellersInformation  = [sellersToBeTracked componentsJoinedByString:@","];
    
    [mutableData setObject:@1 forKey:@"prodView"];
    [mutableData setObject:productInformation ?: @"" forKey:products_key];
    [mutableData setObject:@"" forKey:@"department"];
    [mutableData setObject:@"" forKey:@"category"];
    [mutableData setObject:@"" forKey:@"subCategory"];
    [mutableData setObject:sellersInformation ?: @"" forKey:@"sellers"];
    [mutableData setObject:@"" forKey:@"brand"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    [WMOmniture storeUTMIInMutableData:mutableData];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_PRODUCT_DETAIL, mutableData.copy);
    [ADBMobile trackState:ACTION_PRODUCT_DETAIL data:mutableData.copy];
}

#pragma mark - pt:br:app:calcular-frete

+ (void)trackCalculateFreight:(DeliveryType *)freight {
    NSString *shippingEstimate = [WMOmniture removeAccentuationFromString:freight.shippingEstimate];
    shippingEstimate = [WMOmniture removeSpacesAndSymbolsFromString:shippingEstimate];
    
    NSString *freightPrice = [WMOmniture formattedNumberString:freight.price];
    
    NSDictionary *data = @{@"frete" : @1,
                           @"prazo" : shippingEstimate ?: @"",
                           @"valorFrete" : freightPrice ?: @""};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_CALCULATE_FREIGHT, data);
    [ADBMobile trackState:ACTION_CALCULATE_FREIGHT data:data];
}

#pragma mark - pt:br:app:entrega

+ (void)trackAddressListInCheckout {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"delivery"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_DELIVERY, mutableData);
    [ADBMobile trackState:ACTION_DELIVERY data:mutableData];
}

#pragma mark - pt:br:app:tipo-entrega
+ (void)trackDeliveryTypeInCheckout {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"deliveryType"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_DELIVERY_TYPE, mutableData);
    [ADBMobile trackState:ACTION_DELIVERY_TYPE data:mutableData];
}

+ (void)trackDeliveryTypeNames:(NSString *)deliveryTypeName andDeliveryCount:(NSInteger)deliveryCount{

    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    NSString *deliveryName;
    
    if ([deliveryTypeName isEqualToString:@"RESIDENTIAL"]) {
        deliveryName = @"residencial";
    } else {
        deliveryName = @"comercial";
    }
    
    [mutableData setObject:deliveryName forKey:@"deliveryTypeName"];
    [mutableData setObject:@(deliveryCount) forKey:@"deliveryCount"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] - Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];
}


#pragma mark - pt:br:app:register-view

+ (void)trackRegisterPage {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"registerViewCheckout"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_REGISTER, mutableData);
    [ADBMobile trackState:ACTION_REGISTER data:mutableData];
}

+ (void)trackCheckoutNewAddressScreen {
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"newAddressCheckout"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_DELIVERY_NEW_ADDRESS, mutableData);
    [ADBMobile trackState:ACTION_DELIVERY_NEW_ADDRESS data:mutableData];
}

#pragma mark - pt:br:app:login-view

+ (void)trackLoginPage {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"loginViewCheckout"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_LOGIN, mutableData);
    [ADBMobile trackState:ACTION_LOGIN data:mutableData];
}

#pragma mark -

+ (void)trackDeliveryShippingPopUp {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"clickDeliveryShipping"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];
}

#pragma mark -

+ (void)trackDiscountCouponPopUp {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"clickInsertDiscount"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];
}

#pragma mark - pt:br:app:pagamento

+ (void)trackPaymentScreen {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"payment"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_PAYMENT, mutableData);
    [ADBMobile trackState:ACTION_PAYMENT data:mutableData];
}

#pragma mark - pt:br:app:compra-finalizada

+ (void)trackPurchaseComplete:(NSDictionary *)orderDict {
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"purchase"];
    
    NSDictionary *orderResume = [orderDict objectForKey:@"orderResume"];
    [mutableData setObject:[orderResume objectForKey:@"orderNumber"] ?: @"" forKey:@"purchaseID"];
    
    NSString *paymentTypeName = [orderResume objectForKey:@"paymentTypeName"];
    [mutableData setObject:paymentTypeName ? [paymentTypeName lowercaseString] : @"" forKey:@"paymentForm"];
    
    [mutableData setObject:[orderResume objectForKey:@"installmentsNumber"] ?: @"" forKey:@"installments"];
    
    NSArray *deliveries = [orderDict objectForKey:@"deliveries"];
    NSMutableArray *productStrings = [NSMutableArray new];
    
    for (ShippingDelivery *delivery in deliveries) {
        NSMutableString *productStr = [NSMutableString new];
        
        NSString *sellerName = [WMOmniture removeAccentuationFromString:delivery.sellerName];
        sellerName = [WMOmniture removeSpacesAndSymbolsFromString:sellerName];
        
        for (CartItem *product in delivery.cartItems) {
            if (product != delivery.cartItems.firstObject) {
                [productStr appendString:@","];
            }
            [productStr appendFormat:@"%@;", [sellerName lowercaseString]];
            NSNumber *income = [NSNumber numberWithFloat:product.price.floatValue * product.quantity.floatValue];
            NSString *incomeStr = [WMOmniture formattedNumberString:income];
            [productStr appendFormat:@"%@;%@;%@", product.sku, product.quantity, incomeStr];
        }
        
        [productStrings addObject:productStr];
    }
    if (productStrings.count > 0) {
        [mutableData setObject:[productStrings componentsJoinedByString:@","] forKey:products_key];
    }
    
    mutableData[@"Card_IO"] = [orderDict[@"hasUsedCardScan"] boolValue] ? @"true" : @"false";
    mutableData[@"cardIOProduct"] = @([orderDict[@"hasUsedCardScanForProduct"] boolValue]);
    mutableData[@"cardIOWarranty"] = @([orderDict[@"hasUsedCardScanForWarranty"] boolValue]);
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", ACTION_PURCHASE, mutableData.copy);
    [ADBMobile trackState:ACTION_PURCHASE data:mutableData.copy];
}

+ (void)trackAllShoppingEnter
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [WMOmniture storeUTMIInMutableData:mutableData];
    
    NSString *pageName = @"pt:br:app:todo-shopping";
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:departamento

+ (void)trackMenuDepartmentTap:(NSString *)department
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    if (!department) department = @"";
    department = [WMOmniture removeAccentuationFromString:department];
    department = [department lowercaseString];
    
    NSString *depMenu = department;
    NSString *pageName = [NSString stringWithFormat:@"pt:br:app:departamento:%@",department];
    
    [mutableData setObject:depMenu ?: @"" forKey:@"depMenu"];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:categoria
+ (void)trackMenuCategoryTap:(NSString *)department category:(NSString *)category
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    if (!department) department = @"";
    if (!category) category = @"";
    
    department = [WMOmniture removeAccentuationFromString:department];
    department = [department lowercaseString];
    
    category = [WMOmniture removeAccentuationFromString:category];
    category = [category lowercaseString];
    
    NSString *catMenu = [NSString stringWithFormat:@"%@|%@",department, category];
    NSString *pageName = [NSString stringWithFormat:@"pt:br:app:categoria:%@:%@",department, category];
    
    [mutableData setObject:catMenu ?: @"" forKey:@"catMenu"];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:sub-categoria
+ (void)trackMenuSubCategoryTap:(NSString *)department category:(NSString *)category subcategory:(NSString *)subcategory
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    if (!department) department = @"";
    if (!category) category = @"";
    if (!subcategory) subcategory = @"";
    
    department = [WMOmniture removeAccentuationFromString:department];
    department = [department lowercaseString];
    
    category = [WMOmniture removeAccentuationFromString:category];
    category = [category lowercaseString];
    
    subcategory = [WMOmniture removeAccentuationFromString:subcategory];
    subcategory = [subcategory lowercaseString];
    
    NSString *subCatMenu = [NSString stringWithFormat:@"%@|%@|%@",department, category, subcategory];
    NSString *pageName = [NSString stringWithFormat:@"pt:br:app:sub-categoria:%@:%@|%@",department, category, subcategory];
    
    [mutableData setObject:subCatMenu ?: @"" forKey:@"subCatMenu"];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:ver-tudo
+ (void)trackMenuAllInTap:(NSString *)category
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    if (!category) category = @"";
    category = [WMOmniture removeAccentuationFromString:category];
    category = [category lowercaseString];
    
    NSString *viewAllDep = category;
    category = [category stringByReplacingOccurrencesOfString:@"tudo em " withString:@""];
    NSString *pageName = [NSString stringWithFormat:@"pt:br:app:ver-tudo:%@",category];
    
    [mutableData setObject:viewAllDep ?: @"" forKey:@"viewAllDep"];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:hub
+ (void)trackHubTap:(NSString *)hub hubCategory:(NSString *)hubItem;
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    if (!hub) hub = @"";
    if (!hubItem) hubItem = @"";
    
    hub = [WMOmniture removeAccentuationFromString:hub];
    hub = [hub lowercaseString];
    
    hubItem = [WMOmniture removeAccentuationFromString:hubItem];
    hubItem = [hubItem lowercaseString];
    
    NSString *viewHub = [NSString stringWithFormat:@"%@|%@",hub, hubItem];
    NSString *pageName = [NSString stringWithFormat:@"pt:br:app:hub:%@:%@",hub, hubItem];
    
    [mutableData setObject:viewHub ?: @"" forKey:@"viewHub"];
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - pt:br:app:departamento
+ (void)trackHubEnter
{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [WMOmniture storeUTMIInMutableData:mutableData];
    
    NSString *pageName = @"pt:br:app:departamento";
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData.copy);
    [ADBMobile trackState:pageName data:mutableData.copy];
}

#pragma mark - Self Help

+ (void)trackSelfHelpHomeEnter {
    NSString *pageName = @"pt:br:app:minhaconta:home";
    NSDictionary *data = @{@"selfHelpHome" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackSelfHelpHomeExit {
    NSString *pageName = @"pt:br:app:minhaconta:sair";
    NSDictionary *data = @{@"selfHelpExit" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrdersList {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:home";
    NSDictionary *data = @{@"selfHelpPurchases" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrderStatus {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:status";
    NSDictionary *data = @{@"selfHelpPurchasesStatus" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrderBarcode {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:status-boleto";
    NSDictionary *data = @{@"selfHelpPurchasesStatusBoleto" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrderInvoice {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:status-nf";
    NSDictionary *data = @{@"selfHelpPurchasesStatusNf" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrderDetail {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:detalhes";
    NSDictionary *data = @{@"selfHelpPurchasesDetails" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackOrderPayment {
    NSString *pageName = @"pt:br:app:minhaconta:pedidos:pagamento";
    NSDictionary *data = @{@"selfHelpPurchasesPayment" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddressList {
    NSString *pageName = @"pt:br:app:minhaconta:enderecos";
    NSDictionary *data = @{@"selfHelpAddress" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddressDelete {
    NSString *pageName = @"pt:br:app:minhaconta:enderecos:excluir";
    NSDictionary *data = @{@"selfHelpAddressRemoved" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddressZipSearch {
    NSString *pageName = @"pt:br:app:minhaconta:enderecos:add-cep";
    NSDictionary *data = @{@"selfHelpAddressAddCep" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddressAddTry {
    NSString *pageName = @"pt:br:app:minhaconta:enderecos:add-form";
    NSDictionary *data = @{@"selfHelpAddressAddForm" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddressAdd {
    NSString *pageName = @"pt:br:app:minhaconta:enderecos:add-sucesso";
    NSDictionary *data = @{@"selfHelpAddressAddSuccess" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackPersonalDataEnter {
    NSString *pageName = @"pt:br:app:minhaconta:dados";
    NSDictionary *data = @{@"selfHelpRegister" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackPersonalDataUpdate {
    NSString *pageName = @"pt:br:app:minhaconta:dados-atualizado";
    NSDictionary *data = @{@"selfHelpRegisterUpdate" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

#pragma mark - Wishlist
+ (void)trackWishlistTour {
    NSString *pageName = @"pt:br:app:bookmark-open";
    NSDictionary *data = @{@"bookmarkOpen" : @1};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackRemoveProductsFromWishlistForSellerIds:(NSArray *)sellerIds SKUs:(NSArray *)skus {
    NSString *pageName = @"pt:br:app:bookmark-view:remove-bookmark";
    NSString *productsValue = @"";
    
    if (sellerIds.count != skus.count) {
        LogInfo(@"[Omniture] NOT TRACKING event %@ because seller ids and skus count are not the same", pageName);
        return;
    }
    
    for (NSUInteger counter = 0; counter < sellerIds.count; counter++) {
        NSString *sku = skus[counter] ?: @"";
        NSString *seller = sellerIds[counter] ?: @"";
        if ([seller isEqualToString:@"1"]) {
            seller = @"walmart";
        }
        
        if (productsValue.length != 0) {
            productsValue = [productsValue stringByAppendingString:@","];
        }
        productsValue = [productsValue stringByAppendingFormat:@"%@;%@", [WMOmniture removeSpacesAndSymbolsFromString:seller], sku];
    }
    
    NSDictionary *data = @{@"bookmarkRemove" : @1, wishlist_products_key : productsValue};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddToWishlistWithSellerId:(NSString *)sellerId sku:(NSNumber *)sku pageType:(NSString *)pageType {
    NSString *pageName = @"pt:br:app:add-to-bookmark";
    
    NSString *productString = [NSString stringWithFormat:@"%@;%@", [sellerId isEqualToString:@"1"] ? @"walmart" : sellerId ?: @"", sku.stringValue];
    productString = [self removeAccentuationFromString:productString];
    productString = [self removeSpacesAndSymbolsFromString:productString];
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    [mutableData setObject:@1 forKey:@"addToBookmark"];
    [mutableData setObject:productString ?: @"" forKey:@"&&product"];
    [mutableData setObject:pageType ?: @"" forKey:@"pageType"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, mutableData);
    [ADBMobile trackState:pageName data:mutableData];
}

+ (void)trackMoveProductsToPurchasedForSellerIds:(NSArray *)sellerIds SKUs:(NSArray *)skus {
    NSString *pageName = @"pt:br:app:bookmark-view:moved-to-purchased";
    NSString *productsValue = @"";
    
    if (sellerIds.count != skus.count) {
        LogInfo(@"[Omniture] NOT TRACKING event %@ because seller ids and skus count are not the same", pageName);
        return;
    }
    
    for (NSUInteger counter = 0; counter < sellerIds.count; counter++) {
        NSString *sku = skus[counter] ?: @"";
        NSString *seller = sellerIds[counter] ?: @"";
        if ([seller isEqualToString:@"1"]) {
            seller = @"walmart";
        }
        
        if (productsValue.length != 0) {
            productsValue = [productsValue stringByAppendingString:@","];
        }
        productsValue = [productsValue stringByAppendingFormat:@"%@;%@", [WMOmniture removeSpacesAndSymbolsFromString:seller], sku];
    }
    
    NSDictionary *data = @{@"bookmarkMove" : @1, wishlist_products_key : productsValue};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackRemoveFromWishlistWithSellerId:(NSString *)sellerId sku:(NSNumber *)sku pageType:(NSString *)pageType {
    NSString *productString = [NSString stringWithFormat:@"%@;%@", [sellerId isEqualToString:@"1"] ? @"walmart" : sellerId ?: @"" , sku.stringValue];
    productString = [self removeAccentuationFromString:productString];
    productString = [self removeSpacesAndSymbolsFromString:productString];
    
    NSString *pageName = @"pt:br:app:remove-from-bookmark";
    NSDictionary *data = @{@"removeFromBookmark" : @1,
                           @"&&product" : productString ?: @"",
                           @"pageType" : pageType ?: @""};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackAddToCartFromWishlistForSellerId:(NSString *)sellerId SKU:(NSString *)sku {
    NSString *pageName = @"pt:br:app:bookmark-view:add-product-to-cart";
    
    if ([sellerId isEqualToString:@"1"]) {
        sellerId = @"walmart";
    }
    NSString *productData = [NSString stringWithFormat:@"%@;%@", sellerId, sku];
    NSDictionary *data = @{@"bookmarkAddProduct" : @1, wishlist_products_key : productData};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackWarnMeFromWishlistForSellerId:(NSString *)sellerId SKU:(NSString *)sku {
    NSString *pageName = @"pt:br:app:bookmark-view:avise-me";
    
    if ([sellerId isEqualToString:@"1"]) {
        sellerId = @"walmart";
    }
    NSString *productData = [NSString stringWithFormat:@"%@;%@", sellerId, sku];
    NSDictionary *data = @{@"bookmartAviseMe" : @1, wishlist_products_key : productData};
    
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackWishlistProductsWithSellersIds:(NSArray *)sellersIds SKUs:(NSArray *)skus filterType:(NSString *)filterType lowerPrice:(BOOL)lowerPrice outOfStock:(BOOL)outOfStock {
    NSString *pageName = @"pt:br:app:bookmark-view";
    
    NSMutableString *productsValue = [NSMutableString new];
    if (sellersIds.count != skus.count) {
        LogInfo(@"[Omniture] NOT TRACKING event %@ because seller ids and skus count are not the same", pageName);
        return;
    }
    
    for (NSUInteger counter = 0; counter < sellersIds.count; counter++) {
        NSString *sku = skus[counter] ?: @"";
        NSString *seller = sellersIds[counter] ?: @"";
        if ([seller isEqualToString:@"1"]) {
            seller = @"walmart";
        }
        
        if (productsValue.length != 0) {
            [productsValue appendString:@","];
        }
        [productsValue appendFormat:@"%@;%@", [WMOmniture removeSpacesAndSymbolsFromString:seller], sku];
    }
    
    NSDictionary *data = @{@"bookmarkView" : @1,
                           @"lowerPrice" : @(lowerPrice),
                           @"bookmarkOutOfStock" : @(outOfStock),
                           wishlist_products_key : productsValue.copy,
                           @"qtyProducts" : @(skus.count),
                           @"filterType" : filterType ?: @""};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

#pragma mark - NSString
+ (NSString *)removeSpacesAndSymbolsFromString:(NSString *)str {
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [[str componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]] componentsJoinedByString:@""];
}

+ (NSString *)removeAccentuationFromString:(NSString *)str {
    NSData *strData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding];
}

#pragma mark - NSNumber

+ (NSString *)formattedNumberString:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.currencyDecimalSeparator = @".00";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [NSString stringWithFormat:@"%.2f", number.floatValue / 100];
}

#pragma mark - UTMI
+ (void)storeUTMIInMutableData:(NSMutableDictionary *)mutableData
{
    UTMIModel *utmi = [WMUTMIManager UTMI];
    if (utmi.section.length > 0 && [OFSetup enableUTMI])
    {
        NSString *utmiKey = utmi.typeFormatted;
        NSString *utmiValue = utmi.description;
        [mutableData setObject:utmiValue ?: @"" forKey:utmiKey];
        
        if (utmi.type == UTMITypeBan)
        {
            utmi.type = UTMITypeNav;
            utmiKey = utmi.typeFormatted;
            utmiValue = utmi.description;
            [mutableData setObject:utmiValue ?: @"" forKey:utmiKey];
        }
        
        [WMUTMIManager clean];
    }
}

#pragma mark - Credit Card Scan
+ (void)trackCreditCardScanProductPayment {
    NSString *pageName = @"pt:br:app:pagamento:leitor-cartao-produto";
    NSDictionary *data = @{@"cardProduct": @1};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackCreditCardScanWarrantyPayment {
    NSString *pageName = @"pt:br:app:pagamento:leitor-cartao-garantia";
    NSDictionary *data = @{@"cardWarranty": @1};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackCreditCardScanProductError {
    NSString *pageName = @"pt:br:app:pagamento:leitor-cartao-produto-error";
    NSDictionary *data = @{@"cardProductError": @1};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackCreditCardScanWarrantyError {
    NSString *pageName = @"pt:br:app:pagamento:leitor-cartao-garantia-error";
    NSDictionary *data = @{@"cardWarrantyError": @1};
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, data);
    [ADBMobile trackState:pageName data:data];
}

+ (void)trackCreditCardAdd {
    NSMutableDictionary *mutableData = [NSMutableDictionary new];

    [mutableData setObject:@1 forKey:@"cardScreenAdd"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];


}
+ (void)trackCreditCardSaved:(NSArray *)cards {
    
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"paymentCardSaved"];
    
    for (WBRCardModel *card in cards) {
        if ((card.defaultCard) && (card.expired)) {
            [mutableData setObject:@1 forKey:@"paymentCardSavedExpired"];
            break;
        }
    }
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];

}

+ (void)trackCreditCardAllowSaveToNextShop{
    NSMutableDictionary *mutableData = [NSMutableDictionary new];
    
    [mutableData setObject:@1 forKey:@"cardSaved"];
    
    NSString *pidUser = [WBRUser pid];
    if (pidUser.length > 0) {
        [mutableData setObject:pidUser forKey:pid_key];
    }
    
    LogInfo(@"[Omniture] Action: Data: %@", mutableData);
    [ADBMobile trackState:nil data:mutableData];

}

+ (void) trackOpenTicketSideMenu{
    NSString *pageName = @"pt:br:app:menu-lateral:atendimento";
    LogInfo(@"[Omniture] Action: %@", pageName);
    [ADBMobile trackState:pageName data:nil];
}

+ (void) trackOpenTicketProductStatus{
    NSString *pageName = @"pt:br:app:pedido:status-pedido:abrir-solicitacao";
    LogInfo(@"[Omniture] Action: %@", pageName);
    [ADBMobile trackState:pageName data:nil];
}

+ (void) trackEmptyTickets{
    NSString *pageName = @"pt:br:app:atendimento:meus-atendimentos-vazio";
    LogInfo(@"[Omniture] Action: %@", pageName);
    [ADBMobile trackState:pageName data:nil];
}

+ (void) trackOpenedTickets{
    NSString *pageName = @"pt:br:app:atendimento:meus-atendimentos";
    LogInfo(@"[Omniture] Action: %@", pageName);
    [ADBMobile trackState:pageName data:nil];
}

+ (void)trackReopenTicket {
    NSString *pageName = @"pt:br:app:atendimento:meus-atendimentos:reabrir-solicitacao";
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, nil);
    [ADBMobile trackState:pageName data:nil];
}

+ (void)trackOpenedTicketWithSuccess {
    NSString *pageName = @"pt:br:app:atendimento:meus-atendimentos:abrir-solicitacao-sucesso";
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, nil);
    [ADBMobile trackState:pageName data:nil];
}

+ (void)trackReopenedTicketWithSuccess {
    NSString *pageName = @"pt:br:app:atendimento:meus-atendimentos:reabrir-solicitacao-sucesso";
    LogInfo(@"[Omniture] Action: %@ - Data: %@", pageName, nil);
    [ADBMobile trackState:pageName data:nil];
}


@end
