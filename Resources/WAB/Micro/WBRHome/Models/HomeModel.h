//
//  HomeModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/18/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "WMBaseModel.h"

#import "BannerModel.h"
#import "ErrataModel.h"
#import "HomeSkinModel.h"
#import "ServicesModel.h"
#import "ShowcaseModel.h"

@interface HomeModel : WMBaseModel

@property (strong, nonatomic) NSArray<BannerModel, Optional> *topBanners;
@property (strong, nonatomic) NSArray<BannerModel, Optional> *bottomBanners;
@property (strong, nonatomic) NSArray<ShowcaseModel> *showcases;
//@property (strong, nonatomic) ErrataModel<Optional> *errata;
@property (strong, nonatomic) HomeSkinModel<Optional> *skin;

/**
 *  Returns the list of products with the specified SKU
 *
 *  @param NSNumber sku with the desired SKU
 *  @return NSArray with the list of products
 */
- (NSArray *)productsWithSKU:(NSNumber *)sku;

@end
