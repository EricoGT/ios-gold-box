//
//  ModelBannerContent.m
//  Walmart
//
//  Created by Marcelo Santos on 4/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ModelBannerContent.h"

@implementation ModelBannerContent

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"imageURLString": @"imageUrl"}];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[ModelBannerContent class]] && [((ModelBannerContent *) object).name isEqualToString:_name];
}

- (NSUInteger)hash {
    return _name.hash + _imageURLString.hash + _target.hash + _productId.hash + _url.hash;
}

@end
