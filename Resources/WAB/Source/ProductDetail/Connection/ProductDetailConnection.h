//
//  ProductDetailConnection.h
//  Walmart
//
//  Created by Renan on 9/22/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@class ProductDetailModel, ExtendedWarrantyProduct, SellerOptionModel, VariationNode, WBRReviewsModel, ProductDetailModel;

@interface ProductDetailConnection : WMBaseConnection

- (void)loadProductDetailWithSKU:(NSString *)sku showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSDictionary *dictError))failure;

- (void)loadProductDetailWithProductId:(NSString *)productId showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSDictionary *dictError))failure;

- (void)loadVariationsTreeWithProductId:(NSString *)productId completionBlock:(void (^)(VariationNode *variationTree, NSString *baseImageURL))success failure:(void (^)(NSError *error))failure;

- (void)loadExtendedWarrantyWithSKU:(NSNumber *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice success:(void (^)(ExtendedWarrantyProduct *))success failure:(void (^)(NSError *))failure;

- (void)loadSellerOptionsWithSKU:(NSNumber *)sku success:(void (^)(NSArray *sellerOptions, ProductDetailModel *productDetail))success failure:(void (^)(NSError *error))failure;

- (void)loadProductReviews:(NSString *)productId pageNumber:(NSNumber *)pageNumber success:(void (^)(WBRReviewsModel *))success failure:(void (^)(NSDictionary *dictError))failure;
@end
