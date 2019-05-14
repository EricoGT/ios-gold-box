//
//  ProductDetailConnection.m
//  Walmart
//
//  Created by Renan on 9/22/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "ProductDetailConnection.h"

#import "ProductDetailModel.h"
#import "ExtendedWarrantyProduct.h"
#import "WALFavoritesCache.h"

#import "WBRProduct.h"
#import "ProductUrls.h"
#import "WBRRetargeting.h"
#import "WBRSetupManager.h"
#import "WBRUTM.h"

#import "WBRReviewsModel.h"

#define USE_MOCK_RATING NO

@implementation ProductDetailConnection

- (void)loadProductDetailWithSKU:(NSString *)sku showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSDictionary *dictError))failure {
    NSString *basePath = [NSString stringWithFormat:@"%@/sku/%@", URL_PRODUCT_DETAIL, sku];
    [self loadProductWithBasePath:basePath showcaseId:showcaseId success:success failure:failure];
}

- (void)loadProductDetailWithProductId:(NSString *)productId showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSDictionary *dictError))failure {
    NSString *basePath = [NSString stringWithFormat:@"%@/product/%@", URL_PRODUCT_DETAIL, productId];
    [self loadProductWithBasePath:basePath showcaseId:showcaseId success:success failure:failure];
}


/**
 Track product to retargeting

 @param showcaseId Showcase id number.
 */
- (void)trackProductFromShowcase:(NSString *) showcaseId {

    LogInfo(@"[RETARGETING SHOWCASE] ID Showcase: %@", showcaseId);

    NSString *strParam = [NSString stringWithFormat:@"/webevent/pageaction.gif?PageType=Home&Event=clickShelfProduct&Action=CLICK&Source=%@&Shelf=%@", showcaseId, showcaseId];

    [[WBRRetargeting new] retargetingShowcases:[NSString stringWithFormat:@"%@%@", RETARGETING_TRACKING_URL, strParam] success:^(NSHTTPURLResponse *httpResponse) {
        LogRtg(@"[RETARGETING SHOWCASE] Success: %@", httpResponse);
    } failure:^(NSDictionary *dictError) {
        LogErro(@"[RETARGETING SHOWCASE] Error: %@", dictError);
    }];
}


- (void)loadProductWithBasePath:(NSString *)basePath showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSDictionary *dictError))failure {

    [self trackProductFromShowcase:showcaseId];

    [[WBRProduct new] getProductDetail:basePath showcaseId:showcaseId successBlock:^(NSData *jsonData) {
        
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        LogMicro(@"Json Product: %@", [dictJson objectForKey:@"product"]);
        
        NSError *parserError;
        ProductDetailModel *productDetail = [[ProductDetailModel alloc] initWithDictionary:dictJson[@"product"] error:&parserError];
        
        productDetail.variationsTree = [[VariationNode alloc] initWithOptionsType:productDetail.optionsType options:dictJson[@"product"][@"variations"]];
        productDetail.isFavorite = [WALFavoritesCache isFavorite:productDetail.standardSku];
        
        if (productDetail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(productDetail);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure (@{@"error" : ERROR_PARSE_DATABASE});;
            });
        }
    } failure:^(NSDictionary *dictError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (failure) failure(dictError);
        });
    }];
}

- (void)loadVariationsTreeWithProductId:(NSString *)productId completionBlock:(void (^)(VariationNode *variationTree, NSString *baseImageURL))success failure:(void (^)(NSError *error))failure {

    NSString *basePath = [NSString stringWithFormat:@"%@/product/%@", URL_PRODUCT_DETAIL, productId];

    [[WBRProduct new] getProductDetail:basePath showcaseId:@"" successBlock:^(NSData *jsonData) {

        dispatch_async(dispatch_get_main_queue(), ^{

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

            NSString *optionsType = json[@"product"][@"optionsType"];
            NSArray *variationsArray = json[@"product"][@"variations"];
            __block NSString *baseURL = @"";


            [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {

                baseURL = baseImagesModel.products ?: @"";
                baseURL = [baseURL stringByReplacingOccurrencesOfString:@" " withString:@""];

            } failure:^(NSDictionary *dictError) {
            }];

            VariationNode *variationsTree;
            if (optionsType.length > 0 && variationsArray.count > 0)
            {
                variationsTree = [[VariationNode alloc] initWithOptionsType:optionsType options:variationsArray];
            }


            if (success) success(variationsTree, baseURL);
        });

    } failure:^(NSDictionary *dictError) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure([self errorWithMessage:REQUEST_ERROR]);
        });
    }];
}

