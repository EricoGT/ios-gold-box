//
//  ModelCampaignsTop.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelCampaignsTop
@end

@interface ModelCampaignsTop : JSONModel

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString <Optional> *url;
@property (strong, nonatomic) NSString <Optional> *target;
@property (strong, nonatomic) NSString <Optional> *productId;
@property (strong, nonatomic) NSString <Optional> *banner;

@end
