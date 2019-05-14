//
//  WMCheckoutConnection.m
//  Walmart
//
//  Created by Bruno on 9/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMRetargetingConnection.h"
#import "ShowcaseTrackerModel.h"
#import "ShippingDelivery.h"
#import "ProductCategory.h"
#import "ShowcaseTrackerModel.h"
#import "WALShowcaseTrackerManager.h"
#import "ShippingDeliveries.h"
#import "CartItem.h"
#import "WBRUTM.h"

@implementation WMRetargetingConnection

//Tracks when user touch a department
- (void)trackDepartmentWithId:(NSString *)departmentId {
    
    NSMutableDictionary *infos = [NSMutableDictionary new];
    [infos setObject:departmentId ?: @"" forKey:@"departmentId"];
    NSString *serviceName = @"/track/department";
    
    NSURL *trackURL = [NSURL URLWithString:[[OFUrls new] getURLRetargetingDepartment]];
    LogURL(@"URL %@: %@",serviceName,trackURL);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infos.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONRepresentation = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogInfo(@"%@ Json: %@",serviceName,JSONRepresentation);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:trackURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"%@ success",serviceName);
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"%@ error : %@",serviceName,error.localizedDescription);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_TRACK_ORDER_ERR"
                                     andRequestUrl:trackURL.absoluteString
                                    andRequestData:JSONRepresentation
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", error]
                                    andUserMessage:@""
                                         andScreen:@"WMSubcategoriesViewController"
                                       andFragment:@"trackDepartmentWithId:"];
    }];
}

//Tracks when user touch a category
- (void)trackCategoryWithId:(NSString *)categoryId departmentId:(NSString *)departmentId {
    
    NSMutableDictionary *infos = [NSMutableDictionary new];
    [infos setObject:departmentId ?: @"" forKey:@"departmentId"];
    [infos setObject:categoryId ?: @"" forKey:@"categoryId"];
    NSString *serviceName = @"/track/category";
    
    NSURL *trackURL = [NSURL URLWithString:[[OFUrls new] getURLRetargetingCategory]];
    LogURL(@"URL %@: %@",serviceName,trackURL);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infos.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONRepresentation = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogInfo(@"%@ Json: %@",serviceName,JSONRepresentation);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:trackURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"%@ success",serviceName);
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"%@ error : %@",serviceName,error.localizedDescription);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_TRACK_ORDER_ERR"
                                     andRequestUrl:trackURL.absoluteString
                                    andRequestData:JSONRepresentation
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", error]
                                    andUserMessage:@""
                                         andScreen:@"WMSubcategoriesViewController"
                                       andFragment:@"trackCategoryWithId: departmentId:"];
    }];
}

//Tracks when user touch a subcategory
- (void)trackSubcategoryWithId:(NSString *)subcategoryId categoryId:(NSString *)categoryId departmentId:(NSString *)departmentId {
    NSMutableDictionary *infos = [NSMutableDictionary new];
    [infos setObject:departmentId ?: @"" forKey:@"departmentId"];
    [infos setObject:categoryId ?: @"" forKey:@"categoryId"];
    [infos setObject:subcategoryId ?: @"" forKey:@"subCategoryId"];
    NSString *serviceName = @"/track/subcategory";
    
    NSURL *trackURL = [NSURL URLWithString:[[OFUrls new] getURLRetargetingSubcategory]];
    LogURL(@"URL %@: %@",serviceName,trackURL);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infos.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONRepresentation = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogInfo(@"%@ Json: %@",serviceName,JSONRepresentation);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:trackURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"%@ success",serviceName);
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"%@ error : %@",serviceName,error.localizedDescription);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_TRACK_ORDER_ERR"
                                     andRequestUrl:trackURL.absoluteString
                                    andRequestData:JSONRepresentation
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", error]
                                    andUserMessage:@""
                                         andScreen:@"WMSubcategoriesViewController"
                                       andFragment:@"trackSubcategoryWithId: categoryId: departmentId:"];
    }];
}

