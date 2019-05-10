//
//  BannerModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "JSONModel.h"

@protocol BannerModel
@end

@interface BannerModel : JSONModel

@property (strong, nonatomic) NSString *banner;
@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) NSString <Optional> *target;
@property (strong, nonatomic) NSNumber <Optional> *productId;
@property (strong, nonatomic) NSString <Optional> *url;

@property (strong, nonatomic) UIImage <Ignore> *image;

@end
