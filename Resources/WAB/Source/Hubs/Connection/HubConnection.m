//
//  HubConnection.m
//  Walmart
//
//  Created by Renan on 7/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubConnection.h"

#import "HubCategory.h"
#import "SearchProductHubConnection.h"
#import "CategoryMenuItem.h"
#import "WishlistInteractor.h"

static NSString * const hubCategoriesJSONStr = @"{\"hubs\":[{\"url\":\"fq=C:144/151/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-e0b42-category-lavadoras-de-roupas.jpg\",\"text\":\"Lavadoras de Roupas\"},{\"url\":\"fq=C:144/148/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-86e84-category-geladeiras-refrigeradores.jpg\",\"text\":\"Geladeiras\"},{\"url\":\"fq=C:144/155/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-ad3b9-category-fogoes.jpg\",\"text\":\"Fogões\"},{\"url\":\"fq=C:144/147/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-8598e-category-micro-ondas.jpg\",\"text\":\"Micro-ondas\"},{\"url\":\"fq=C:144/151/453/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-2861b-category-lava-seca.jpg\",\"text\":\"Lava e Seca\"},{\"url\":\"fq=C:144/159/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-f3e01-category-lava-loucas.jpg\",\"text\":\"Lava-Louças\"},{\"url\":\"fq=C:144/156/\",\"categoryId\":\"144\",\"image\":\"https://napsao-nix-qa-imgres-01.qa.vmcommerce.intra:8080/imgres/160x160/walmartv5/hub/144-467cf-category-fornos.jpg\",\"text\":\"Fornos\"}]}";

@implementation HubConnection

- (void)loadHubCategoriesWithHubId:(NSString *)hubId loadSubmenu:(BOOL)loadSubmenu completionBlock:(void (^)(NSArray *categories, NSArray *otherCategories))success failure:(void (^)(NSError *error))failure
{
    OFUrls *urls = [OFUrls new];
    NSString *hubUrl = [urls getURLHub];
    hubUrl = [hubUrl stringByAppendingString:[NSString stringWithFormat:@"/%@", hubId]];
    
    if (loadSubmenu) {
        hubUrl = [hubUrl stringByAppendingString:@"?showSubmenu=true"];
    }
    
    NSURL *url = [NSURL URLWithString:hubUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.currentMockJSONStr = hubCategoriesJSONStr.copy;
    
    LogURL(@"Hub Categories URL: %@", request.URL);
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSArray *categories = [json objectForKey:@"hubs"];
        NSMutableArray *categoriesMutable = [NSMutableArray new];
        BOOL hasError = NO;
        
        for (NSDictionary *categoryDict in categories) {
            NSError *parserError;
            HubCategory *category = [[HubCategory alloc] initWithDictionary:categoryDict error:&parserError];
            
            if (parserError != nil)
            {
                hasError = YES;
            }
            else {
                [categoriesMutable addObject:category];
            }
        }
        
        if (hasError) {
            LogError *log = [LogError new];
            log.absolutRequest = url.absoluteString;
            log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
            log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
            log.screen = @"Hub Categories";
            log.fragment = @"loadHubCategoriesWithHubId:";
            [[OFLogService new] sendLog:log];
        }
        
        if (loadSubmenu) {
            NSDictionary *submenu = json[@"submenu"];
            NSArray *otherCategoriesDicts = submenu[@"items"];
            NSArray *otherCategories = [CategoryMenuItem arrayOfModelsFromDictionaries:otherCategoriesDicts error:nil];
            if (otherCategories) {
                if (success) success(categoriesMutable.copy, otherCategories);
            }
            else {
                LogError *log = [LogError new];
                log.absolutRequest = url.absoluteString;
                log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
                log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
                log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
                log.screen = @"Hub Categories";
                log.fragment = @"loadHubCategoriesWithHubId:";
                [[OFLogService new] sendLog:log];
                
                if (success) success(categoriesMutable.copy, nil);
            }
        }
        else {
            if (success) success(categoriesMutable.copy, nil);
        }
        
    } failure:^(NSError *error, NSData *data) {
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
        log.screen = @"Hub Categories";
        log.fragment = @"loadHubCategoriesWithHubId:";
        [[OFLogService new] sendLog:log];
        
        if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
    }];
}

- (void)loadOffersWithHubId:(NSString *)hubId completionBlock:(void (^)(NSArray *products))success failure:(void (^)(NSError *error))failure
{
    OFUrls *urls = [OFUrls new];
    NSString *offersURL = [urls getURLOffers];
    offersURL = [offersURL stringByAppendingString:[NSString stringWithFormat:@"%@", hubId]];
    
    NSURL *url = [NSURL URLWithString:offersURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    LogURL(@"HUB Offers URL: %@", request.URL);
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSArray *products = [SearchProductHubConnection arrayOfModelsFromDictionaries:json[@"products"] error:nil];
        
        if (products) {
            NSArray *wishlistSKUs = json[@"wishlist"];
            if (wishlistSKUs.count > 0) {
                NSSortDescriptor *productsSort = [NSSortDescriptor sortDescriptorWithKey:@"standardSku" ascending:YES];
                NSArray *sortedProducts = [products sortedArrayUsingDescriptors:@[productsSort]];
                NSArray *wishlistCorrespondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:wishlistSKUs sortedProductsSKUs:[sortedProducts valueForKey:@"standardSku"]];
                
                if (wishlistCorrespondanceArray.count == sortedProducts.count) {
                    for (NSInteger i = 0; i < sortedProducts.count; i++) {
                        SearchProductHubConnection *product = sortedProducts[i];
                        NSNumber *isFavorite = wishlistCorrespondanceArray[i];
                        product.wishlist = isFavorite.boolValue;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(products);
            });
        }
        else {
            LogError *log = [LogError new];
            log.absolutRequest = url.absoluteString;
            log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
            log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
            log.userMessage = HUB_OFFERS_ERROR;
            log.screen = @"HUB - Offers";
            log.fragment = @"loadOffersWithHubId:";
            [[OFLogService new] sendLog:log];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure([WMBaseConnection errorWithMessage:HUB_OFFERS_ERROR]);
            });
        }
        
    } failure:^(NSError *error, NSData *data) {
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = HUB_OFFERS_ERROR;
        log.screen = @"HUB - Offers";
        log.fragment = @"loadOffersWithHubId:";
        [[OFLogService new] sendLog:log];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure([WMBaseConnection errorWithMessage:HUB_OFFERS_ERROR]);
        });
    }];
}

@end
