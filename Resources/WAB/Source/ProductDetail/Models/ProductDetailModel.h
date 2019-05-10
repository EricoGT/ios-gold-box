//
//  ProductModel.h
//  Walmart
//
//  Created by Renan Cargnin on 9/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "SellerOptionModel.h"
#import "VariationNode.h"
#import "WBRRatingModel.h"
#import "WBRBestInstallment.h"

@interface ProductDetailModel : JSONModel

@property (strong, nonatomic) NSArray <Optional> *imagesIds;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber *standardSku;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) WBRRatingModel<Optional> *rating;

@property (strong, nonatomic) NSArray<SellerOptionModel> *sellerOptions;

@property (strong, nonatomic) NSNumber <Optional>*ratingValue;
@property (strong, nonatomic) NSNumber <Optional>*ratingTotal;

@property (strong, nonatomic) NSString <Optional>*stampUrl;
@property (strong, nonatomic) NSString <Optional>*stampTitle;
@property (strong, nonatomic) NSString <Optional>*stampDescription;
@property (strong, nonatomic) NSString <Optional>*stampFullDescription;
@property (strong, nonatomic) NSString <Optional>*deliveryStampUrl;

@property (strong, nonatomic) NSString <Optional>*optionsType;

@property (strong, nonatomic) VariationNode<Ignore> *variationsTree;

@property (assign, nonatomic) BOOL isFavorite;

@property (strong, nonatomic) NSNumber *departmentId;
@property (strong, nonatomic) NSNumber <Optional>*categoryId;
@property (strong, nonatomic) NSNumber <Optional>*subCategoryId;
@property (strong, nonatomic) NSNumber <Optional>*hasReview;

- (NSNumber *)defaultSKU;

- (SellerOptionModel *)defaultSeller;
- (NSArray *)otherSellers;
- (SellerOptionModel *)sellerWithId:(NSString *)sellerId;

- (BOOL)isAvailable;
- (BOOL)hasVariations;
- (BOOL)isReview;

@end