//Tracks when user reach a new step in checkout. Possible steps: Cart, Address and Payment
- (void)trackCheckoutOrder:(NSDictionary *)source step:(CheckoutStep)step {
    
    NSMutableDictionary *trackDictionary;
    NSString *classNameForError;
    switch (step) {
        case CheckoutStepCart:
            trackDictionary = [self dictionaryForCartFromSouce:source];
            classNameForError = @"NewCartViewController";
            break;
        case CheckoutStepAddress:
            trackDictionary = [self dictionaryForAddressFromSouce:source[@"ShippingDeliveries"]];
            classNameForError = @"ShipmentOptions";
            break;
        case CheckoutStepPayment:
            trackDictionary = [self dictionaryForPaymentFromSouce:source];
            classNameForError = @"WBRPaymentViewController";
            break;
    }
    
    NSString *stepString = [self rawValueForStep:step];
    [trackDictionary setObject:stepString ?: @"" forKey:@"type"];
    ShowcaseTrackerModel *showcase = [WALShowcaseTrackerManager retrieveLastValidShowcaseTracking];
    if (showcase)
    {
        [trackDictionary setObject:showcase.showcaseId ?: @"" forKey:@"showcase"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trackDictionary.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONRepresentation = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogInfo(@"/checkout/track - %@ Json: %@",stepString, JSONRepresentation);
    
    NSURL *checkoutTrackURL = [NSURL URLWithString:[[OFUrls new] getURLRetargetingCheckout]];
    checkoutTrackURL = [WBRUTM addUTMQueryParameterTo:checkoutTrackURL];
    LogURL(@"URL /checkout/track - %@: %@",stepString, checkoutTrackURL);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:checkoutTrackURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];

    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"/checkout/track - %@ Success", stepString);
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"/checkout/track - %@ Error: %@",stepString,error.localizedDescription);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_TRACK_ORDER_ERR"
                                     andRequestUrl:checkoutTrackURL.absoluteString
                                    andRequestData:JSONRepresentation
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", error]
                                    andUserMessage:@""
                                         andScreen:classNameForError
                                       andFragment:@"trackCheckoutOrder: step:"];
    }];
}

//Tracks when there's a complete purchase
- (void)trackSuccessOrder:(NSDictionary *)order orderId:(NSNumber *)orderId {
    
    NSMutableDictionary *trackDictionary = [NSMutableDictionary new];
    [trackDictionary setObject:orderId ?: @"" forKey:@"orderId"];
    
    NSNumber *total = order[@"totalOrder"] ?: @(0);
    float totalPrice = total.floatValue / 100;
    [trackDictionary setObject:@(totalPrice) forKey:@"totalPrice"];
    
    NSMutableArray *products = [NSMutableArray new];
    NSArray *cartItems = order[@"cart"];
    for (NSDictionary *item in cartItems)
    {
        NSMutableDictionary *productDictionary = [NSMutableDictionary new];
        NSString *sku = item[@"sku"];
        if (sku)
        {
            NSNumber *aPrice = item[@"price"] ?: @(0);
            float price = aPrice.floatValue / 100;
            [productDictionary setObject:sku ?: @"" forKey:@"sku"];
            [productDictionary setObject:@(price) forKey:@"price"];
            [productDictionary setObject:item[@"quantity"] ?: @""  forKey:@"quantity"];
            [productDictionary setObject:item[@"sellerId"] ?: @"" forKey:@"sellerId"];
            [productDictionary setObject:item[@"departmentId"] ?: @"" forKey:@"department"];
            [productDictionary setObject:item[@"categoryId"] ?: @"" forKey:@"category"];
            [productDictionary setObject:item[@"subCategoryId"] ?: @"" forKey:@"subCategory"];
            [products addObject:productDictionary];
        }
    }
    
    [trackDictionary setObject:products.copy ?: [NSArray new] forKey:@"products"];
    ShowcaseTrackerModel *showcase = [WALShowcaseTrackerManager retrieveLastValidShowcaseTracking];
    if (showcase)
    {
        [trackDictionary setObject:showcase.showcaseId ?: @"" forKey:@"showcase"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trackDictionary.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONRepresentation = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogInfo(@"/order/track Json: %@", JSONRepresentation);
    
    NSURL *trackURL = [NSURL URLWithString:[[OFUrls new] getURLRetargetingOrderSuccess]];
    LogURL(@"URL /order/track: %@", trackURL);
    [WALShowcaseTrackerManager clean];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:trackURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"/order/track success");
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"/order/track error : %@", error.localizedDescription);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_TRACK_ORDER_ERR"
                                     andRequestUrl:trackURL.absoluteString
                                    andRequestData:JSONRepresentation
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", error]
                                    andUserMessage:@""
                                         andScreen:@"Success View Controller"
                                       andFragment:@"trackSuccessOrder: orderId:"];
    }];
}