- (void)loadExtendedWarrantyWithSKU:(NSNumber *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice success:(void (^)(ExtendedWarrantyProduct *))success failure:(void (^)(NSError *))failure {

    [[WBRProduct new] getWarrantyProductDetail:sku.stringValue sellerId:sellerId sellPrice:sellPrice successBlock:^(NSData *jsonData) {

        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogMicro(@"[EXTENDED WARRANTY] dictJson: %@", dictJson);

        NSMutableArray *arrTemp = [NSMutableArray new];
        NSDictionary *dictExtendedEmpty = @{@"id":@0,
                                            @"name":@"",
                                            @"period":@0,
                                            @"price":@{@"installmentAmount":@0,
                                                       @"sellPrice":@0,
                                                       @"valuePerInstallment":@0
                                                       },
                                            @"type":@""
                                            };
        [arrTemp addObject:dictExtendedEmpty];

        NSArray *arrJson = dictJson[@"warranties"];
        for (int i=0;i<arrJson.count;i++) {
            [arrTemp addObject:[arrJson objectAtIndex:i]];
        }

        NSMutableDictionary *mutTemp = [NSMutableDictionary new];
        [mutTemp setValue:arrTemp forKey:@"warranties"];

        LogMicro(@"[EXTENDED WARRANTY] MutTemp: %@", mutTemp);

        NSError *parserError;
        
        ExtendedWarrantyProduct *product = [[ExtendedWarrantyProduct alloc] initWithDictionary:mutTemp error:&parserError];

        if (product) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(product);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure([self errorWithMessage:REQUEST_ERROR]);
            });
        }

    } failure:^(NSDictionary *dictError) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure([self errorWithMessage:REQUEST_ERROR]);
        });
    }];
}

- (void)loadSellerOptionsWithSKU:(NSNumber *)sku success:(void (^)(NSArray *, ProductDetailModel *))success failure:(void (^)(NSError *))failure {

    NSString *basePath = [NSString stringWithFormat:@"%@/sku/%@", URL_PRODUCT_DETAIL, sku];

    [[WBRProduct new] getProductDetail:basePath showcaseId:@"" successBlock:^(NSData *jsonData) {

        NSError *parserError;
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

        NSDictionary *dictProducts = [dictJson objectForKey:@"product"];

        //Get image ids from variations selected
        ProductDetailModel *productDetail = [[ProductDetailModel alloc] initWithDictionary:dictProducts error:&parserError];
        LogInfo(@"Imgs Ids: %@", productDetail.imagesIds);


        NSMutableArray *arrOffers = dictProducts[@"offers"];
        LogInfo(@"ARR Offers before: %@", arrOffers);

        //if count == 1?
        NSMutableDictionary *dictOffers = [NSMutableDictionary new];
        if (productDetail.imagesIds) {
            [dictOffers setObject:productDetail.imagesIds forKey:@"imageIds"];
        }

        NSDictionary *dictOffersOriginal = [arrOffers objectAtIndex:0];

        [dictOffers setObject:dictOffersOriginal[@"available"] forKey:@"available"];

        if (dictOffersOriginal[@"hasExtendedWarranty"]) {
            [dictOffers setObject:dictOffersOriginal[@"hasExtendedWarranty"] forKey:@"hasExtendedWarranty"];
        }

        [dictOffers setObject:dictOffersOriginal[@"price"] forKey:@"price"];

        if (dictOffersOriginal[@"seller"]) {
            [dictOffers setObject:dictOffersOriginal[@"seller"] forKey:@"seller"];
        }

        [dictOffers setObject:dictOffersOriginal[@"sku"] forKey:@"sku"];

        LogInfo(@"dictOffers after update images ids: %@", dictOffers);

        NSError *parserErrorSeller;
        NSArray *sellerOptions = [SellerOptionModel arrayOfModelsFromDictionaries:@[dictOffers] error:&parserErrorSeller];

        if (sellerOptions && !parserError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(sellerOptions, productDetail);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure([self errorWithMessage:REQUEST_ERROR]);
            });
        }
    } failure:^(NSDictionary *dictError) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure([self errorWithMessage:REQUEST_ERROR]);
        });
    }];
}

- (void)loadProductReviews:(NSString *)productId  pageNumber:(NSNumber *)pageNumber success:(void (^)(WBRReviewsModel *))success failure:(void (^)(NSDictionary *dictError))failure
{
    NSString *basePath = [NSString stringWithFormat:URL_PRODUCT_REVIEWS, productId, pageNumber];
    [[WBRProduct new] getProductReviews:basePath successBlock:^(NSData *jsonData) {
        NSError *parserError;
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        //Get image ids from variations selected
        WBRReviewsModel *productReviews = [[WBRReviewsModel alloc] initWithDictionary:dictJson error:&parserError];
        LogInfo(@"ProductId: %@", productReviews.productId);
        
        if (productReviews) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(productReviews);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(@{@"error" : REQUEST_ERROR});
            });
        }
        
    } failure:^(NSDictionary *dictError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(dictError);
        });
    }];
    
}

@end
