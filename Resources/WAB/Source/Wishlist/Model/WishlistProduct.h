//
//  WishlistProduct.h
//  Walmart
//
//  Created by Bruno on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "WishlistSellerOption.h"

@protocol WishlistProduct
@end

@interface WishlistProduct : JSONModel

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *skuId;
@property (nonatomic, strong) NSNumber <Optional>*skuPrice;
@property (nonatomic, strong) NSNumber *statusPrice;
@property (nonatomic, strong) NSNumber *bought;
//@property (nonatomic, assign) BOOL bought;
@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSArray<WishlistSellerOption> *sellerOptions;

- (BOOL)isLowPrice;
- (BOOL)isOutOfStock;
- (BOOL)hasExtendedWarranty;

- (WishlistSellerOption *)defaultSellerOption;
- (NSString *)defaultName;
- (NSNumber *)defaultSKU;
- (NSString *)firstImageId;
- (NSNumber *)discountPrice;


@end