#pragma mark - Helpers
- (NSMutableDictionary *)dictionaryForCartFromSouce:(NSDictionary *)source {
    
    NSMutableDictionary *trackDictionary = [NSMutableDictionary new];
    
    NSNumber *total = source[@"totalPrice"] ?: @(0);
    float totalPrice = total.floatValue / 100;
    [trackDictionary setObject:@(totalPrice) forKey:@"totalPrice"];
    
    NSMutableArray *products = [NSMutableArray new];
    NSArray *cartProducts = source[@"products"];
    for (NSDictionary *item in cartProducts)
    {
        NSMutableDictionary *productDictionary = [NSMutableDictionary new];
        NSString *sku = item[@"sku"];
        if (sku)
        {
            NSNumber *aPrice = item[@"price"] ?: @(0);
            float price = aPrice.floatValue / 100;
            [productDictionary setObject:sku ?: @"" forKey:@"sku"];
            [productDictionary setObject:@(price) forKey:@"price"];
            [productDictionary setObject:item[@"quantity"] ?: @""  forKey:@"quantity"];
            [productDictionary setObject:item[@"sellerId"] ?: @"" forKey:@"sellerId"];
            [productDictionary setObject:item[@"departmentId"] ?: @"" forKey:@"department"];
            [productDictionary setObject:item[@"categoryId"] ?: @"" forKey:@"category"];
            [productDictionary setObject:item[@"subCategoryId"] ?: @"" forKey:@"subCategory"];
            [products addObject:productDictionary];
        }
    }
    
    [trackDictionary setObject:products.copy ?: [NSArray new] forKey:@"products"];
    return trackDictionary;
}

- (NSMutableDictionary *)dictionaryForAddressFromSouce:(ShippingDeliveries *)delivery {
    
    NSMutableDictionary *trackDictionary = [NSMutableDictionary new];
    
    NSNumber *total = delivery.totalPrice ?: @(0);
    float totalPrice = total.floatValue / 100;
    [trackDictionary setObject:@(totalPrice) forKey:@"totalPrice"];
    
    NSMutableArray *products = [NSMutableArray new];
    NSArray *deliveries = delivery.deliveries;
    for (ShippingDelivery *delivery in deliveries)
    {
        for (CartItem *item in delivery.cartItems)
        {
            NSMutableDictionary *productDictionary = [NSMutableDictionary new];
            if (item.sku)
            {
                NSNumber *aPrice = item.price ?: @(0);
                float price = aPrice.floatValue / 100;
                [productDictionary setObject:item.sku ?: @"" forKey:@"sku"];
                [productDictionary setObject:@(price) forKey:@"price"];
                [productDictionary setObject:item.quantity ?: @""  forKey:@"quantity"];
                [productDictionary setObject:item.sellerId ?: @"" forKey:@"sellerId"];
                [productDictionary setObject:item.departmentId ?: @"" forKey:@"department"];
                [productDictionary setObject:item.categoryId ?: @"" forKey:@"category"];
                [productDictionary setObject:item.subCategoryId ?: @"" forKey:@"subCategory"];
                [products addObject:productDictionary];
            }
        }
    }
    
    [trackDictionary setObject:products.copy ?: [NSArray new] forKey:@"products"];
    return trackDictionary;
}

- (NSMutableDictionary *)dictionaryForPaymentFromSouce:(NSDictionary *)source {
    
    NSMutableDictionary *trackDictionary = [NSMutableDictionary new];
    NSDictionary *cart = source[@"cart"];
    NSNumber *total = cart[@"totalPrice"] ?: @(0);
    float totalPrice = total.floatValue / 100;
    [trackDictionary setObject:@(totalPrice) forKey:@"totalPrice"];
    
    NSMutableArray *products = [NSMutableArray new];
    NSArray *cartProducts = cart[@"items"];
    for (NSDictionary *item in cartProducts)
    {
        NSMutableDictionary *productDictionary = [NSMutableDictionary new];
        NSString *sku = item[@"sku"];
        if (sku)
        {
            NSNumber *aPrice = item[@"price"] ?: @(0);
            float price = aPrice.floatValue / 100;
            [productDictionary setObject:sku ?: @"" forKey:@"sku"];
            [productDictionary setObject:@(price) forKey:@"price"];
            [productDictionary setObject:item[@"quantity"] ?: @""  forKey:@"quantity"];
            [productDictionary setObject:item[@"sellerId"] ?: @"" forKey:@"sellerId"];
            [productDictionary setObject:item[@"departmentId"] ?: @"" forKey:@"department"];
            [productDictionary setObject:item[@"categoryId"] ?: @"" forKey:@"category"];
            [productDictionary setObject:item[@"subCategoryId"] ?: @"" forKey:@"subCategory"];
            [products addObject:productDictionary];
        }
    }
    
    [trackDictionary setObject:products.copy ?: [NSArray new] forKey:@"products"];
    return trackDictionary;
}

- (NSString *)rawValueForStep:(CheckoutStep)step {
    switch (step) {
        case CheckoutStepCart:
            return @"Cart";
            break;
        case CheckoutStepAddress:
            return @"Address";
            break;
        case CheckoutStepPayment:
            return @"PaymentMethod";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
