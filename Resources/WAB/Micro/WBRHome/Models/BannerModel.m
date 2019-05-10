//
//  BannerModel.m
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"imageURLString": @"imageUrl"}];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[BannerModel class]] && [((BannerModel *) object).banner isEqualToString:_banner];
}

- (NSUInteger)hash {
    return _banner.hash + _imageURLString.hash + _target.hash + _productId.hash + _url.hash;
}

@end
