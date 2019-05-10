//
//  ModelBannerContent.h
//  Walmart
//
//  Created by Marcelo Santos on 4/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelBannerContent
@end

@interface ModelBannerContent : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) NSString <Optional> *target;
@property (strong, nonatomic) NSNumber <Optional> *productId;
@property (strong, nonatomic) NSString <Optional> *url;

@property (strong, nonatomic) UIImage <Ignore> *image;

@end
